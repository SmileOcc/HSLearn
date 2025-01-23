import { hsLog } from "@learn/logger_har"
import { ywNavManager, YWNavParams } from "@learn/nav_router_har"
import { YWResColor } from "@learn/res_har/src/main/ets/res/YWResColor"
import { ITabEventState, TabItemInfo, TabViewIUState } from "@learn/tab_nav_api_har"
import { CommonTabItemView } from "./CommonTabItemView"

const TAG = "CommonTabContentView"
@Component
export struct CommonTabContentView {

  navName?:string

  @State navigationMode: number = NavigationMode.Stack;

  @Consume("CommonTabIUState") commonTabIUState:TabViewIUState

  private currentTabInfo?:TabItemInfo


  @Consume("CommonITabEventState")
  commonTabEventState:ITabEventState


  aboutToAppear(): void {
    hsLog.i(TAG,"aboutToAppear")
    this.currentTabInfo = this.commonTabIUState.tabInfo.getCurrentTab()
    this.navName = this.currentTabInfo?.navPath ?? ""

  }

  // @Builder
  // navDestPages(name: string, param: YWNavParams) {
  //   ywNavManager.getBuilderWithPageID(this.navName!)(name)?.builder(name,param)
  // }

  build() {
    // Navigation(ywNavManager.getNavStack("")){

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

      }
      .layoutWeight(1)
      .width('100%')
      .backgroundColor(Color.Gray)
      //底部tab
      Row(){

        ForEach(this.commonTabIUState.tabInfo.getNavList(), (item: TabItemInfo) => {
          CommonTabItemView({tabInfo:item})
            .onClick(()=>{
              if (this.commonTabEventState) {
                this.commonTabEventState.onClickIndex(this.commonTabIUState.tabInfo.getCurrentTab()!,item)
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

    // }
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
  }
}

@Builder
export function commonTabContentBuilder(name:string, params:YWNavParams) {
  NavDestination(){
    CommonTabContentView({navName:params["navName"] ?? ""})
  }
  .onBackPressed(()=>{
//获取父类
    return true
  })
  .hideTitleBar(true)
}