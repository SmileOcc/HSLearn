import { YWRouterNavParams, ywNavManager, YWLocalNavType, ywNavRouter, YWNavPath } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"
import { HSLocalConfig } from "@learn/app_config_har"
import { MineUIState, MineViewModel } from "./viewmodel/MineViewModel"
import { MineHeaderView } from "./view/MineHeaderView"
import { MineUserInfoView } from "./view/MineUserInfoView"
import { MineMenuView } from "./view/MineMenuView"
import { MineListGroupView } from "./view/MineListView"
import { YWStorageConstants } from "@learn/constants_har"
import { HSAccountModel, HSUserInfoManager } from "@learn/userinfo_har"
import { MineServiceGroup } from "./model/MineServiceModel"
import { BaseImage } from "@learn/base_image_har"
import { YWBaseNavBar } from "@learn/baseui_har"
import { HSRegisterNetworkListener, NetEventData, NetworkEventName } from "@learn/network_har"
import { emitter } from "@kit.BasicServicesKit"
import { connection } from "@kit.NetworkKit"

@Builder
export function mainMineBuilder(name:string, params:YWRouterNavParams) {
  NavDestination(){
    MainMinePage({navParams:params})
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

const TAG = "MainCarPage"

@ComponentV2
export struct MainMinePage {

  @Param @Require navParams?:YWRouterNavParams
  @Local navigationMode: number = NavigationMode.Stack;
  @Local envName: string = ""
  private scrollOffsetY = 0

  @Provider(YWStorageConstants.kAccountInfo) localUseInfo?:HSAccountModel = HSUserInfoManager.getInstance().account

  // minePageNav = ywNavManager.getNavStack(YWLocalNavType.NAV_MAIN_MINE)

  getComponentUniqueId:()=>number = ()=>{
    return this.getUniqueId()
  }

  viewModel:MineViewModel = new MineViewModel()
  @Local mineUIState:MineUIState = this.viewModel.iuState

  private childRecognizer: GestureRecognizer = new GestureRecognizer()
  private currentRecognizer: GestureRecognizer = new GestureRecognizer()
  private lastOffset: number = 0
  private scroller: Scroller = new Scroller();

  // 类属性箭头函数
  handleClick = (): void => {

  }

  @Builder
  navPagesMap(name: string, param: YWRouterNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_MAIN_MINE)(name)?.builder(name,param)
  }


  aboutToAppear(): void {
    const context = getContext(this)
    this.viewModel.init(this.getUIContext(), context, this.getComponentUniqueId)

    this.viewModel.loadMineInfo()

    //判断网络
    const hasNet = HSRegisterNetworkListener.isCheckNetworkAvailable()
    hsLog.i(TAG,`是否有网络 ： ${hasNet}`)
    //方式一：
    HSRegisterNetworkListener.addCallback((netData)=>{
      hsLog.i(TAG,`---mine network: ${JSON.stringify(netData)}`)
      //简单判断
      const commonHasNet = netData.hasConnect()
      this.handleNetData(netData);
    },false)

    // 方式二：通过emitter接受网络监听结果
    emitter.on(HSRegisterNetworkListener.getEmitterEvent(), (data: emitter.EventData) => {
      if (data) {
        this.netObserver(data);
      } else {
        hsLog.i("aboutToAppear emitter on error, data is undefined.");
      }
    });


    let kkkSet: Set<string> = new Set()
    kkkSet.add("1")
    kkkSet.add('2')
    //这个才可以输出set
    let kkkm = Array.from(kkkSet)
    let mmm = Array.of(kkkSet)
    hsLog.d(TAG,  "mm+ " + JSON.stringify(Array.from(kkkSet)))
    hsLog.d(TAG, JSON.stringify(mmm))

    hsLog.d(TAG, JSON.stringify(kkkSet.entries()))
    hsLog.d(TAG, JSON.stringify(kkkSet.keys()))
    if (kkkSet.has("2")) {
      hsLog.d(TAG, 'JSON.stringify(kkkSet.entries())')

    }



    this.navParams?.getPageLifecycleImp().setPageOnShow(()=>{
      hsLog.d(TAG,"PageOnShow")
      this.viewModel.loadMineInfo()
    })
    this.navParams?.getPageLifecycleImp().setPageOnHide(()=>{
      hsLog.d(TAG,"PageOnHide")
    })
    this.envName = HSLocalConfig.getEnv()
    hsLog.d(TAG,'userInfo:' + `${JSON.stringify(this.localUseInfo)}`)

    // if (this.navParams && this.navParams.pageLifecycle) {
    //   this.navParams.pageLifecycle.onShow = ()=> {
    //     hsLog.d(TAG,'onShow:' + `${JSON.stringify(this.localUseInfo)}`)
    //
    //   }
    //   this.navParams.pageLifecycle.onHide = ()=> {
    //     hsLog.d(TAG,'onHide:' + `${JSON.stringify(this.localUseInfo)}`)
    //
    //   }
    // }

    let ttt: string[] = ["a", "b", "c", "d"]
    let i =  ttt.findIndex((item) => {
      return item == "b"
    })
    let jj = ttt.indexOf("b",0)

    //some(): 方法用于检测数组中的元素是否满足指定条件（函数提供）。
    // 如果有一个元素满足条件，则表达式返回true , 剩余的元素不会再执行检测。否则返回false
    let res = ttt.some((item) => {
      return item == "b";
    })

    //every(): 方法用于检测数组所有元素是否都符合指定条件（通过函数提供）。如果有一个不符合就返回false
    //全选功能
    res = ttt.every((item) => {
      return item.length > 0;
    })

  }

  // 网络监听回调
  netObserver(data: emitter.EventData) {
    if (!data.data) {
      hsLog.i("netObserver data.data is undefined.");
      return;
    }
    hsLog.i(TAG,"network observe result : " + HSRegisterNetworkListener.parseResult(data));
    let netEventData: NetEventData = data.data! as NetEventData;
    this.handleNetData(netEventData)
  }
  handleNetData(netEventData: NetEventData) {
    let eventName: NetworkEventName = netEventData.eventName ?? -1;
    switch (eventName) {
      case NetworkEventName.NetAvailable:
        // WI-FI是可用状态
        if (netEventData.netType === connection.NetBearType.BEARER_WIFI) {

        }
        break;
      case NetworkEventName.NetBlock:
        break;
      case NetworkEventName.NetLost:
        // 如果WI-FI网络丢失，则通过wifiInterrupt方法判断是否需要继续播放

        break;
      case NetworkEventName.NetUnavailable:

        break;
      case NetworkEventName.WeakNet:
        // 如果是弱网环境，则弹出提示，实际应用开发中可以通过该结果自动实现分辨率自动切换
        if (netEventData.status) {

        }
        break;
        case NetworkEventName.WifiStateChange:
          if (netEventData.status == 0) {//0，未激活；1，已激活；2，激活中；3：去激活中

          }
      default:
        hsLog.d(TAG,"当前网络状态：" + eventName);
        break;
    }

    const isCheckNetworkAvailable = HSRegisterNetworkListener.isCheckNetworkAvailable()
    hsLog.i(TAG,`当前网络是否可用：${isCheckNetworkAvailable}`)
  }

  @Builder
  topBlackBgView() {
    Column(){
      Button('Class Property')
        .onClick(this.viewModel.increment) // ✅ 已提前绑定
    }
    .width('100%')
    .height('200vp')
  }
  @Builder
  bottomBgColorView() {
    Column(){
      Button('Class Property')
        .onClick(this.handleClick) // ✅ 直接引用
    }
    .width('100%')
    .height('200vp')
  }

  @Builder
  topHeader() {
    RelativeContainer(){
        Column(){
          MineHeaderView({homeClick:()=>{
            ywNavRouter.openRoute(this.getUniqueId())
              .onTargetUrl(YWNavPath.vc_car)
              .onNavWayNav(YWLocalNavType.NAV_MAIN_MINE)
              .onRouteMode()
              .go()
          },messageClick:()=>{

          },settingClick:()=>{

            ywNavRouter.openRoute(this.getUniqueId())
              .onTargetUrl(YWNavPath.root_setting)
              .onRouteMode()
              .go()
          }})
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

          Blank().height('12vp')
          MineUserInfoView()
          Blank().height('12vp')
          MineMenuView({orderMenus: this.mineUIState.orderMenus})
          Blank().height('12vp')
        }
        .zIndex(1000)
        .width('100%')
        .padding({left:16,right:16})
        .id('headViewID')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

      Image(this.mineUIState.imageTheme?.localImageUrl)
        .width('100%')
        .objectFit(ImageFit.Cover)
        .alignRules({
          top: { anchor: 'headViewID', align: VerticalAlign.Top },  //以row1组件为锚点，竖直方向底端对齐
          left: { anchor: 'headViewID', align: HorizontalAlign.Start },  //以row1组件为锚点，水平方向开头对齐
          right: { anchor: 'headViewID', align: HorizontalAlign.End},
          bottom: { anchor: 'headViewID', align: VerticalAlign.Bottom}
        })
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .width('100%')
    .height('auto')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

  }

  build() {
    Stack({alignContent:Alignment.TopStart}) {

      Column(){
        //用这个不行，使用这个没有效果，内部image 没有expandSafeArea
        // BaseImage({imageOption:{
        //   loadSrc: $r('app.media.status_bar_animation_picture3'),
        //   placeholderSrc: $r("app.media.status_bar_animation_picture1"),
        //   errorholderSrc: $r("app.media.app_icon"),
        //   objectFit: ImageFit.Auto
        // }})
        //   .width('100%')
        //   .aspectRatio(1.333)
        //   .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

        // Image($r('app.media.status_bar_animation_picture3'))
        //   .width('100%')
        //   .aspectRatio(1.333)
        //   .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      }
      .backgroundColor(this.mineUIState.imageTheme?.bgColor ?? $r('app.color.bg_gray_base'))
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

      Column(){

        List({space:'20vp', scroller:this.scroller}){
          ListItemGroup({header: this.topHeader()})
          ForEach(this.mineUIState.services,(value:MineServiceGroup,index)=>{
            MineListGroupView({groupInfo:value})
          })

        }
        .layoutWeight(1)
        .onScrollStop(()=>{
          this.scrollOffsetY = this.scroller.currentOffset().yOffset
          hsLog.d(TAG,"---onScrollStop yOffset: " + this.scrollOffsetY)
          if (this.scrollOffsetY > 20) {
            this.mineUIState.navBarAlpha = this.scrollOffsetY / 40.0
          } else {
            this.mineUIState.navBarAlpha = 0.0
          }
        })
        .onDidScroll((scrollOffset: number, scrollState: ScrollState)=>{
          if (scrollState == ScrollState.Scroll) {
            this.scrollOffsetY = this.scroller.currentOffset().yOffset
            if (this.scrollOffsetY > 20) {
              this.mineUIState.navBarAlpha = this.scrollOffsetY / 40.0
            } else {
              this.mineUIState.navBarAlpha = 0.0
            }
          }
        })
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

        // .padding({left:'16vp',right:'16vp'})
        // Button("通用tab")
        //   .onClick(()=>{
        //     ywNavRouter.openRoute(this.getUniqueId())
        //       .onTargetUrl(YWNavPath.root_lion_nav)
        //       .onNavWayNav(YWLocalNavType.NAV_ROOT_MAIN_TAB)
        //       .onRouteMode()
        //       .go()
        //   })
      }
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

      // YWBaseNavBar({leftLayout:this.topLeftView, rightLayout:this.topRightView, isExpandSafeArea: true})
      //   .zIndex(1000)
      //   .opacity(this.mineUIState.navBarAlpha)

      MineHeaderView({isBlack: true, homeClick:()=>{
        ywNavRouter.openRoute(this.getUniqueId())
          .onTargetUrl(YWNavPath.vc_car)
          .onNavWayNav(YWLocalNavType.NAV_MAIN_MINE)
          .onRouteMode()
          .go()
      },messageClick:()=>{

      },settingClick:()=>{

        ywNavRouter.openRoute(this.getUniqueId())
          .onTargetUrl(YWNavPath.root_setting)
          .onRouteMode()
          .go()
      }})
        .zIndex(1000)
        .backgroundColor(Color.White)
        .padding({left:16,right:16})

        .opacity(this.mineUIState.navBarAlpha)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

      Text(`配置：${this.envName}`)
        .fontSize(11)
        .fontColor($r('app.color.level_red'))
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .alignContent(Alignment.Top)
    // .backgroundColor($r('app.color.bg_gray_base'))
    // .padding(getAvoidPadding(this.avoidAreas))
    .onDetach(()=>{
      // 组件从组件树卸载时触发此回调。建议使用onDisAppear替代此接口
    })
  }
}
