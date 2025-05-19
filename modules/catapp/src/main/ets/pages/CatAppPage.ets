import { YWNavPath } from "@learn/nav_router_har";
import { TabInfo, TabItemInfo, TabViewIUState } from "@learn/tab_nav_api_har";
import { commonTabBuilder} from "@learn/tab_nav_common_har";

export const CatRootBuilder = wrapBuilder(catAppBuilder)

@Builder function catAppBuilder(name:string, params:Map<string,Object>) {
  NavDestination(){
    CatAppPage()
  }
  .hideTitleBar(true)
}

@Entry
@Component
struct CatAppPage {
  @State message: string = 'Hello cat';

  private tabState?:TabViewIUState
  aboutToAppear(): void {

    // let tabInfo = new TabInfo()
    // tabInfo.navList = []
    // for (let i=0; i< 3; i++) {
    //   let tabItem = new TabItemInfo()
    //
    //   if (i == 0) {
    //     tabItem.cid = "id_" + `${i}`
    //     tabItem.title = "首页"
    //     tabItem.isSelected = true
    //     tabItem.navPath = YWNavPath.lion_tab_home
    //   } else if (i ==1) {
    //     tabItem.cid = "id_" + `${i}`
    //     tabItem.title = "消息"
    //     tabItem.navPath = YWNavPath.lion_tab_news
    //   } else if (i ==2) {
    //     tabItem.cid = "id_" + `${i}`
    //     tabItem.title = "我的"
    //     tabItem.navPath = YWNavPath.lion_tab_me
    //   }
    //
    //   tabInfo.navList.push(tabItem)
    // }

    this.tabState = new TabViewIUState()

    this.tabState.currentIndex = 0
    // this.tabState.tabInfo = tabInfo
  }

  build() {
    Row() {
      // commonTabBuilder(this.tabState!)
    }
    .height('100%')
  }
}