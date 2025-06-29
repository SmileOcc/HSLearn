import { AxiosError, formToJSON } from '@ohos/axios';
import { HomePage } from '../pages/home/ctrl/HomePage'
import { CategoryPage } from '../pages/category/ctrl/CategoryPage'
import { Account } from '../pages/Account'
import { UserInfoModel } from '../pages/accountInfo/model/UserInfoModel'
import requestModelAxios from '../model/RequestModelAxios'
import MinePage from '../pages/MinePage';
import { BreakpointTypeEnum, ENU_CONTEXT, hsGlobalThis, YWDeviceUtils, YWNavRouterUtils,
  YWShowToast,BreakpointSystem, BreakPointType, ThemeManager, YWAvoidAreas, getDefaultAvoidAreas, getAvoidPadding,
  YWDialogUtils } from '@learn/common_har';
import { oldMainBuilder, YWMainPage } from '../pages/main/YWMainPage';
import { display } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { YWResImage } from '@learn/res_har';
import { GoodsDetailComponent } from '../pages/home/view/GoodsDetailComponent';
import { YWConstants } from '@learn/constants_har';
import { hsLog } from '@learn/logger_har';
import { YWDarkManager } from '@learn/dark_har';
// import { CatRouteUtils,RootPageBuilder } from '@learn/cat_har'
import { SettingPage } from '../pages/setting/SettingPage';
import { injectMainContext, ywNavManager, YWRouterNavParams, YWNavPath, ywNavRouter } from '@learn/nav_router_har';
import { YWLocalNavType } from '@learn/nav_router_har/src/main/ets/components/YWNavType';
import { DebuggerApi } from '@learn/debugger_api_har';
import BuildProfile from 'BuildProfile';

const TAG = "RootPage"
@Entry
@Component
struct RootPage {

  @State COMMON_TYPE: string = BuildProfile.COMMON_TYPE

  rootNav?:NavPathStack = ywNavManager.getNavStack(YWLocalNavType.NAV_ROOT)
  //暗黑模式
  @StorageLink(YWConstants.kLocalColorModel) @Watch('colorChange') private colorMode: number = YWDarkManager.getDefaultTheme()

  @StorageProp(YWConstants.kStorageAreas) avoidAreas: YWAvoidAreas = getDefaultAvoidAreas()

  @StorageProp('screenWidth') screenWidth: number = 0; //屏幕宽度（单位：vp）
  @StorageProp('bottomHeight') bottomHeight: number = 0; //导航栏高度（单位：vp）
  @Provide('isFullScreen') isFullScreen: boolean = false;

  @State currentTabIndex: number = 0

  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm'
  private breakpointSystem: BreakpointSystem = new BreakpointSystem()
  @State curFoldStatus: number = 0;
  // 依据Navigation的mode属性说明，如使用Auto，窗口宽度>=600vp时，采用Split模式显示；窗口宽度<600vp时，采用Stack模式显示。
  private readonly DEVICESIZE: number = 600;

  @State navigationMode: number = NavigationMode.Stack;
  private isSecondPressBack: boolean = false; // 在侧滑退出应用时，用于判断是否第二次滑动
  private readonly EXIT_TOAST_DURATION: number = 1800; // 侧滑拦截toast提示时长
  private readonly EXIT_PRESS_BACK_DURATION: number = 1000; // 两次侧滑事件间隔时长

  @StorageProp('splashFinish') splashFinish: boolean = false; //等待广告业加载完毕

  colorChange() {
    let kk = this.colorMode

  }
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
    console.log(TAG,"=====onPageShow index 页面每次显示时触发一次，包括路由过程、应用进入前台等场景")

  }

  onPageHide() {
    //页面每次隐藏时触发一次，包括路由过程、应用进入后台等场景。
    console.log(TAG,"====onPageHide index 页面每次隐藏时触发一次，包括路由过程、应用进入后台等场景。")
  }

  // 侧滑返回拦截功能：用于首页侧滑返回时，需在1秒内侧滑两次才能退出应用
  onBackPress(): boolean {
    console.log(TAG,"===onBackPress index 当用户点击返回按钮时触发")

    if (this.isSecondPressBack) {
      return false;
    } else {
      this.isSecondPressBack = true;
      setTimeout(() => {
        this.isSecondPressBack = false;
      }, this.EXIT_PRESS_BACK_DURATION);
      YWShowToast('再滑一次退出',this.EXIT_TOAST_DURATION)
      return true;
    }
  }

  aboutToAppear() {

    //可以根据不同配置环境 或自定义参数 处理
    //开发者可以在模块级的build-profile.json5文件中增加自定义参数
    //默认参数 自定义参数最好放各自target中 如ENV
    //注意：prd里 BUILD_TYPE 这里自定义的 取不到，总是取到default里的，感觉是bug , 优先放下面target中

    let BUILD_TYPE =  BuildProfile.BUILD_TYPE
    hsLog.i(TAG,`配置参数======注意 这个有问题 自定义 BUILD_TYPE: ${BuildProfile.BUILD_TYPE}`)
    hsLog.i(TAG,`配置参数======自定义 COMMON_TYPE: ${BuildProfile.BUILD_TYPE}`)
    hsLog.i(TAG,`配置参数======自定义环境标识 ENV: ${BuildProfile.ENV}`)

    hsLog.i(TAG,`配置参数======自定义COMMON_TYPE: ${this.COMMON_TYPE}`)
    hsLog.i(TAG,`配置参数======应用的Bundle名称 BUNDLE_NAME: ${BuildProfile.BUNDLE_NAME}`)
    hsLog.i(TAG,`配置参数======应用的Bundle类型 BUNDLE_TYPE: ${BuildProfile.BUNDLE_TYPE}`)
    hsLog.i(TAG,`配置参数======应用的版本号 VERSION_CODE: ${BuildProfile.VERSION_CODE}`)
    hsLog.i(TAG,`配置参数======应用版本号的文字描述 VERSION_NAME: ${BuildProfile.VERSION_NAME}`)
    hsLog.i(TAG,`配置参数======Target名称 TARGET_NAME: ${BuildProfile.TARGET_NAME}`)
    hsLog.i(TAG,`配置参数======Product名称 PRODUCT_NAME: ${BuildProfile.PRODUCT_NAME}`)
    hsLog.i(TAG,`配置参数======编译模式 BUILD_MODE_NAME: ${BuildProfile.BUILD_MODE_NAME}`)
    hsLog.i(TAG,`配置参数======应用是否可调试 DEBUG: ${BuildProfile.DEBUG}`)


    //最后不需要$  $表示结束位置
    const testReg =  new RegExp('^(https?):\\/\\/aaaa\\.bbbb\\.cn\\/space\\/ddd\\/$')
    const testRegb = "https://aaaa.bbbb.cn/space/ddd/mmmm=&aaa=bbb"
    let isk = testReg.test(testRegb) //false

    const testReg2 =  new RegExp('^(https?):\\/\\/aaaa.bbbb.cn\\/space\\/ddd\\/')
    let iskk = testReg2.test(testRegb) //true

    const testReg3 =  new RegExp('^(https?):\\/\\/aaaa\\.bbbb\\.cn\\/space\\/ddd\\/')
    let iskkk = testReg3.test(testRegb) //true

    const testRegbb = "https://aaaa.bbbb.cn/space/ddd/"
    let iskkkkk = testReg.test(testRegbb)//true


    injectMainContext(this.getUIContext())
    hsGlobalThis.setContext(ENU_CONTEXT.UI_Root,getContext(this) as common.UIAbilityContext)
    YWDialogUtils.init(this.getUIContext())
    this.breakpointSystem.register()
    console.log("====aboutToAppear 组件即将出现时回调该接口，具体时机为在创建自定义组件的新实例后，在执行其build()函数之前执行")

    //注册debugger调试窗
    DebuggerApi.registerDebugger()
    //注册原项目的demo tab
    ywNavRouter.boundRouteName(YWLocalNavType.NAV_ROOT,[
      {name:YWNavPath.root_old_test_demo,builder:wrapBuilder(oldMainBuilder)},
    ])

    //跳转到主NAV_MAIN_NAV
    ywNavRouter.openRoute(this.getUniqueId())
      .onTargetUrl(YWNavPath.root_main_nav)
      .onRouteMode()
      .onOpenAnimation(false)
      .go()

    if (YWDeviceUtils.isFoldable()) {
      YWDeviceUtils.onFoldStatusChange((curFoldStatus: display.FoldStatus)=>{

        // 同一个状态重复触发不做处理
        if (this.curFoldStatus === curFoldStatus) {
          return;
        }
        // 缓存当前折叠状态
        this.curFoldStatus = curFoldStatus;
        this.changeNavigationMode(this.curFoldStatus);
      })
    } else {
      if (this.screenWidth >= this.DEVICESIZE) {
      // if (this.currentBreakpoint == BreakpointTypeEnum.LG) {
        this.navigationMode = NavigationMode.Split;
      } else {
        this.navigationMode = NavigationMode.Stack;
      }
    }

    // YWNavRouterUtils.push('SplashPage')

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
    //       PersistentStorage.persistProp(YWConstants.kStorageLocalUser,localUseInf);
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
    injectMainContext(undefined)
    this.breakpointSystem.unregister()
    console.log("===aboutToDisappear aboutToDisappear函数在自定义组件析构销毁之前执行。不允许在aboutToDisappear函数中改变状态变量，特别是@Link变量的修改可能会导致应用程序行为不稳定")

  }

  @Builder
  PagesMap(name: string, param: YWRouterNavParams) {
     ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_ROOT)(name)?.builder(name,param)
  }

  // 更改NavigationMode
  changeNavigationMode(status: number): void {
    if (status === display.FoldStatus.FOLD_STATUS_FOLDED) {
      this.navigationMode = NavigationMode.Stack;
    } else {
      this.navigationMode = NavigationMode.Split;
    }
  }

  build() {
    Stack() {
      // Navigation(YWNavRouterUtils.navPathStack) {

      Navigation(this.rootNav) {
        // if (this.splashFinish) {
        //   YWMainPage().layoutWeight(1)
        //   Divider().height(this.bottomHeight).visibility(Visibility.Hidden)
        // } else {
        //   Column() {
        //     Text('欢迎来到 HSLearn！')
        //       .fontColor($r('app.color.theme_light'))
        //       .fontSize($r('app.float.size_splash_text_title'))
        //       .fontWeight(FontWeight.Bold)
        //     Image(YWResImage.appIcon())
        //       .width($r('app.float.size_splash_icon'))
        //       .objectFit(ImageFit.Contain)
        //       .margin({ top: $r('app.float.top_splash_text') })
        //   }
        //   .height('100%')
        //   .width('100%')
        //   .justifyContent(FlexAlign.Center)
        //   .alignItems(HorizontalAlign.Center)
        // }
      }
      .width('100%')
      .height('100%')
      .hideTitleBar(true)
      .navBarWidth('50%')
      .navDestination(this.PagesMap)
      .hideNavBar(this.isFullScreen)
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
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .alignContent(Alignment.BottomEnd)
    .backgroundColor($r('app.color.bg_base'))
    // .padding(getAvoidPadding(this.avoidAreas))
    .onClick(()=>{
      DebuggerApi.debuggerOpen()
    })
  }

  // build() {
  //   Tabs({
  //     barPosition: new BreakPointType({
  //       sm: BarPosition.End,
  //       md: BarPosition.End,
  //       lg: BarPosition.Start
  //     }).getValue(this.currentBreakpoint)
  //   }) {
  //     TabContent() {
  //       HomePage()
  //     }.tabBar(this.bottomBarItemBuilder($r("app.string.tab_bar_home"), $r("app.media.home_normal"),$r('app.media.home_select'), 0))
  //     .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  //
  //     TabContent() {
  //       CategoryPage()
  //     }.tabBar(this.bottomBarItemBuilder($r("app.string.tab_bar_category"),$r("app.media.tab_new"),$r("app.media.tab_new_select"), 1))
  //
  //     TabContent() {
  //       // Account()
  //       MinePage()
  //     }.tabBar(this.bottomBarItemBuilder($r("app.string.tab_bar_account"), $r("app.media.me_normal"),$r("app.media.me_select"), 2))
  //   }
  //   .vertical(new BreakPointType({ sm: false, md: false, lg: true }).getValue(this.currentBreakpoint) as boolean)
  //   .barWidth(new BreakPointType({ sm: '100%', md: '100%', lg: '56vp' }).getValue(this.currentBreakpoint) as string)
  //   .barHeight(new BreakPointType({ sm: '56vp', md: '56vp', lg: '60%' }).getValue(this.currentBreakpoint) as string)
  //   .animationDuration(0)
  //   .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  //
  //   .onChange((index) => {
  //     this.currentTabIndex = index
  //   })
  // }

  private getTabBarColor(index: number) {
    return this.currentTabIndex == index ? $r('app.color.tab_bar_select_color') : $r('app.color.tab_bar_normal_color')
  }
}