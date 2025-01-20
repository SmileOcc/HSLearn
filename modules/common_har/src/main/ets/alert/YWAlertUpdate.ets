import { common } from '@kit.AbilityKit';
import { hsLog } from '@learn/logger_har';

const TAG = "YWAlertUpdate"

@CustomDialog
export struct YWAlertUpdate {
  @State currentVersion: string = ''
  @State richTextData: string = ''
  @State lastVersion: string = ''
  @State updateContent: string = ''
  @State versionName: string = ""
  private context?: common.UIAbilityContext;
  private customDialogController?: CustomDialogController

  async aboutToAppear() {
    this.context = getContext(this) as common.UIAbilityContext
    // this.richTextData = await dialogFeature.getRichTextData(this.context)
    // hsLog.i(TAG, `this.richTextData = ${this.richTextData}`)
    await this.getData()
  }

  async getData() {
    // try {
    //   this.currentVersion = await dialogFeature.getCurrentVersion()
    //   let requestResponseContent: RequestResponseContent = await dialogFeature.getLastVersion()
    //   if (requestResponseContent.content === null || requestResponseContent.content === undefined) {
    //     return
    //   }
    //   this.updateContent = requestResponseContent.content
    //   if (requestResponseContent.versionName === null || requestResponseContent.versionName === undefined) {
    //     return
    //   }
    //   this.lastVersion = requestResponseContent.versionName
    // } catch (err) {
    //   hsLog.i(TAG, `getApplicationVersion is fail`)
    // }
  }

  build() {
    Stack() {
      // mask 遮罩层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#000000')
        .opacity(.4)
      Column() {
        Stack({ alignContent: Alignment.TopStart }) {
          Text($r('app.string.update_title'))
            .fontSize(30)
            .fontColor('#FFFFFF')
            .fontWeight(500)
            .margin({ top: 70, left: 76 })

          Text(`V${(this.lastVersion || this.versionName)}`)
            .fontSize(16)
            .backgroundColor('#FFFFFF')
            .textAlign(TextAlign.Center)
            .fontColor('#E9304E')
            .borderRadius(20)
            .width(80)
            .aspectRatio(2.8)
            .margin({ top: 110, left: 76 })

          Column() {
            // 富文本容器
            Scroll() {
              Column() {
                if (this.richTextData) {
                  RichText((this.updateContent || this.richTextData))
                    .width('100%')
                    .height('100%')
                }
              }
              .width('100%')
            }
            .height(200)

            Row() {
              Button($r('app.string.cancel'))
                .commonButtonStyle()
                .fontSize(20)
                .margin({ left: 10 })
                .fontColor('#E92F4F')
                .backgroundColor('rgba(0,0,0,0.05)')
                .margin({ right: 10 })
                .onClick(() => {
                  this.customDialogController?.close()
                })
                .key("cancel")

              Button($r('app.string.update_now'))
                .commonButtonStyle()
                .fontSize(20)
                .margin({ right: 10 })
                .fontColor('#FFFFFF')
                .backgroundColor('#E92F4F')
                .margin({ left: 10 })
                .onClick(() => {
                  this.customDialogController?.close()
                })
                .key("Now")
            }
            .margin({ top: 30 })
          }
          .width('100%')
          .padding({ left: 25, right: 25 })
          .margin({ top: 230 })
        }
        .height(600)
        .width('80%')
        // .backgroundImage($r('app.media.update'), ImageRepeat.NoRepeat)
        .backgroundColor(Color.White)
        .backgroundImageSize(ImageSize.Contain)
      }
      .width(480)
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
  }

  @Styles
  commonButtonStyle() {
    .height(45)
    .padding({ top: 20, right: 20, left: 20 })
    .backgroundColor(Color.Yellow)
    .borderRadius(12)
  }

}
