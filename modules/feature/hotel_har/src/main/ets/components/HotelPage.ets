import { YWConstants } from "@learn/constants_har"
import { YWLocalNavType, ywNavManager, YWNavPath, ywNavRouter, YWRouterNavParams } from "@learn/nav_router_har"
import { common } from "@kit.AbilityKit"
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"

const TAG = "HotelPage"
@Builder
export function hotelBuilder(name: string, params: YWRouterNavParams) {
  NavDestination() {
    HotelPage({ navParams: params })
  }
  .hideTitleBar(true)
  .onWillDisappear(() => {
    params.getPageLifecycle().pageOnDisappear?.()
  })
  .onShown(() => {
    params.getPageLifecycle().pageOnShow?.()
  })
  .onHidden(() => {
    params.getPageLifecycle().pageOnHide?.()
  })
}

@ComponentV2
struct HotelPage {

  private context = getContext(this) as common.UIAbilityContext
  @Param @Require navParams?: YWRouterNavParams
  rootNav?:NavPathStack = ywNavManager.getNavStack(YWLocalNavType.NAV_HOTEL_NAV)



  @Builder
  mainView() {
    Scroll(){
      Column({space:5}) {
        Row(){ //鱼拔图
          Image($r('app.media.banner')).height('100%').width('96%').margin({right:40}).borderRadius(10)
        }.height('40%')
        Row(){//公告
          Image($r("app.media.announce")).width(20).height(20).margin({left:5,right:5})
          Text('公告').fontColor("#e0d618").textAlign(TextAlign.Center).margin({right:10})
          Text('  “慕名会”，客房礼遇你知道吗').textAlign(TextAlign.Center)
          Text('查看').textAlign(TextAlign.Center).margin({left:20,right:5})
          Image($r("app.media.enter")).width(20).height(20).margin({right:10})
        }.height('6%').backgroundColor(Color.White).borderRadius(10).margin({bottom:5,top:5})
        Column({space:5}){//主要功能区
          Row(){ //会员订房 美食团购   //.width('45%').height("90%").margin({right:10}).borderRadius(10)
            Grid() {
              GridItem() {
                Image($r("app.media.tuangou")).borderRadius(10)
              }.margin(5)
              .onClick(()=>{
                ywNavRouter.openRoute(this.getUniqueId())
                  .onTargetUrl(YWNavPath.vc_hotel_list)
                  .onRouteMode()
                  .go()
              })
              GridItem() {
                Image($r("app.media.tuangou")).borderRadius(10)
              }.margin(5)
              .onClick(()=>{
                console.log("跳转到'美食团购-酒店美食列表'页面")
                // router.pushUrl({
                //   url: 'pages/home/ctrl/DelicacyGroupListPage'
                // });
                ywNavRouter.openRoute(this.getUniqueId())
                  .onTargetUrl(YWNavPath.vc_hotel_delicacy_list)
                  .onRouteMode()
                  .go()

              })
            }.columnsTemplate('1fr 1fr')

          }.borderRadius(10)
          Row(){ //婚宴预定....
            Grid() {
              GridItem() {
                Image($r("app.media.yuding")).borderRadius(10)
              }.margin(5)
              .onClick(()=>{
                console.log("跳转到'婚宴预定-酒店列表'页面")
                // router.pushUrl({
                //   url: 'pages/home/ctrl/BanquetHotelListPage'
                // });
              })
              GridItem() { //我的订单
                Image($r("app.media.order")).borderRadius(10)
              }.margin(5)
              .onClick(()=>{
                console.log("跳转到'我的订单")

                ywNavRouter.openRoute(this.getUniqueId())
                  .onTargetUrl(YWNavPath.vc_hotel_my_order)
                  .onRouteMode()
                  .go()
              })

              GridItem() {
                Image($r("app.media.concat")).borderRadius(10)
              }.margin(5)
            }.columnsTemplate('1fr 1fr 1fr')
          }.borderRadius(10)
          Row(){//美食餐饮
            Column(){
              Image($r("app.media.home_meishi")).width('24vp').height('24vp')
              Text("美食餐饮"){

              }
              .textAlign(TextAlign.Center)
            }
            Column(){
              Image($r("app.media.home_hotel")).width('24vp').height('24vp')
              Text("集团酒店"){

              }
              .textAlign(TextAlign.Center)
            }
            Column(){
              Image($r("app.media.home_location")).width('24vp').height('24vp')
              Text("酒店位置"){

              }
              .textAlign(TextAlign.Center)
            }

            Column(){
              Image($r("app.media.home_custom")).width('24vp').height('24vp')
              Text("客人说"){
              }
              .textAlign(TextAlign.Center)
            }
            .onClick(()=>{
              ywNavRouter.openRoute(this.getUniqueId())
                .onTargetUrl(YWNavPath.vc_hotel_review_list)
                .onRouteMode()
                .go()
            })

          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .borderRadius(10)
          .width('100%')
          .padding({bottom:5,right:5,left:5})
          .backgroundColor(Color.White)

        }
        // .padding('16vp')
      }.width('100%')
      .backgroundColor("#f7f9ee")
      .padding({left:'16vp',right:'16vp'})
    }
    .width('100%')
    .height('100%')
  }

  // 路由容器
  onBackPress() {
    ywNavRouter.openRoute(this.getUniqueId()).back()
  }
  @Builder
  navDestPages(name: string, param: YWRouterNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_HOTEL_NAV)(name)?.builder(name,param)
  }

  build() {

    Stack() {
      Navigation(this.rootNav) {
        this.mainView()
      }
      .width('100%')
      .height('100%')
      .hideTitleBar(true)
      .navBarWidth('50%')
      .navDestination(this.navDestPages)
      // .hideNavBar(this.isFullScreen)
      .mode(NavigationMode.Stack)
      .onAppear(()=>{
        hsLog.i(TAG,'--onAppear')
      })
      .onDisAppear(()=>{
        hsLog.i(TAG,'--onDisAppear')

      })
      .onAreaChange((oldValue,newValue)=>{
        hsLog.i(TAG,`--onAreaChange:${oldValue}  ${newValue}`)

      })
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    // .alignContent(Alignment.BottomEnd)
    .backgroundColor(YWResColor.bgBase())
    // .backgroundColor(Color.Orange)
    .width('100%')
    .height('100%')
    // .padding(getAvoidPadding(this.avoidAreas))
  }

}