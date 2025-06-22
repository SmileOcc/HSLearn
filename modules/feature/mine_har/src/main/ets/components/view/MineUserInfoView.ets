import { YWConstants, YWStorageConstants } from "@learn/constants_har";
import { HSAccountModel, HSUserInfoManager } from "@learn/userinfo_har";
import { App, AppStorageV2 } from "@kit.ArkUI";
import { YWLocalNavType, YWNavPath, ywNavRouter } from "@learn/nav_router_har";

@ComponentV2
export struct MineUserInfoView {

  @Consumer(YWStorageConstants.kAccountInfo)
  localUseInfo?:HSAccountModel = undefined

  private topSpace = 24

  // @StorageProp(YWConstants.kStorageWidth) screenWidth:number = AppStorage.get(YWConstants.kStorageWidth)

  //无语plus
  @Local screenWidth:number = AppStorage.get(YWConstants.kStorageWidth) ?? 0

  // @Param screenWidth:number = AppStorageV2.connect<String>(TypeConstructorWithArgg,0)


  //组件内部状态, 不支持外部出入
  @Local isShowHeader: boolean = this.localUseInfo ? true : false
  // @Param：组件外部输入
  //它是为了父子组件之间的数据能够进行同步。但是它是不支持组件内部进行修改的
  @Param test: string | undefined = ""
  //只能修改一次，不过它的局限性比较大，必须和@Param配合使用,不能单独使用，
  // 它是为了实现仅从外部初始化一次、不接受后续同步变化的能力
  @Param @Once textAA:string = 'v2'

  // @Event组件输出
  // @Event也和@Param有关系，因为@Param修饰的变量无法从内部修改，
  // 但是有时它又需要修改，那怎么办呢，@Event装饰的事件负责告诉父组件，
  // 再由父组件进行修改。好像有点多此一举
  @Event changeText: (x: string) => void = (x: string) => {};

  // @Monitor：监听
  // 我们之前使用@Watch来监听变量的变化，不过@Watch无法实现对对象、数组中某一单个属性或数组项变化的监听，且无法获取变化之前的值。
  // 而@Monitor可以:
  //监听text
  @Monitor('text')
  onStrChange(monitor: IMonitor){
    monitor.dirty.forEach((path:string)=>{
      console.log('修改前：',monitor.value(path)?.before)
      console.log('修改后：',monitor.value(path)?.now
      )
    })
  }

  // @StorageLink(YWStorageConstants.kAccountInfo) localUseInfo:HSAccountModel = new HSAccountModel("","","")



  topBlackBgHeight() {
    return this.topSpace + 44 + 74 + 124
  }

  @Builder
  userInfoView() {
    Column(){
      Row(){
        if (this.isShowHeader) {
          Image($r('app.media.user_avatar'))
            .borderWidth('1vp')
            .borderRadius('24vp')
            .size({width:'48vp',height:'48vp'})
            .borderColor($r('app.color.col_FFFFFF'))
            .onClick(()=>{
              //测试修改用户名
              if (this.localUseInfo) {
                this.localUseInfo.nickName = this.localUseInfo.nickName === "odd" ? "occ" : "odd"
                HSUserInfoManager.getInstance().updateUserInfo(this.localUseInfo)
              }
              ywNavRouter.openRoute(this.getUniqueId())
                // .onNavWayNav(YWLocalNavType.NAV_MAIN_MINE)
                .onTargetUrl(YWNavPath.mine_user_info)
                .onItemInfo(this.localUseInfo)
                .go()
            })
          Blank().width('4vp')
        }
        Column(){
          Text(this.localUseInfo?.nickName ?? "aaa")
            .fontSize(16)
            .fontColor($r('app.color.col_FFFFFF'))
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)
            .maxLines(1)
            .textOverflow({overflow:TextOverflow.Ellipsis})
          if (this.localUseInfo?.desc) {
            Text(this.localUseInfo?.desc)
              .fontSize(14)
              .fontColor($r('app.color.col_999999'))
              .textAlign(TextAlign.Start)
              .maxLines(1)
              .textOverflow({overflow:TextOverflow.Ellipsis})
          }
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        //TODO 按道理 如果里面图片与文字在同同一个row里 最外层可以 row是可以去掉的
        Row(){
          Blank().width(4)
          Row(){
            Text("社区详情")
              .fontSize(13)
              .maxLines(1)
              .textOverflow({overflow:TextOverflow.Ellipsis})
              .fontColor($r('app.color.col_ffffff'))

            //这个不能放这里，会把箭头 挤出去，奇怪
            // Image($r("app.media.arrow_right"))
            //   .width('24vp')
            //   // .objectFit(ImageFit.Contain)
            //   .fillColor($r('app.color.col_666666'))
            //   // .padding(4)
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.End)
          .constraintSize({maxWidth:'100vp'})

          //图片区域大小是 16 + 上下， 无语
          Image($r("app.media.arrow_right"))
            .width('16vp')
            .objectFit(ImageFit.Contain)
            .fillColor($r('app.color.col_666666'))
            .padding({top:'8vp',bottom:'8vp',right:'4vp'})
        }
        .onClick(()=>{

          ywNavRouter.openRoute(this.getUniqueId())
            .onTargetUrl(YWNavPath.root_community_nav)
            .onNavWayNav(YWLocalNavType.NAV_ROOT_MAIN_TAB)
            .go()

        })
      }
      // .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      // .backgroundColor($r('app.color.bg_gray_base'))
    }
    .width('100%')
  }

  @Builder
  topBackBgView() {
    Column(){

    }
    .width('100%')
    .height(this.topBlackBgHeight())
  }

  @Builder
  bottomBgColorView() {
    Column(){

    }
    .width('100%')
    .backgroundColor($r('app.color.col_F5F5F5'))
  }


  @Builder
  vipInfoView() {
    Row(){
      Column(){
        //top
        Row(){
          Row(){
            Image($r('app.media.vip'))
              .size({width:30,height:30})
              .objectFit(ImageFit.Fill)
            Text('VIP')
              .fontSize(24)
              .fontWeight(400)
              .fontColor(YWConstants.HexColorA('000000',1))
            // .fontColor(YWConstants.HexColorA('ffcc33',0.9))
            Button(){
              Text('5项权益 >')
                .fontColor(YWConstants.HexColorA('0d0d0d',1))
                  // .fontColor(YWConstants.HexColorA('ffcc33',0.9))
                .fontSize(13)
            }
            .height(24)
            .margin({left:12})
            .padding({left:8,top:3,right:8,bottom:3})
            .backgroundColor(YWConstants.HexColorA('0d0d0d',0.5))
            // .backgroundColor(YWConstants.HexColorA('ffcc33',0.5))
            .borderRadius(12)
          }
          Button('升级攻略')
            .buttonStyle(ButtonStyleMode.NORMAL)
            .width(80)
            .height(24)
            .borderWidth(1)
            .fontColor(YWConstants.HexColorA('0d0d0d',1))
            .borderColor(YWConstants.HexColorA('0d0d0d',1))
              // .fontColor(YWConstants.HexColorA('ffcc33',0.9))
            // .borderColor(YWConstants.HexColorA('ffcc33',0.9))
            .padding({left:10,bottom:3,right:10,top:3})
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .height(40)
        .width('100%')

        //中
        Text('当前积分： 0')
          .fontColor(YWConstants.HexColorA('0d0d0d',1))
            // .fontColor(YWConstants.HexColorA('ffcc33',0.9))
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
              .color(YWConstants.HexColorA('0d0d0d',0.9))
            // .color(YWConstants.HexColorA('ffcc33',0.9))
            Text('恭喜您已达到VIP级会员')
              .fontSize(13)
              .fontColor(YWConstants.HexColorA('0d0d0d',1))
                // .fontColor(YWConstants.HexColorA('ffcc33',0.9))
              .margin({top:12})
          }
          .alignItems(HorizontalAlign.Start)
          .width('60%')

          Text('NO:C000307')
            .fontColor(YWConstants.HexColorA('0d0d0d',1))
              // .fontColor(YWConstants.HexColorA('ffcc33',0.9))
            .fontSize(13)
            .margin({top:12})
        }
        .margin({top:30})
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

      }
      .layoutWeight(1)
      .padding({left:8,top:12,right:8,bottom:12})

      .borderRadius(16)
      .clip(true)
      .backgroundColor(YWConstants.HexColorA('ffffff',0.99))
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .margin({top:'12vp'})

  }

  build() {
    Column(){
      this.userInfoView()
      if (this.localUseInfo) {
        this.vipInfoView()
      }
    }
    .width('100%')
    // .backgroundColor($r('app.color.bg_gray_base'))
    // .padding({left:'16vp',right:'16vp', top:'12vp'})
    // .margin({left:'16vp',right:'16vp', top:'12vp'})//这里 左右没有效果

  }
}