import { YWConstants } from '@learn/constants_har';
import { UserInfoModel } from '../model/UserInfoModel'

@Component
export struct MineInfoView {

  @StorageProp(YWConstants.kStorageWidth) screenWidth:number = 0

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
            .fontColor(YWConstants.HexColorA('ffcc33',0.9))
          Button(){
            Text('5项权益 >')
              .fontColor(YWConstants.HexColorA('ffcc33',0.9))
              .fontSize(13)
          }
          .height(24)
          .margin({left:12})
          .padding({left:8,top:3,right:8,bottom:3})
          .backgroundColor(YWConstants.HexColorA('ffcc33',0.5))
          .borderRadius(12)
        }
        Button('升级攻略')
          .buttonStyle(ButtonStyleMode.NORMAL)
          .width(80)
          .height(24)
          .borderWidth(1)
          .fontColor(YWConstants.HexColorA('ffcc33',0.9))
          .borderColor(YWConstants.HexColorA('ffcc33',0.9))
          .padding({left:10,bottom:3,right:10,top:3})
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .height(40)
      .width('100%')

      //中
      Text('当前积分： 0' + this.screenWidth)
        .fontColor(YWConstants.HexColorA('ffcc33',0.9))
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
            .color(YWConstants.HexColorA('ffcc33',0.9))
          Text('恭喜您已达到VIP级会员')
            .fontSize(13)
            .fontColor(YWConstants.HexColorA('ffcc33',0.9))
            .margin({top:6})
        }
        .alignItems(HorizontalAlign.Start)
        .width('60%')

        Text('NO:C000307')
          .fontColor(YWConstants.HexColorA('ffcc33',0.9))
          .fontSize(13)
          .margin({top:12})
      }
      .margin({top:30})
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

    }
    .width(this.screenWidth - 26.0)
    .margin(13)
    .padding({left:8,top:12,right:8,bottom:12})
    .borderRadius(16)
    .clip(true)
    .backgroundColor(YWConstants.HexColorA('663300',1))
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(HorizontalAlign.Start)
  }
}