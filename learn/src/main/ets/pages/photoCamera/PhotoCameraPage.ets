import { cameraCapture } from '../../../../../../modules/common_har/src/main/ets/utils/CameraUtils';
import { common } from '@kit.AbilityKit';
import { ImageRouterModel } from './ImageRouterModel';
import { router } from '@kit.ArkUI';
import picker from '@ohos.file.picker'

@Entry
@Component
struct PhotoCameraPage {
  @State message: string = 'Hello World';

  @State uri: string = '';

  build() {
    Row() {
      Column({space : 30}) {
        /*
         * 调用系统相机拍照获取相机图片后拿到uri传入下一页面
         *
         * */
        Text("相机拍照选择图片")
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {

            let image: string = await cameraCapture(getContext(this) as common.UIAbilityContext);
            let param: ImageRouterModel = new ImageRouterModel()
            param.uri = image
            router.pushUrl({
              url: 'pages/photoCamera/PhotoCroppingPage',
              params: param
            })
          })
        /*
         * 调用系统图库获取图片后拿到uri传入下一页面，默认一次只选择一张图片
         *
         * */
        Text("相册选择图片")
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            const photoPicker = new picker.PhotoViewPicker()
            const result = await photoPicker.select({
              MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
              maxSelectNumber: 1
            })
            // 循环数组
            if (result.photoUris?.length) {
              let param: ImageRouterModel = new ImageRouterModel()
              param.uri = result.photoUris[0]
              router.pushUrl({
                url: 'pages/photoCamera/PhotoCroppingPage',
                params: param
              })
            }

          })
      }
      .width('100%')
    }
    .height('100%')
  }
}