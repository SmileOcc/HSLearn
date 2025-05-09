import { BusinessError } from '@kit.BasicServicesKit';
import MediaFileUri from './MediaFileUri';
import fs from '@ohos.file.fs'
import { image } from '@kit.ImageKit';
import { fileUri } from '@kit.CoreFileKit';
import { router } from '@kit.ArkUI';
import { ImageRouterModel } from './ImageRouterModel';
import { fileIo } from '@kit.CoreFileKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';


const TAG = 'PhotoCroppingPage';
const BYTE_CONVERSION: number = 1024; // 字节转换
// 压缩后的图片信息类，用于刷新显示压缩后的图片和图片字节长度
class CompressedImageInfo {
  imageUri: string = ""; // 压缩后图片保存位置的uri
  imageByteLength: number = 0; // 压缩后图片字节长度
}

@Entry
@Component
struct PhotoCroppingPage {
  @State imageUri : string = '' //原始路径
  @State compressedImageSrc: string = ''; // 压缩后的图片路径
  @State beforeCompressionSize: number = 0; // 压缩前的图片字节长度
  @State compressedByteLength: number = 0; // 压缩的图片字节长度
  @State maxCompressedImageSize: string = "200"; // 指定图片压缩目标大小，单位kb
  mediaFileUri: MediaFileUri = new MediaFileUri();
  myFileName: string = '';
  myFileSize: number = 0;

  aboutToAppear(): void {
    const params: ImageRouterModel = router.getParams() as ImageRouterModel; // 获取传递过来的参数对象
    this.imageUri = params.uri
    this.beforeCompressionSize = this.mediaFileUri.myGetFileSize(this.imageUri, fileIo.OpenMode.READ_ONLY);
  }

  build() {
    Column({space : 20}) {
      Row(){
        TextInput({placeholder:'输入要压缩后最大尺寸（单位K）默认200K' , text : $$this.maxCompressedImageSize})
          .layoutWeight(1)
          .height(35)
          .type(InputType.Number)
        Button('压缩')
          .width(100)
          .height(35)
          .onClick(() => {
            this.startCompressed()
          })
      }.padding({left : 15 , right : 15})
      Text('原始size: ' + this.beforeCompressionSize + "B")
      Image(this.imageUri).width('100%').height("40%")
        .objectFit(ImageFit.Contain)

      if (this.compressedImageSrc) {
        Text('压缩后的size: ' + this.compressedByteLength + "B")
        Image(this.compressedImageSrc).width('100%').height("40%")
          .objectFit(ImageFit.Contain)

      }
    }
    .width('100%')
    .padding({top: 40})
    .height('100%')
  }

  // 开始压缩
  startCompressed() {
    if (this.beforeCompressionSize < 1024 * parseInt(this.maxCompressedImageSize)) {
      this.compressedImageSrc = this.imageUri;
      this.compressedByteLength = this.beforeCompressionSize;
      return
    }
    // Stage模型参考如下代码
    const file : fs.File = fs.openSync(this.imageUri , fs.OpenMode.READ_WRITE);
    const fd : number = file?.fd;
    const imageSource : image.ImageSource = image.createImageSource(fd);

    let decodingOptions : image.DecodingOptions = {
      editable: true,
      desiredPixelFormat: 3,
    }

    // 创建pixelMap
    imageSource.createPixelMap(decodingOptions).then((originalPixelMap: image.PixelMap) => {
      // 压缩图片
      compressedImage(originalPixelMap,  parseInt(this.maxCompressedImageSize)).then((showImage: CompressedImageInfo) => {
        // 获取压缩后的图片信息
        this.compressedImageSrc = fileUri.getUriFromPath(showImage.imageUri);
        this.compressedByteLength = showImage.imageByteLength;
      })
    }).catch((err: BusinessError) => {
      console.error(TAG, `Failed to create PixelMap with error message: ${err.message}, error code: ${err.code}`);
    });
  }

  // 图片压缩
  async  compressImage(uri:string,qualityParam:number){
    // 先获取相册中的图片
    // await this.example()

    // 根据 uri 打开图片文件
    const file = fileIo.openSync(uri)
    // 创建图片源实例（根据文件 fd 创建）
    const imageSource = image.createImageSource(file.fd)
    // 图片打包器（主要用于图片压缩）
    const imagePacker = image.createImagePacker()
    // 图片压缩核心 API： imagePacker.packing()
    // arrayBuffer 二进制文件数据流信息，quality 控制压缩的质量（值越大图片越大，值小->图片文件小）
    const arrayBuffer = await imagePacker.packing(imageSource, {format:'image/jpeg',quality:qualityParam})
    // AlertDialog.show({ message:JSON.stringify({ arrayBufferByteLength: arrayBuffer.byteLength },null,2) })
    AlertDialog.show({message:'压缩后大小（单位字节）：' + arrayBuffer.byteLength})
    // ————————————————————————————————————————————————————————————————————————
    const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext())
    // 创建新的图片资源，返回图片资源的 uri
    const assetUri = await phAccessHelper.createAsset(photoAccessHelper.PhotoType.IMAGE,'jpg')
    // 根据Uri打开文件，注意：由于需要写入图片 arrayBuffer，所以在打开时，还需要设置打开模式为可写 READ_WRITE
    const assetFile = fileIo.openSync(assetUri, fileIo.OpenMode.WRITE_ONLY)
    // 往打开的文件写入arrayBuffer
    fileIo.writeSync(assetFile.fd,arrayBuffer)
    // 写完后，主动关闭文件
    fileIo.close(assetFile.fd)
  }
}

/**
 * 图片压缩，保存
 * @param sourcePixelMap：原始待压缩图片的PixelMap对象
 * @param maxCompressedImageSize：指定图片的压缩目标大小，单位kb
 * @returns compressedImageInfo：返回最终压缩后的图片信息
 */
async function compressedImage(sourcePixelMap: PixelMap, maxCompressedImageSize: number): Promise<CompressedImageInfo> {
  // 创建图像编码ImagePacker对象
  let imagePackerApi = image.createImagePacker();
  // 定义图片质量参数
  let imageQuality = 0;
  // 设置编码输出流和编码参数。图片质量参数quality范围0-100。
  let packOpts: image.PackingOption = { format: "image/jpeg", quality: imageQuality };
  // 通过PixelMap进行编码。compressedImageData为打包获取到的图片文件流。
  let compressedImageData: ArrayBuffer = await imagePackerApi.packing(sourcePixelMap, packOpts);
  // 压缩目标图像字节长度
  let maxCompressedImageByte = maxCompressedImageSize * BYTE_CONVERSION;
  // TODO 知识点：图片压缩。先判断设置图片质量参数quality为0时，packing能压缩到的图片最小字节大小是否满足指定的图片压缩大小。如果满足，则使用packing方式二分查找最接近指定图片压缩目标大小的quality来压缩图片。如果不满足，则使用scale对图片先进行缩放，采用while循环每次递减0.4倍缩放图片，再用packing（图片质量参数quality设置0）获取压缩图片大小，最终查找到最接近指定图片压缩目标大小的缩放倍数的图片压缩数据。
  if (maxCompressedImageByte > compressedImageData.byteLength) {
    // 使用packing二分压缩获取图片文件流
    compressedImageData = await packingImage(compressedImageData, sourcePixelMap, imageQuality, maxCompressedImageByte);
  } else {
    // 使用scale对图片先进行缩放，采用while循环每次递减0.4倍缩放图片，再用packing（图片质量参数quality设置0）获取压缩图片大小，最终查找到最接近指定图片压缩目标大小的缩放倍数的图片压缩数据
    let imageScale = 1; // 定义图片宽高的缩放倍数，1表示原比例。
    let reduceScale = 0.4; // 图片缩小倍数
    // 判断压缩后的图片大小是否大于指定图片的压缩目标大小，如果大于，继续降低缩放倍数压缩。
    while (compressedImageData.byteLength > maxCompressedImageByte) {
      if (imageScale > 0) {
        // 性能知识点: 由于scale会直接修改图片PixelMap数据，所以不适用二分查找scale缩放倍数。这里采用循环递减0.4倍缩放图片，来查找确定最适
        // 合的缩放倍数。如果对图片压缩质量要求不高，建议调高每次递减的缩放倍数reduceScale，减少循环，提升scale压缩性能。
        imageScale = imageScale - reduceScale; // 每次缩放倍数减0.4
        // 使用scale对图片进行缩放
        await sourcePixelMap.scale(imageScale, imageScale);
        // packing压缩
        compressedImageData = await packing(sourcePixelMap, imageQuality);
      } else {
        // imageScale缩放小于等于0时，没有意义，结束压缩。这里不考虑图片缩放倍数小于reduceScale的情况。
        break;
      }
    }
  }
  // 保存图片，返回压缩后的图片信息。
  let compressedImageInfo: CompressedImageInfo = await saveImage(compressedImageData);
  return compressedImageInfo;
}

/**
 * packing压缩
 * @param sourcePixelMap：原始待压缩图片的PixelMap
 * @param imageQuality：图片质量参数
 * @returns data：返回压缩后的图片数据
 */
async function packing(sourcePixelMap: PixelMap, imageQuality: number): Promise<ArrayBuffer> {
  let imagePackerApi = image.createImagePacker();
  let packOpts: image.PackingOption = { format: "image/jpeg", quality: imageQuality };
  let data: ArrayBuffer = await imagePackerApi.packing(sourcePixelMap, packOpts);
  return data;
}


/**
 * packing二分方式循环压缩
 * @param compressedImageData：图片压缩的ArrayBuffer
 * @param sourcePixelMap：原始待压缩图片的PixelMap
 * @param imageQuality：图片质量参数
 * @param maxCompressedImageByte：压缩目标图像字节长度
 * @returns compressedImageData：返回二分packing压缩后的图片数据
 */
async function packingImage(compressedImageData: ArrayBuffer, sourcePixelMap: PixelMap, imageQuality: number, maxCompressedImageByte: number): Promise<ArrayBuffer> {
  // 图片质量参数范围为0-100，这里以10为最小二分单位创建用于packing二分图片质量参数的数组。
  let packingArray: number[] = [];
  let dichotomyAccuracy = 10;
  // 性能知识点: 如果对图片压缩质量要求不高，建议调高最小二分单位dichotomyAccuracy，减少循环，提升packing压缩性能。
  for (let i = 0; i <= 100; i += dichotomyAccuracy) {
    packingArray.push(i);
  }
  let left = 0; // 定义二分搜索范围的左边界
  let right = packingArray.length - 1; // 定义二分搜索范围的右边界
  // 二分压缩图片
  while (left <= right) {
    let mid = Math.floor((left + right) / 2); // 定义二分搜索范围的中间位置
    imageQuality = packingArray[mid]; // 获取二分中间位置的图片质量值
    // 根据传入的图片质量参数进行packing压缩，返回压缩后的图片文件流数据。
    compressedImageData = await packing(sourcePixelMap, imageQuality);
    // 判断查找一个尽可能接近但不超过压缩目标的压缩大小
    if (compressedImageData.byteLength <= maxCompressedImageByte) {
      // 二分目标值在右半边，继续在更高的图片质量参数（即mid + 1）中搜索
      left = mid + 1;
      // 判断mid是否已经二分到最后，如果二分完了，退出
      if (mid === packingArray.length - 1) {
        break;
      }
      // 获取下一次二分的图片质量参数（mid+1）压缩的图片文件流数据
      compressedImageData = await packing(sourcePixelMap, packingArray[mid + 1]);
      // 判断用下一次图片质量参数（mid+1）压缩的图片大小是否大于指定图片的压缩目标大小。如果大于，说明当前图片质量参数（mid）压缩出来的
      // 图片大小最接近指定图片的压缩目标大小。传入当前图片质量参数mid，得到最终目标图片压缩数据。
      if (compressedImageData.byteLength > maxCompressedImageByte) {
        compressedImageData = await packing(sourcePixelMap, packingArray[mid]);
        break;
      }
    } else {
      // 目标值不在当前范围的右半部分，将搜索范围的右边界向左移动，以缩小搜索范围并继续在下一次迭代中查找左半部分。
      right = mid - 1;
    }
  }
  return compressedImageData;
}

/**
 * 图片保存
 * @param compressedImageData：压缩后的图片数据
 * @returns compressedImageInfo：返回压缩后的图片信息
 */
async function saveImage(compressedImageData: ArrayBuffer): Promise<CompressedImageInfo> {
  let context: Context = getContext();
  // 定义要保存的压缩图片uri。afterCompressiona.jpeg表示压缩后的图片。
  let compressedImageUri: string = context.filesDir + '/' + 'afterCompressiona.jpeg';
  try {
    let res = fs.accessSync(compressedImageUri);
    if (res) {
      // 如果图片afterCompressiona.jpeg已存在，则删除
      fs.unlinkSync(compressedImageUri);
    }
  } catch (err) {
    console.error(TAG, `AccessSync failed with error message: ${err.message}, error code: ${err.code}`);
  }
  // TODO 知识点：保存图片。获取最终图片压缩数据compressedImageData，保存图片。
  // 压缩图片数据写入文件
  let file: fs.File = fs.openSync(compressedImageUri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.writeSync(file.fd, compressedImageData);
  fs.closeSync(file);
  // 获取压缩图片信息
  let compressedImageInfo: CompressedImageInfo = new CompressedImageInfo();
  compressedImageInfo.imageUri = compressedImageUri;
  compressedImageInfo.imageByteLength = compressedImageData.byteLength;
  return compressedImageInfo;
}
