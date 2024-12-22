import { BreakpointSystem, BreakPointType } from "@learn/common_har";
import { CategoryPage } from "../pages/CategoryPage";
import { HomePage } from "../pages/HomePage";
import { MinePage } from "../pages/MinePage";
import { hsLog } from '@learn/logger_har';

@Component
export struct MainPage {
  @State selectIndex: number = 0;

  aboutToAppear(): void {
    hsLog.i("======= aboutToAppear")
  }

  aboutToDisappear(): void {
    // this.appContext.
    hsLog.i("======= aboutToDisappear")

  }

  onPageShow(): void {
    hsLog.i("======= onPageShow")

  }
  onPageHide(): void {
    hsLog.i("======= onPageHide")

  }

  onBackPress(): boolean | void {
    hsLog.i("======= onPageHide")

  }

  @Builder
  tabBuilder() { //自定义 tab
    Row() {
      ForEach(['首页', '工具', '我的'], (item: string, index) => {
        Column() {//这里可以自己封装图标等
          Text(item)
            .fontColor(this.selectIndex === index ? Color.Red : Color.Black)
            .fontSize(this.selectIndex === index ? 25 : 18)
        }
        .height("100%")
        .layoutWeight(1)
        .justifyContent(FlexAlign.End)
        .padding({ top: 5, bottom: 5 })
        .onClick(() => {
          this.selectIndex = index;
        })
      })
    }
    .height(50)
    .width('100%')
  }

  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm'
  private breakpointSystem: BreakpointSystem = new BreakpointSystem()

  @Builder
  bottomBarItemBuilder(name: ResourceStr, icon: Resource, selectIcon:Resource, index: number) {
    Flex({
      direction: new BreakPointType({
        sm: FlexDirection.Column,
        md: FlexDirection.Row,
        lg: FlexDirection.Column
      }).getValue(this.currentBreakpoint),
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      Image(this.selectIndex == index ? selectIcon: icon)
        .height(24)
        .width(24)
        .fillColor(this.getTabBarColor(index))
      Text(name)
        .margin(new BreakPointType<Padding>({
          sm: { top: 4 },
          md: { left: 8 },
          lg: { top: 4 }
        }).getValue(this.currentBreakpoint) as Padding)
        .fontSize(11)
        .fontColor(this.getTabBarColor(index))
    }
  }

  private getTabBarColor(index: number) {
    return this.selectIndex == index ? $r('app.color.tab_normal_color') : $r('app.color.tab_bar_normal_color')
  }

  build() {
    Stack() {
      Tabs({ index: this.selectIndex, barPosition: BarPosition.End }) {
        ForEach(['首页', '分类', '我的'], (item: string, index: number) => {
          TabContent() {
            if (index === 0) {
              HomePage()
            } else if (index === 1) {
              CategoryPage()
            } else if (index === 2) {
              MinePage()
            }
          }.tabBar(this.bottomBarItemBuilder(item, $r("app.media.home_normal"),$r('app.media.home_select'), index))
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])


          // .tabBar(this.buildTabs(item, index))
        }, (item: string, index?: number) => index + JSON.stringify(item))
      }
      .barHeight(50)
      .onTabBarClick((index: number) => {
        this.selectIndex = index
      })
    }
    .width('100%')
    .layoutWeight(1)

  }
}
