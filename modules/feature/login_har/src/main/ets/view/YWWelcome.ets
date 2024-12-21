/*
 * @Desc:
 */
import { YWResColor, YWResFloat, YWResImage, YWResString } from '@learn/res_har';
import { KLogger } from '@learn/common_har';

const TAG = 'YWWelcome';

@Component
export struct YWWelcome {
  build() {
    Column() {
      Row() {
        Image(YWResImage.appIcon())
          .width(30)
          .height(30)
          .borderRadius(15)
          .draggable(false)
          .copyOption(CopyOptions.None)
          .onComplete(() => {
            KLogger.info(TAG, 'appIcon loading success');
          })
          .onError(() => {
            KLogger.error(TAG, 'appIcon loading fail');
          })

        Text('HI 欢迎您～')
          .fontWeight(FontWeight.Medium)
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .fontColor(YWResColor.main())
          .fontSize(YWResFloat.fontMain())
          .margin({ left: 12, })
      }
      .alignItems(VerticalAlign.Center)


      Text('开心每一天！')
        .fontSize(YWResFloat.fontDesc())
        .fontColor(YWResColor.desc())
        .constraintSize({ maxWidth: '100%' })
        .margin({ top: 20, })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .margin({ top: 100 })
  }
}