import { AxiosError, formToJSON } from '@ohos/axios';
import { HomePage } from './home/ctrl/HomePage'
import { BreakpointSystem, BreakPointType } from '../../../../../modules/common_har/src/main/ets/common/BreakPointSystem'
import { CategoryPage } from './category/ctrl/CategoryPage'
import { Account } from './Account'
import { UserInfoModel } from './accountInfo/model/UserInfoModel'
import requestModelAxios from '../model/RequestModelAxios'
import { Constants } from '../../../../../modules/common_har/src/main/ets/common/Constants'
import MinePage from './MinePage';
import { ThemeManager } from '../../../../../modules/common_har/src/main/ets/utils/ThemeManager';

@Entry
@Component
struct Index {
  @State currentTabIndex: number = 0

  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm'
  private breakpointSystem: BreakpointSystem = new BreakpointSystem()

  @Builder
  bottomBarItemBuilder(name: Resource, icon: Resource, selectIcon:Resource, index: number) {
    Flex({
      direction: new BreakPointType({
        sm: FlexDirection.Column,
        md: FlexDirection.Row,
        lg: FlexDirection.Column
      }).getValue(this.currentBreakpoint),
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      Image(this.currentTabIndex == index ? selectIcon: icon)
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

  onPageShow() {
    //页面每次显示时触发一次，包括路由过程、应用进入前台等场景
    console.log("=====onPageShow index 页面每次显示时触发一次，包括路由过程、应用进入前台等场景")

  }

  onPageHide() {
    //页面每次隐藏时触发一次，包括路由过程、应用进入后台等场景。
    console.log("====onPageHide index 页面每次隐藏时触发一次，包括路由过程、应用进入后台等场景。")
  }

  onBackPress() {
    console.log("===onBackPress index 当用户点击返回按钮时触发")
  }

  aboutToAppear() {
    this.breakpointSystem.register()
    console.log("====aboutToAppear 组件即将出现时回调该接口，具体时机为在创建自定义组件的新实例后，在执行其build()函数之前执行")

    // requestModelAxios.reqUserInfo()
    //   .then((value:Object)=>{
    //     console.log('==== req success:')
    //
    //     let localUseInf:UserInfoModel = value as UserInfoModel //JSON.parse(value.toString())
    //
    //     if (localUseInf != undefined) {//测试数据
    //       // localUseInf.isVip = true
    //       // localUseInf.vipDesc = '普通会员'
    //       // localUseInf.nickName = '一杯水'
    //       localUseInf.img = 'https://www.keaidian.com/uploads/allimg/191208/2019030707555443178.jpg'
    //       PersistentStorage.persistProp(Constants.kStorageLocalUser,localUseInf);
    //     }
    //
    //     AlertDialog.show({message:JSON.stringify(localUseInf)})
    //   })
    //   .catch((err:AxiosError)=>{
    //     console.log(`==== req fail:${JSON.stringify(err)}`)
    //     AlertDialog.show({message:JSON.stringify(err)})
    //
    //   })

    // requestModelAxios.reqUserInfoTwo()
    //   .then(value => {
    //     let localUseInf:UserInfoModel = value//JSON.parse(value.toString())
    //     AlertDialog.show({message:JSON.stringify(localUseInf)})
    //
    //   })
    //   .catch((error:string) => {
    //     AlertDialog.show({message:error})
    //
    //   })

  }

  aboutToDisappear() {
    this.breakpointSystem.unregister()
    console.log("===aboutToDisappear aboutToDisappear函数在自定义组件析构销毁之前执行。不允许在aboutToDisappear函数中改变状态变量，特别是@Link变量的修改可能会导致应用程序行为不稳定")

  }

  build() {
    Tabs({
      barPosition: new BreakPointType({
        sm: BarPosition.End,
        md: BarPosition.End,
        lg: BarPosition.Start
      }).getValue(this.currentBreakpoint)
    }) {
      TabContent() {
        HomePage()
      }.tabBar(this.bottomBarItemBuilder($r("app.string.tab_bar_home"), $r("app.media.home_normal"),$r('app.media.home_select'), 0))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

      TabContent() {
        CategoryPage()
      }.tabBar(this.bottomBarItemBuilder($r("app.string.tab_bar_category"),$r("app.media.tab_new"),$r("app.media.tab_new_select"), 1))

      TabContent() {
        // Account()
        MinePage()
      }.tabBar(this.bottomBarItemBuilder($r("app.string.tab_bar_account"), $r("app.media.me_normal"),$r("app.media.me_select"), 2))
    }
    .vertical(new BreakPointType({ sm: false, md: false, lg: true }).getValue(this.currentBreakpoint) as boolean)
    .barWidth(new BreakPointType({ sm: '100%', md: '100%', lg: '56vp' }).getValue(this.currentBreakpoint) as string)
    .barHeight(new BreakPointType({ sm: '56vp', md: '56vp', lg: '60%' }).getValue(this.currentBreakpoint) as string)
    .animationDuration(0)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

    .onChange((index) => {
      this.currentTabIndex = index
    })
  }

  private getTabBarColor(index: number) {
    return this.currentTabIndex == index ? $r('app.color.tab_bar_select_color') : $r('app.color.tab_bar_normal_color')
  }
}