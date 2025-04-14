import { mainCarBuilder } from "@learn/car_har"
import { mainCategoryBuilder } from "@learn/category_har"
import { YWConstants } from "@learn/constants_har"
import { mainHomeBuilder } from "@learn/home_har"
import { hsLog } from "@learn/logger_har"
import { mainMineBuilder } from "@learn/mine_har"
import { ywNavManager, YWRouterNavParams } from "@learn/nav_router_har"
import { YWResColor } from "@learn/res_har/src/main/ets/res/YWResColor"
import { ITabEventState, TabNavTitleConfig } from "@learn/tab_nav_api_har"
import { TabInfo } from "@learn/tab_nav_api_har"
import { TabItemInfo } from "@learn/tab_nav_api_har"
import { TabViewIUState } from "@learn/tab_nav_api_har"
import { TabMainItemView } from "./TabMainItemView"
import { router } from "@kit.ArkUI"
import { YWMainNavBar } from "@learn/tab_nav_common_har"
import { YWResImage } from "@learn/res_har"
import { NavAvatarInfo, NavTitleInfo } from "@learn/tab_nav_api_har/src/main/ets/config/TabNavTitleConfig"

const TAG = "TabContentView"
@Component
export struct TabContentView {

  navName?:string

  @State navigationMode: number = NavigationMode.Stack;

  @State navInfo:TabNavTitleConfig = new TabNavTitleConfig()

  @Consume("tabIUState") tabIUState:TabViewIUState

  private currentTabInfo?:TabItemInfo


  @Consume("ITabEventState")
  tabEventState:ITabEventState


  aboutToAppear(): void {
    hsLog.i(TAG,"aboutToAppear")

    this.currentTabInfo = this.tabIUState.tabInfo.getCurrentTab()
    this.navName = this.currentTabInfo?.navType ?? ""

    let localNavInfo = new TabNavTitleConfig()
    localNavInfo.title = "MM"
    localNavInfo.userAvatarInfo = new NavAvatarInfo(true,YWResImage.userAvatar(),()=>{
      let kk = ""
    })

    //   {
    //   isShow:true,
    //   icon:YWResImage.userAvatar(),
    //   onClick:()=>{
    //     let kk = ""
    //   }
    // }
    localNavInfo.titleInfo = new NavTitleInfo(this.navName ?? "",()=>{
      let kk = ""
    })

    //   {
    //   title:this.navName,
    //   onClick:()=>{
    //     let kk = ""
    //   }
    // }

    // localNavInfo.rightMenuInfos = {
    //   wrapItemBuilder:[]
    // }

    setTimeout(()=>{
      this.navInfo.titleInfo!.title = "ggg"
    },2000)

    this.navInfo = localNavInfo

  }

  @Builder
  navDestPages(name: string, param: YWRouterNavParams) {
    ywNavManager.getBuilderWithPageID(this.navName!)(name)?.builder(name,param)
  }

  build() {
    Stack(){
      Navigation(ywNavManager.getNavStack(this.navName!)){

        Column(){
          //导航
          YWMainNavBar({navInfo:this.navInfo})
          // .width('100%')
          // .height('59')
          .backgroundColor(Color.Yellow)
          //内容显示
          Column(){
            if (this.currentTabInfo?.index == 0) {
              mainHomeBuilder(this.navName!,new YWRouterNavParams())
            } else if (this.currentTabInfo?.index == 1) {
              mainCategoryBuilder(this.navName!,new YWRouterNavParams())
            } else if (this.currentTabInfo?.index == 2) {
              mainCarBuilder(this.navName!,new YWRouterNavParams())
            } else if (this.currentTabInfo?.index == 3) {
              mainMineBuilder(this.navName!,new YWRouterNavParams())
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
          .height(YWConstants.kMainTabHeight)
          .width('100%')
        }
        .width('100%')
        .height('100%')

      }
      .hideTitleBar(true)
      .navDestination(this.navDestPages)
      // .hideNavBar(true)
      .mode(this.navigationMode)
      .onAppear(()=>{
        hsLog.i(TAG,'--onAppear')
      })
      .onDisAppear(()=>{
        hsLog.i(TAG,'--onDisAppear')

      })
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .width('100%')
    .height('100%')
  }
}

@Builder
export function maintTabContentViewBuilder(name:string, params:YWRouterNavParams) {
  NavDestination(){
    TabContentView({navName:params.params.get("navName") as string ?? ""})
  }
  .onBackPressed(()=>{
    router.back()
    return true
  })
  .hideTitleBar(true)
}