import { Constants } from '../../../../../../../modules/common_har/src/main/ets/common/Constants'
import { UserInfoModel } from '../model/UserInfoModel'

@Component
export struct MineInfoView {

  @Prop userInfo:UserInfoModel
  build() {
    Column(){
      //top
      Row(){
        Row(){
          Image($r('app.media.home_normal'))
            .size({width:30,height:30})
            .objectFit(ImageFit.ScaleDown)
          Text('VIP')
            .fontSize(24)
            .fontWeight(400)
            .fontColor(Constants.HexColorA('ffcc33',0.9))
          Button(){
            Text('5项权益 >')
              .fontColor(Constants.HexColorA('ffcc33',0.9))
              .fontSize(13)
          }
          .height(24)
          .margin({left:12})
          .padding({left:8,top:3,right:8,bottom:3})
          .backgroundColor(Constants.HexColorA('ffcc33',0.5))
          .borderRadius(12)
        }
        Button('升级攻略')
          .buttonStyle(ButtonStyleMode.NORMAL)
          .width(80)
          .height(24)
          .borderWidth(1)
          .fontColor(Constants.HexColorA('ffcc33',0.9))
          .borderColor(Constants.HexColorA('ffcc33',0.9))
          .padding({left:10,bottom:3,right:10,top:3})
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .height(40)
      .width('100%')

      //中
      Text('当前积分： 0' + Constants.screenWidth)
        .fontColor(Constants.HexColorA('ffcc33',0.9))
        .fontSize(16)
        .fontWeight(Color.White)
        .margin({top:12})

      //下
      Row(){
        Column(){
          Progress({ value: 24, total: 100, type: ProgressType.Linear })
            .width('90%')
            .height(4)
            .backgroundColor(Color.White)
            .color(Constants.HexColorA('ffcc33',0.9))
          Text('恭喜您已达到VIP级会员')
            .fontSize(13)
            .fontColor(Constants.HexColorA('ffcc33',0.9))
            .margin({top:6})
        }
        .alignItems(HorizontalAlign.Start)
        .width('60%')

        Text('NO:C000307')
          .fontColor(Constants.HexColorA('ffcc33',0.9))
          .fontSize(13)
          .margin({top:12})
      }
      .margin({top:30})
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

    }
    .width(Constants.SCREEN_WIDTH() - 26.0)
    .margin(13)
    .padding({left:8,top:12,right:8,bottom:12})
    .borderRadius(16)
    .clip(true)
    .backgroundColor(Constants.HexColorA('663300',1))
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(HorizontalAlign.Start)
  }
}