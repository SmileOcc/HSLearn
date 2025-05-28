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

  @Provider(YWStorageConstants.kAccountInfo) localUseInfo?:HSAccountModel = HSUserInfoManager.getInstance().account

  minePageNav = ywNavManager.getNavStack(YWLocalNavType.NAV_MAIN_MINE)

  viewModel:MineViewModel = new MineViewModel(this.getUIContext())
  @Local mineUIState:MineUIState = this.viewModel.iuState

  private childRecognizer: GestureRecognizer = new GestureRecognizer()
  private currentRecognizer: GestureRecognizer = new GestureRecognizer()
  private lastOffset: number = 0
  private scroller: Scroller = new Scroller();
  @Builder
  navPagesMap(name: string, param: YWRouterNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_MAIN_MINE)(name)?.builder(name,param)
  }

  aboutToAppear(): void {
    this.envName = HSLocalConfig.getEnv()
    hsLog.d(TAG,'userInfo:' + `${JSON.stringify(this.localUseInfo)}`)

    if (this.navParams && this.navParams.pageLifecycle) {
      this.navParams.pageLifecycle.onShow = ()=> {
        hsLog.d(TAG,'onShow:' + `${JSON.stringify(this.localUseInfo)}`)

      }
      this.navParams.pageLifecycle.onHide = ()=> {
        hsLog.d(TAG,'onHide:' + `${JSON.stringify(this.localUseInfo)}`)

      }
    }

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

  @Builder
  topBlackBgView() {
    Column(){

    }
    .width('100%')
    .height('200vp')
  }
  @Builder
  bottomBgColorView() {
    Column(){

    }
    .width('100%')
    .height('200vp')
  }

  @Builder
  topHeader() {
    Column(){
      MineHeaderView({homeClick:()=>{

      },messageClick:()=>{

      },settingClick:()=>{

        ywNavRouter.openRoute(this.getUniqueId())
          .onTargetUrl(YWNavPath.root_setting)
          .onRouteMode()
          .go()
      }})
      Blank().height('12vp')
      MineUserInfoView()
      Blank().height('12vp')
      MineMenuView({orderMenus: this.mineUIState.orderMenus})
    }
    .width('100%')
  }

  build() {
    Stack({alignContent:Alignment.TopStart}) {
      Navigation(this.minePageNav) {
        // Stack(){

        Column(){
          List({space:'20vp', scroller:this.scroller}){
            ListItemGroup({header: this.topHeader()})
            ForEach(this.mineUIState.services,(value:MineServiceGroup,index)=>{
              MineListGroupView({groupInfo:value})
            })

          }
          .padding({left:'16vp',right:'16vp'})




          Button("通用tab")
            .onClick(()=>{
              ywNavRouter.openRoute(this.getUniqueId())
                .onTargetUrl(YWNavPath.root_lion_nav)
                .onNavWayNav(YWLocalNavType.NAV_ROOT_MAIN_TAB)
                .onRouteMode()
                .go()
            })
        }



        // }

      }
      .width('100%')
      .height('100%')
      .hideTitleBar(true)
      .navBarWidth('50%')
      .navDestination(this.navPagesMap)
      // .hideNavBar(this.isFullScreen)
      .mode(this.navigationMode)
      .onAppear(()=>{
        hsLog.i(TAG,'--onAppear')
      })
      .onDisAppear(()=>{
        hsLog.i(TAG,'--onDisAppear')

      })
      .onAreaChange((oldValue,newValue)=>{
        hsLog.i(TAG,`--onAreaChange:${oldValue}  ${newValue}`)

      })
      Text(`配置：${this.envName}`)
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .alignContent(Alignment.TopStart)
    .backgroundColor(YWResColor.bgBase())
    .backgroundColor(Color.Green)
    // .padding(getAvoidPadding(this.avoidAreas))

  }
}
