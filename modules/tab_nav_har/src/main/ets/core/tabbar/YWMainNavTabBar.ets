import { YWConstants } from "@learn/constants_har"
import { ITabBottomBarConfig, ITabEventState, ITabPageConfig, TabViewIUState } from "@learn/tab_nav_api_har"
import { TabMainItemView } from "../TabMainItemView"

@Component
export struct YWMainNavTabBar {
  tabConfig?: ITabPageConfig
  bottomConfig?: ITabBottomBarConfig
  @State isVertical: boolean = false
  @State
  items: Array<ITabBottomBarConfig> = []
  @Consume("tabIUState")
  tabIUState: TabViewIUState
  @Consume("ITabEventState")
  tabEventState: ITabEventState

  aboutToAppear(): void {

  }

  build() {
    if (this.isVertical) {
      Column() {
        ForEach(this.tabIUState.tabInfo.mainNavList, (item: ITabPageConfig, index) => {
          TabMainItemView({ tabInfo: item.getTabBottomBarConfig(), isVertical: !this.isVertical })
            .onClick(() => {
              if (this.tabEventState) {
                this.tabEventState.onClickIndex(this.tabIUState.tabInfo.getCurrentTab()?.getTabBottomBarConfig()!, item.getTabBottomBarConfig())
              }
            })
            .width('100%')
            .height(YWConstants.kMainTabVerticalHeight)
            .backgroundColor(YWConstants.RandomColor())
        })
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .height('100%')
      .width(YWConstants.kMainTabVerticalWidth)
    } else {
      Row() {
        ForEach(this.tabIUState.tabInfo.mainNavList, (item: ITabPageConfig, index) => {
          TabMainItemView({ tabInfo: item.getTabBottomBarConfig(), isVertical: !this.isVertical })
            .onClick(() => {
              if (this.tabEventState) {
                this.tabEventState.onClickIndex(this.tabIUState.tabInfo.getCurrentTab()?.getTabBottomBarConfig()!, item.getTabBottomBarConfig())
              }
            })
            .layoutWeight(1)
            .height('100%')
        })
      }
      .height(YWConstants.kMainTabHeight)
      .width('100%')
    }

  }
}

