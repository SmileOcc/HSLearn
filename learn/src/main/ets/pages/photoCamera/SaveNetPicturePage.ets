import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import fs from '@ohos.file.fs'
import { picker } from '@kit.CoreFileKit';

@Entry
@Component
struct SaveNetPicturePage {
  @State message: string = '图片保存';

  imageBuffer:ArrayBuffer|undefined
  image:PixelMap|undefined
  isShow = false

  imgurl = 'https://inews.gtimg.com/om_bt/O6SG7dHjdG0kWNyWz6WPo2_3v6A6eAC9ThTazwlKPO1qMAA/641'

  aboutToAppear(): void {

    this.reuqestImage()
  }

  save() {

    this.saveImage(this.imageBuffer!)
      .then(()=>{
        promptAction.showToast({
          message: '保存图片成功',
          duration: 2000
        })
      })
      .catch((err:Error)=>{
        promptAction.showToast({
          message: '=保存图片失败',
          duration: 2000
        })
      })
  }

  saveFile() {
    this.pickerSave(this.imageBuffer!)
      .then(()=>{
        promptAction.showToast({
          message: '保存图片成功',
          duration: 2000
        })
      })
      .catch(()=>{
        promptAction.showToast({
          message: '=保存图片失败',
          duration: 2000
        })
      })
  }


  reuqestImage() {
    http.createHttp()
      .request(this.imgurl,
        (error: BusinessError, data: http.HttpResponse) => {
          if (error) {
            promptAction.showToast({
              message: '加载图片失败',
              duration: 2000
            })
            return
          }
          promptAction.showToast({
            message: '加载图片成功',
            duration: 2000
          })
          this.transcodePixelMap(data);
          if (data.result instanceof ArrayBuffer) {
            this.imageBuffer = data.result as ArrayBuffer;
          }
        })

  }

  // 将ArrayBuffer类型的图片装换为PixelMap类型
  transcodePixelMap(data: http.HttpResponse) {
    let code: http.ResponseCode | number = data.responseCode;
    if (200 === code) {
      let imageData: ArrayBuffer = data.result as ArrayBuffer;
      let imageSource: image.ImageSource = image.createImageSource(imageData);

      class tmp {
        height: number = 100;
        width: number = 100;
      };

      let options: Record<string, number | boolean | tmp> = {
        'alphaType': 0, // 透明度
        'editable': false, // 是否可编辑
        'pixelFormat': 3, // 像素格式
        'scaleMode': 1, // 缩略值
        'size': { height: 100, width: 100 }
      }; // 创建图片大小

      imageSource.createPixelMap(options).then((pixelMap: PixelMap) => {
        this.image = pixelMap;
        this.isShow = true
      });
    }
  }

  // 需要申请 需要申请ACL权限  ohos.permission.READ_IMAGEVIDEO
  //使用getPhotoAccessHelper、createAsset、fs.open、fs.write等接口将数据存到本地图库中
  async saveImage(buffer: ArrayBuffer | string): Promise<void> {
    let context = getContext(this) as common.UIAbilityContext;
    let helper = photoAccessHelper.getPhotoAccessHelper(context);
    let uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg');
    let file = await fs.open(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    await fs.write(file.fd, buffer);
    await fs.close(file.fd);
  }


  //使用photoViewPicker.save、fs.open、fs.write等接口将数据存到用户选择路径的数据库中

  async pickerSave(buffer: ArrayBuffer | string): Promise<void> {
    const photoSaveOptions = new picker.PhotoSaveOptions(); // 创建文件管理器保存选项实例
    photoSaveOptions.newFileNames = ['PhotoViewPicker ' + new Date().getTime() + 'jpg'] // 保存文件名（可选）
    const photoViewPicker = new picker.PhotoViewPicker;
    photoViewPicker.save(photoSaveOptions)
      .then(async (photoSvaeResult) => {
        console.info('PhotoViewPicker.save successfully,photoSvaeResult uri:' + JSON.stringify(photoSvaeResult));
        let uri = photoSvaeResult[0];
        let file = await fs.open(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        await fs.write(file.fd, buffer);
        await fs.close(file.fd);
        promptAction.showToast({
          message: 'image success',
          duration: 2000
        })
      })
  }


  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Image(this.image)
          .size({width:100,height:100})
          .backgroundColor(Color.Orange)

        Button('保存相册')
          .onClick(()=>{
            this.save()
          })
        Button('保存到对应的路径')
          .onClick(()=>{
            this.save()
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}