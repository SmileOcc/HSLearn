import { Constants } from '../../../../../../../modules/common_har/src/main/ets/common/Constants'
import { UserInfoModel } from '../model/UserInfoModel'
import { router } from '@kit.ArkUI'

@Component
export struct MineNavBarView {

  @Prop userInfo:UserInfoModel

  editBlock:(()=>void)|undefined

  build() {
    Row() {
      Row() {
        Button({ type: ButtonType.Circle, stateEffect: false }) {
          Image(this.userInfo.avatar??$r('app.media.right_head'))
            .size({ width: 80, height: 80 })
            .objectFit(ImageFit.Fill)
            .onComplete(msg=>{

            })
            .onError(()=>{

            })
        }
        .onClick(()=>{
          if (this.editBlock != undefined) {
            this.editBlock()
          }
        })
        .backgroundColor(Color.White)
        .clip(true)

        Blank().width(8)
        Column() {
          Text(this.userInfo.nickName??'佚名')
            .fontColor(Color.Black)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
          Button() {
            Row() {
              Text('V')
                .fontColor(Constants.COLOR_666666)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .margin({ left: 8 })
              Text('普通会员')
                .fontColor(Constants.COLOR_666666)
                .fontSize(14)
                .margin({ left: 8, right: 8 })
            }
            .height(25)
          }
          .buttonStyle(ButtonStyleMode.NORMAL)
          .margin({ top: 6 })
          .clip(true)
        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceAround)
      }
      .height(100)
      .layoutWeight(7)

      Row() {
        Button() {
          Image($r('app.media.account_message_new'))
            .size({ width: 25, height: 25 })
          // .fillColor(Color.Red)//需要svg图片
        }
        .onClick(()=>{
          router.pushUrl({ url: 'pages/message/MessageListPage' })
        })
        .buttonStyle(ButtonStyleMode.NORMAL)
        .padding(4)
        .margin({ right: 12 })
        .clip(true)

        Button() {
          Image($r('app.media.account_setting'))
            .size({ width: 25, height: 25 })
        }
        .onClick(()=>{
          router.pushUrl({ url: 'pages/setting/SettingPage' })
        })
        .buttonStyle(ButtonStyleMode.NORMAL)
        .padding(4)
        .clip(true)

      }
      .layoutWeight(3)
      .justifyContent(FlexAlign.End)
      .height(50)
    }
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.SpaceBetween)
    .height(120)
    .padding({ top: 12, left: 13, right: 13, bottom: 13 })
    .backgroundColor(Constants.COLOR_PAGE_BGC)
  }
}