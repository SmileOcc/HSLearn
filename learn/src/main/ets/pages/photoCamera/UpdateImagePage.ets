import { picker } from '@kit.CoreFileKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
// 第二步：将文件保存到鸿蒙系统的缓存目录
import fs from '@ohos.file.fs';
import { request } from '@kit.BasicServicesKit';
import { KLogger, YWShowToast } from '@learn/common_har';


@Entry
@Component
struct UpdateImagePage {
  @State message: string = '图片上传';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('UpdateImagePageHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }

  //第一步：定义图片选择Picker的配置、创建图片选择对象并选择图片
  // 用户选择系统中的一个图片返回
  async pickerAvatar() {
    // 1.1 引导用户选择一张系统相册的照片
    // 实例化选项对象
    const options = new photoAccessHelper.PhotoSelectOptions()
    // 过滤选择媒体文件类型为IMAGE——只能选择图片类型的资源
    options.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
    // 只能选择一张系统相册中的照片
    options.maxSelectNumber = 1
    // 1.2 创建图片选择对象并选择图片
    // 利用PhotoViewPicker对象实例中的select自动获取到用户选择的那张图片的地址
    const pickerView = new photoAccessHelper.PhotoViewPicker()
    let urls = await pickerView.select(options)
    if (urls.photoUris.length <= 0) {
      return
    }
    let imgUri = urls.photoUris[0]
    // AlertDialog.show({ message: JSON.stringify(urls) })
    return imgUri
  }

  // 第二步（拷）小结：
  //
  // 用上下文获取当前应用的缓存目录-> getContext().cacheDir
  // 利用Date.now() 和 Math.random()结合随机生成图片名字filename，扩展名为jpg
  // 利用 fs.openSync方法打开图片，准备拷贝到缓存目录 ->const file = fs.openSync(uri, fs.OpenMode.READ_ONLY)
  // 利用fs.copyFileSync(file.fd, fullPath) 拷贝文件到缓存目录

  async imageCopy(uri:string) {
    // 2.将文件保存到缓存目录(只能上传在缓存目录中的文件)
    const context = getContext(this)
    const fileType = 'jpg'
    // （以时间戳）生成一个新的文件名
    const fileName = Date.now() + '.' + fileType
    // 通过缓存路径+文件名 拼接出完整的路径
    const copyFilePath = context.cacheDir + '/' + fileName
    // 将文件 拷贝到 临时目录
    const file = fs.openSync(uri, fs.OpenMode.READ_ONLY)
    fs.copyFileSync(file.fd, copyFilePath)
  }

  async uploadAvatar(filePath:string, fileName:string) {
    let token = AppStorage.get('token') as string ?? ""

    let uploader = await request.uploadFile(getContext(), {
      method:'POST',
      url:'https//api-test/avatar',
      header:{
        'Content-Type':'multipart/form-data',
        'Authorization':`Bearer ${token}`
      },
      files:[{
        filename: fileName,
        type:'jpg',
        name:'file',
        uri:filePath
      }],
      data:[]
    })

    //监听上传进度
    uploader.on('progress',(uploadedSize,totalSize) => {
      KLogger.info('上传大小：' + uploadedSize, '总大小：' + totalSize)

      if (uploadedSize === totalSize) {
        YWShowToast("上传完成")
      }
    })
  }

}