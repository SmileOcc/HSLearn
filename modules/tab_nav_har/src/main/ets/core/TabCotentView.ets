import { mainCarBuilder } from "@learn/car_har"
import { mainCategoryBuilder } from "@learn/category_har"
import { YWConstants } from "@learn/constants_har"
import { mainHomeBuilder } from "@learn/home_har"
import { hsLog } from "@learn/logger_har"
import { mainMineBuilder } from "@learn/mine_har"
import { ywNavManager, YWNavParams } from "@learn/nav_router_har"
import { YWResColor } from "@learn/res_har/src/main/ets/res/YWResColor"
import { ITabEventState } from "@learn/tab_nav_common_har"
import { TabInfo } from "@learn/tab_nav_common_har"
import { TabItemInfo } from "@learn/tab_nav_common_har"
import { TabViewIUState } from "@learn/tab_nav_common_har"
import { TabMainItemView } from "./TabMainItemView"
import { router } from "@kit.ArkUI"

const TAG = "TabContentView"
@Component
export struct TabContentView {

  navName?:string

  @State navigationMode: number = NavigationMode.Stack;

  @Consume("tabIUState") tabIUState:TabViewIUState

  private currentTabInfo?:TabItemInfo


  @Consume("ITabEventState")
  tabEventState:ITabEventState


  aboutToAppear(): void {
    hsLog.i(TAG,"aboutToAppear")
    this.currentTabInfo = this.tabIUState.tabInfo.getCurrentTab()
    this.navName = this.currentTabInfo?.navType ?? ""

  }

  @Builder
  navDestPages(name: string, param: YWNavParams) {
    ywNavManager.getBuilderWithPageID(this.navName!)(name)?.builder(name,param)
  }

  build() {
    // Navigation(ywNavManager.getNavStack(this.navName!)){

      Column(){
        //导航
        Row(){
          Text(this.navName)
        }
        .width('100%')
        .height('59')
        .backgroundColor(Color.Yellow)
        //内容显示
        Column(){
          if (this.currentTabInfo?.index == 0) {
            mainHomeBuilder(this.navName!,new Map())
          } else if (this.currentTabInfo?.index == 1) {
            mainCategoryBuilder(this.navName!,new Map())
          } else if (this.currentTabInfo?.index == 2) {
            mainCarBuilder(this.navName!,new Map())
          } else if (this.currentTabInfo?.index == 3) {
            mainMineBuilder(this.navName!,new Map())
          }
        }
        .layoutWeight(1)
        .backgroundColor(Color.Gray)
        //底部tab
        Row(){

          ForEach(this.tabIUState.tabInfo.mainNavList, (item: TabItemInfo) => {
            TabMainItemView({tabInfo:item})
              .onClick(()=>{
                if (this.tabEventState) {
                  this.tabEventState.onClickIndex(this.tabIUState.tabInfo.getCurrentTab()!,item)
                }
              })
              .layoutWeight(1)
              .height(49)
              // .backgroundColor(YWConstants.RandomColor())

          })
        }
        .height('49')
        .width('100%')
        // .backgroundColor(Color.Blue)
      }
      .width('100%')
      .height('100%')
      // .backgroundColor(Color.Gray)

    }
    // .hideTitleBar(true)
    // .navDestination(this.navDestPages)
    // .hideNavBar(true)
    // .mode(this.navigationMode)
    // .onAppear(()=>{
    //   hsLog.i(TAG,'--onAppear')
    // })
    // .onDisAppear(()=>{
    //   hsLog.i(TAG,'--onDisAppear')
    //
    // })
    // .width('100%')
    // .height('100%')
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  // }
}

@Builder
export function maintTabContentViewBuilder(name:string, params:YWNavParams) {
  NavDestination(){
    TabContentView({navName:params.get("navName") as string ?? ""})
  }
  .onBackPressed(()=>{
    router.back()
    return true
  })
  .hideTitleBar(true)
}