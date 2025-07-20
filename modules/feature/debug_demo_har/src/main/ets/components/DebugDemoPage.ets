import { ywDebugGlobal } from "../core/DebugGlobal";
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"
import { SetItemModel } from "../mode/SetItemModel";
import { common, Want } from "@kit.AbilityKit";
import { router } from "@kit.ArkUI";
import { getAvoidPadding, getDefaultAvoidAreas, PreferencesUtil, RouterUtils, YWAvoidAreas } from "@learn/common_har";
import { WebViewDemo, webViewDemoBuilder } from "../pages/web/layer_web/FeatureComponent";
import { TigerOpenApi, TigerOpenImp } from "@learn/tiger_har";
import { createPreWeb } from "../../../../Index";
// import { TestPreWebBuilder } from "../pages/web/pre_web/TestPreWebPage";
import { YWConstants } from "@learn/constants_har";
import { TestPreWebPageBuilder } from "../pages/web/pre_web/TestPreWebPage";
import { TestWWebPageBuilder } from "../pages/web/web/TestWWebPage";
import { createPreNodeWeb } from "../pages/web/pre_node_web/PreNodeWebNodeController";
import { TestObservedBuilder } from "../pages/observed/TestBaseObserved";
import { TestEventHubEmitterBuilder } from "../pages/eventhub_emmiter/EventHubAndEmitterTestPage";
import { TestPromptAlertBuilder } from "../pages/popup_alert/PromptActionClass";
import { TestPictureLibraryBuilder } from "../pages/popup_alert/PictureLibraryDemo";
import { YWRouterNavParams } from "@learn/nav_router_har";
import { SafeAreaExample1Builder } from "../pages/expand_safe_area/SafeAreaExample1";
import { testNodeBuilder } from "../pages/node_controller/TestNodePage";
import { SafeAreaExample2Builder } from "../pages/expand_safe_area/SafeAreaExample2";
import { SafeAreaExample3Builder } from "../pages/expand_safe_area/SafeAreaExample3";
import { SafeAreaExample4Builder } from "../pages/expand_safe_area/SafeAreaExample4";
import { SafeAreaExample5Builder } from "../pages/expand_safe_area/SafeAreaExample5";
import { SafeAreaExample6Builder } from "../pages/expand_safe_area/SafeAreaExample6";
import { TestScrollTwoGestureBuilder } from "../pages/gesture/ScrollTwoGesturePage";
import { TestScrollWebGestureBuilder } from "../pages/gesture/ScrollWebGesturePage";
import { TestIndicatorBuilder } from "../pages/indicator/TestIndicatorPage";
import { TestAlertViewBuilder } from "../pages/popup_alert/TestAlertViewPage";
import { TestListItemMoveBuilder } from "../pages/gesture/TestListItemMovePage";
import { SafeAreaExample7Builder } from "../pages/expand_safe_area/SafeAreaExample7";
import { TestZipFileBuilder } from "../pages/file/ZipTestPage";
import { TestListItemDragMoveBuilder } from "../pages/gesture/TestListItemDragMovePage";
import { TestListExchangeBuilder } from "../pages/listexchange/list_one/ListExchangeView";
import { TestListDragViewBuilder } from "../pages/listexchange/list_two_drage/ListDragViewPage";
import { TestListDragViewTwoBuilder } from "../pages/listexchange/list_two_drage/ListDragViewPageTwo";
import { TestDrawPathPageBuilder } from "../pages/draw_path/TestDrawPathPage";
import { listerScrollMoreBuilder } from "../pages/list_scroller/ListScrollerMutl";
import { scrollWebListBuilder } from "../pages/list_scroller/ScrollWebListPage";
import { scrollWebListCommentBuilder } from "../pages/list_scroller/scrollweblistcomment/ScrollWebListCommentPage";
import { TestGradientPageBuilder } from "../pages/gradient/TestGradientPage";
import {
  testNodeExtendBuilder } from "../pages/node_controller/node_ext_alert/TestNodeExtendExample";

// import { TestWWebPageBuilder } from "../pages/web/web/TestWWebPage";

@Builder
export function debugDemoBuilder(name: string, params: YWRouterNavParams) {
  NavDestination() {
    DebugDemoPage({ navParams: params })
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

const TAG = "DebugDemoPage"

@Component
export struct DebugDemoPage {
  @State message: string = 'Hello World';
  @StorageProp(YWConstants.kStorageAreas) avoidAreas: YWAvoidAreas = getDefaultAvoidAreas()
  private context = getContext(this) as common.UIAbilityContext
  @State tempGroupList: SetItemModel[][] = new Array
  @State allGroupList: SetItemModel[] = new Array
  @State showLoading: boolean = false
  navParams?: YWRouterNavParams
  private tigerOpenApi: TigerOpenApi = new TigerOpenImp()

  onPageShow() {
    //全局数据获取
    const KEY_APP_PRIVACY = 'nutsusKey';

    let kkk22 = AppStorage.get("aaa") as string
    let kkk2233 = AppStorage.get("isLoginGG") as string


    // let author = globalThis.getAttribute("author");
    // let org = globalThis.getAttribute("org");
    //
    // let context: common.UIAbilityContext | undefined = globalThis.getMainAbilityContext();
    // if (context != undefined) {
    //   let label = context.abilityInfo.bundleName;
    // }
    //
    // let preferences: Promise<dataPreferences.Preferences> | undefined = globalThis.getPref(ENU_PREFS.Global)
    // if (preferences != undefined) {
    //   preferences.then((result: dataPreferences.Preferences) => {
    //     result.get(KEY_APP_PRIVACY, "").then((data) => {
    //       let message = String(data);
    //     })
    //   }).catch((err: BusinessError) => {
    //     console.error('xx get the preferences failed, err: ' + err);
    //   })
    // }
  }

  aboutToAppear(): void {
    ywDebugGlobal.init(this.getUIContext())


    this.navParams?.getPageLifecycleImp().setPageOnShow(() => {
      hsLog.i(TAG, "--pageOnShow")

    })
    this.navParams?.getPageLifecycleImp().setPageOnHide(() => {
      hsLog.i(TAG, "--pageOnHide")

    })

    // 预先创建一个空的ArkWeb动态组件（需传入UIContext），拉起渲染进程
    createPreWeb('about://blank', this.getUIContext())
    // hsLog.d(DisplayUtil.getWidth() +' util11')//1260 util11
    // hsLog.d(DisplayUtil.getHeight() +' util11')//2720 util11


    // 创建ArkWeb动态组件（需传入UIContext），loadContent之后的任意时机均可创建
    createPreNodeWeb('https://blank', this.getUIContext());

    // window.getLastWindow(this.context).then((windowClass) => {
    //   windowClass.setWindowSystemBarEnable(["status", "navigation"]).then(() => {
    //   })
    // })
    let isPhone = true


    let list: String[] = Array(5).fill(Math.random().toString().slice(2, 2 + 4))
    let gropList: String[][] = [
      ["渐变色"],
      ["TestWeb", "web同层组件", "webPre预加载web", "2webPre预加载web", "3webPre预加载web", "测试NodeController","测试Node扩展弹窗"],
      ["调试Observed", "TestEventHub_Emitter", "新自定义弹窗", "半弹窗选择图片", "push弹窗测试+移动cell"],
      ["SafeAreaExample全区实现沉浸式效果", "SafeAreaExample1全区实现沉浸式效果", "SafeArea滚动列表底部延伸场景",
        "SafeArea重要信息被软键盘遮挡", "SafeArea软键盘弹出导致布局错位", "SafeArea自定义弹窗被键盘顶起","SafeArea标题组件不避让"],
      ["Scroller嵌套Scroller","Scroller嵌套Web","listItem上下移动","listItem拖动移动位置","list移动交换cell","list、gard拖拽交换位置","list two拖拽交换位置",'多层嵌套滑动ScrollWebList', '多层滑动嵌套',"list横向滚动固定头部"],
      ["消息列表 MessageListPage", "list分组红点","list移动交换cell","list、gard拖拽交换位置", "scroll集合", "自动缩放适配", "layoutWeight", "PullRefreshPage",
        "PullRefreshLazyPage", "PullRefreshListPage", "SwiperStackPage", "TopSlideMenuTestPage"],
      ["测试滑动指示器"],
      ['图形绘制'],
      ["基础数据", "自定义tab", "相对布局Relative", "横竖屏旋转", "测试NavDestination", "测试弹窗WrapBuilder"],
      ["请求调试", "数据库DBUtils", "分布式键值数据库distributedKVStore", "首选项PreferencesUtil",
        "共享LocalStoragePage", "LocalStorageAppStoragePage", "调试preferences", "调试Axios请求"],
      ["docAbility-specified",
        "savedAbility-docAbility-multition",
        "TestHarPage 通过routerName跳转",
        "TestHarTwoPg 通过routerName跳转",
        "Share_Har 页面跳转",
        "网页打开",
        "浏览器打开",
        "登录页",
        "登录注册页1", "登录注册页2", "动态导入登录模块"],
      ["录音转文字"],
      ["TaskPoolPage", "TaskPoolCpuPage", "TaskPoolSyncTaskPage", "worker Test", "其他"],
      ["图片相册PhotoCameraPage", "保存图片相册", "图片上传", "window悬浮弹窗", "buildParams Page",
        "ProvideConsumPage祖孙", "showLoading全局"],
      ["Emitter组件间的通信和数据传递", "通知NotificationPage"],
      ["文件路径FilePagePage","解压zip文件"],
      ["MarginPaddingPage"],
      ["设备硬件信息：HardwareInfoPage"],
      ["支付首页全适配：PaymentHomePage"],
      ["tiger_har_app", "cat_har_app"],

      ["注销账号", "退出"]]


    for (let i = 0; i < gropList.length; i++) {
      let itemListArray: SetItemModel[] = new Array
      for (let j = 0; j < gropList[i].length; j++) {

        let itemTitle = gropList[i][j]
        let itemModel = new SetItemModel()
        itemModel.title = itemTitle + `${i} + ${j}`
        itemModel.desc = 'desc' + `${j}`
        itemModel.image = $r('app.media.logo')
        itemListArray.push(itemModel)
      }
      this.tempGroupList.push(itemListArray)
    }

    for (let i = 0; i < gropList.length - 1; i++) {

      let itemTitle = gropList[i]
      let itemModel = new SetItemModel()
      itemModel.title = "组头" + i

      for (let j = 0; j < gropList[i].length - 1; j++) {

        let itemTitle = gropList[i][j]
        itemModel.items.push(itemTitle)
      }
    }
  }

  @Builder
  itemHead(text: string) {
    Text(text)
      .fontSize(20)
      .backgroundColor(Color.White)
      .width('100%')
      .padding({ left: 12, top: 5, bottom: 5 })
      .borderRadius({
        topLeft: 12,
        topRight: 12,
      })
      .clip(true)
  }

  @Builder
  itemCellView(itms: SetItemModel[]) {

    ForEach(itms, (subModel: SetItemModel, index) => {

      ListItem() {
        if (index == itms.length - 1) {
          Row() {
            Row() {
              Image($r('app.media.logo'))
                .height(24)
                .width(24)
                .objectFit(ImageFit.Contain)
                .padding({ left: 12 })

              Text(`${subModel.title}:${index}`)
                .fontSize(14)
                .fontColor('#222222')
                .textAlign(TextAlign.Start)
                .padding({ left: 8 })
            }


            Text(`${subModel.desc}`)
              .fontSize(12)
              .fontColor('#999999')
              .textAlign(TextAlign.End)
              .padding({ right: 12 })
          }
          .width('100%')
          .height(44)
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween)

        } else {
          Row() {
            Row() {
              Image($r('app.media.logo'))
                .height(24)
                .width(24)
                .objectFit(ImageFit.Contain)
                .padding({ left: 12 })

              Text(`${subModel.title}:${index}`)
                .fontSize(14)
                .fontColor('#222222')
                .textAlign(TextAlign.Start)
                .padding({ left: 8 })
            }


            Text(`${subModel.desc}`)
              .fontSize(12)
              .fontColor('#999999')
              .textAlign(TextAlign.End)
              .padding({ right: 12 })

          }
          .width('100%')
          .height(44)
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween)
        }
      }
      .backgroundColor(Color.White)
      .borderRadius(index == itms.length - 1 ? {
        bottomLeft: 12,
        bottomRight: 12,
      } : 0)
      .clip(true)
      .onAppear(() => {
        //console.log(`======= ${subModel.title}}`)
      })
      .onClick((event) => {
        console.log(subModel.title + "ccc")
        if (subModel.title.includes("基础数据")) {
          router.pushUrl({
            url: 'pages/base/TestDataHandlePage',
            params: {}
          })
        }
        if (subModel.title.startsWith('请求调试')) {
          router.pushUrl({
            url: 'pages/base/TestRequestPage',
            params: { 'name': 'abc', 'title': '123', 'lis': ['11', '22', '33'] }
          })
        }
        if (subModel.title.startsWith('数据库')) {
          router.pushUrl({ url: 'pages/base/DBPage' })
        }

        if (subModel.title.startsWith('调试preferences')) {
          router.pushUrl({
            url: 'pages/base/TestPreferencesPage',
            params: { 'name': 'abc', 'title': '123', 'lis': ['11', '22', '33'] }
          })

        }

        if (subModel.title.startsWith('分布式键值数据库distributedKVStore')) {
          router.pushUrl({
            url: 'pages/base/TestKVStorePage',
            params: { 'name': 'abc', 'title': '123', 'lis': ['11', '22', '33'] }
          })

        }

        if (subModel.title.startsWith('调试Axios')) {
          router.pushUrl({ url: 'pages/base/TestAxiosPage', })

        }

        if (subModel.title.startsWith('docAbility')) {
          // 跳转到文档列表的 UIAbility
          let want: Want = {
            deviceId: '',
            bundleName: 'com.example.hmos_learn',
            moduleName: 'entry',
            abilityName: 'DocAbility'
          }
          // 跳转
          this.context.startAbility(want)
        }

        if (subModel.title.startsWith('savedAbility')) {
          router.pushUrl({ url: 'pages/ability/TestSaveDocPage' })
        }

        if (subModel.title.startsWith('TestHarPage 通过routerName跳转')) {
          router.pushNamedRoute({
            //har 对应页面都要取一个名字
            name: 'TestHarPage'
          })

        }

        if (subModel.title.startsWith('TestHarTwoPg 通过routerName跳转')) {
          router.pushNamedRoute({
            //har 对应页面都要取一个名字
            name: 'TestHarTwoPg', params: { 'name': '123' }
          })

        }

        if (subModel.title.startsWith('Share_Har')) {
          //'@bundle:包名（bundleName）/模块名（moduleName）/路径/页面所在的文件名(不加.ets后缀)'
          // router.pushUrl({ url: '@bundle:com.example.hmos_learn/ShareHarLibs/src/main/ets/pages/HWSuccessPage' })

        }

        if (subModel.title.startsWith('TaskPoolPage')) {
          router.pushUrl({ url: 'pages/taskpoolWorker/TaskPoolPage' })

        }

        if (subModel.title.startsWith('TaskPoolCpuPage')) {
          router.pushUrl({ url: 'pages/taskpoolWorker/TaskPoolCpuPage' })

        }
        if (subModel.title.startsWith('TaskPoolSyncTaskPage')) {
          RouterUtils.jumpRouter('pages/taskpoolWorker/TaskPoolSyncTaskPage')
        }

        if (subModel.title.startsWith('图片相册')) {
          router.pushUrl({ url: 'pages/photoCamera/PhotoCameraPage' })
        }

        if (subModel.title.startsWith('保存图片相册')) {
          router.pushUrl({ url: 'pages/photoCamera/SaveNetPicturePage' })

        }

        if (subModel.title.startsWith('网页打开')) {
          RouterUtils.openWeb('https://www.baidu.com')
        }

        if (subModel.title.startsWith('浏览器')) {
          RouterUtils.openBrowser(this.context, 'https://www.baidu.com')
        }

        // if (subModel.title.includes('登录注册页1')) {
        if (subModel.title.startsWith('登录注册页1')) {
          RouterUtils.jumpRouter('pages/base/registerlogin/LoginPageOne')
          return
        }
        if (subModel.title.startsWith('"登录注册页2"')) {

        }
        if (subModel.title.startsWith('动态导入登录模块')) {
          this.testAction('动态导入登录模块')
        }

        if (subModel.title.startsWith('登录')) {
          RouterUtils.openLogin().then(() => {
            hsLog.d('进入登录页')
          })
            .catch(() => {

            })
        }

        if (subModel.title.startsWith('Emitter组件间的通信和数据传递')) {
          RouterUtils.jumpRouter('pages/base/EmitterBasePage')
        }

        if (subModel.title.startsWith('首选项PreferencesUtil')) {
          console.info('====当前内存信息 1 ', JSON.stringify(PreferencesUtil.getInstance()))
          PreferencesUtil.getInstance().mUserInfo.userToken = "测试测试"
          PreferencesUtil.saveData(this.context)
          console.info('====当前内存信息 2 ', JSON.stringify(PreferencesUtil.getInstance()))

        }

        if (subModel.title.startsWith('window悬浮弹窗')) {

          RouterUtils.jumpRouter('pages/base/WindowFloatPage')
        }

        if (subModel.title.startsWith('消息列表')) {
          router.pushUrl({ url: 'pages/message/MessageListPage' })

        }

        if (subModel.title.startsWith('scroll集合')) {
          router.pushUrl({ url: 'pages/accountInfo/ScrollListPage' })
        }

        if (subModel.title.startsWith('layoutWeight')) {
          router.pushUrl({ url: 'pages/columnRowShow/layoutWeightPage' })
        }

        if (subModel.title.startsWith('共享LocalStoragePage')) {
          RouterUtils.jumpRouter('pages/base/LocalStoragePage')
        }

        if (subModel.title.startsWith('通知NotificationPage')) {
          RouterUtils.jumpRouter('pages/base/NotificationPage')

        }

        if (subModel.title.startsWith('buildParams')) {
          RouterUtils.jumpRouter('pages/base/TestBuilderParamPage')
        }

        if (subModel.title.startsWith('showLoading')) {
          this.showLoading = true;
          setTimeout(() => {
            this.showLoading = false;
          }, 3000);
        }

        if (subModel.title.startsWith('PullRefreshPage')) {
          RouterUtils.jumpRouter('pages/base/PullRefreshPage')

        }

        if (subModel.title.startsWith('PullRefreshLazyPage')) {
          RouterUtils.jumpRouter('pages/base/PullRefreshLazyPage')

        }

        if (subModel.title.startsWith('PullRefreshListPage')) {
          RouterUtils.jumpRouter('pages/base/PullRefreshListPage')
        }

        if (subModel.title.startsWith('ProvideConsumPage')) {
          RouterUtils.jumpRouter('pages/base/ProvideConsumPage')
        }

        if (subModel.title.startsWith('worker')) {
          RouterUtils.jumpRouter('pages/base/WorkerTestPage')
        }

        if (subModel.title.startsWith('MarginPaddingPage')) {
          RouterUtils.jumpRouter('pages/base/MarginPaddingPage')
        }

        if (subModel.title.startsWith('LocalStorageAppStoragePage')) {
          RouterUtils.jumpRouter('pages/base/LocalStorageAppStoragePage')
        }

        if (subModel.title.startsWith('SwiperStackPage')) {
          RouterUtils.jumpRouter('pages/base/SwiperStackPage')
        }

        if (subModel.title.startsWith('TopSlideMenuTestPage')) {
          RouterUtils.jumpRouter('pages/base/TopSlideMenuTestPage')
        }

        if (subModel.title.startsWith('文件路径')) {
          RouterUtils.jumpRouter('pages/base/FilePagePage')
        }

        if (subModel.title.startsWith('支付首页全适配：PaymentHomePage')) {
          RouterUtils.jumpRouter('pages/paymentHomePage/PaymentHomePage')
        }

        if (subModel.title.startsWith('设备硬件信息：HardwareInfoPage')) {
          RouterUtils.jumpRouter('pages/base/HardwareInfoPage')
        }

        if (subModel.title.startsWith('tiger_har_app')) {

          this.tigerOpenApi.openTigerApp("tiger_id", "123")
        }
        if (subModel.title.startsWith('cat_har_app')) {
          // const catApi = new CatOpenImp()
          // catApi.openCatApp("cat_id","123")

          // YWNavRouterUtils.navPathStack.pushPath({name:"cat_har_app"},true)
        }

        if (subModel.title.includes('录音转文字')) {
          RouterUtils.jumpRouter('pages/base/audio/TestAudioSearchCompPage')
        }

        if (subModel.title.includes('图片上传')) {
          RouterUtils.jumpRouter('pages/photoCamera/UpdateImagePage')
        }

        if (subModel.title.includes('自动缩放适配')) {
          RouterUtils.jumpRouter('pages/base/autoflexshrink/AutoFlexShrinkPage')
        }

        if (subModel.title.includes('自定义tab')) {
          RouterUtils.jumpRouter('pages/base/TestTabBarPage')
        }

        if (subModel.title.includes('相对布局Relative')) {
          RouterUtils.jumpRouter('pages/base/relativelayout/TestRelativeContainerPage')
        }

        if (subModel.title.includes('横竖屏旋转')) {
          RouterUtils.jumpRouter('pages/base/relativelayout/TestWindowOrientationPage')
        }

        if (subModel.title.includes('list分组红点')) {
          RouterUtils.jumpRouter('pages/base/listscroll/TestListScrollPage')
        }

        if (subModel.title.includes('list移动交换cell')) {
          this.demoPageNav.pushPathByName('list移动交换cell',true)
        }
        if (subModel.title.includes("list two拖拽交换位置")) {
          this.demoPageNav.pushPathByName("list two拖拽交换位置",true)
        }

        if (subModel.title.includes('测试NavDestination')) {
          RouterUtils.jumpRouter('pages/base/navtest/TestNavigationDestionationPage')
        }

        if (subModel.title.includes('测试弹窗WrapBuilder')) {
          RouterUtils.jumpRouter('pages/base/wrapbuilder/dialog/TestWrapBuilderDialog')
        }

        if (subModel.title.startsWith("TestWeb")) {
          this.demoPageNav.pushPathByName("TestWeb", true)
        }
        if (subModel.title.includes("web同层组件")) {
          this.demoPageNav.pushPathByName("WebViewDemo", true)
        }

        if (subModel.title.startsWith("webPre预加载web")) {
          this.demoPageNav.pushPathByName("PreWebViewDemo", true)
        }

        if (subModel.title.startsWith("2webPre预加载web")) {
          this.demoPageNav.pushPathByName("aaPreWebView", true)
        }
        if (subModel.title.startsWith("3webPre预加载web")) {
          this.demoPageNav.pushPathByName("bbPreWebView", true)
        }
        if (subModel.title.startsWith("调试Observed")) {
          this.demoPageNav.pushPathByName("调试Observed", true)
        }
        if (subModel.title.startsWith("TestEventHub_Emitter")) {
          this.demoPageNav.pushPathByName("TestEventHub_Emitter", true)
        }
        if (subModel.title.startsWith("新自定义弹窗")) {
          this.demoPageNav.pushPathByName("TestPromptAlertBuilder", true)
        }
        if (subModel.title.startsWith("半弹窗选择图片")) {
          this.demoPageNav.pushPathByName("TestPictureLibraryBuilder", true)
        }
        if (subModel.title.startsWith("SafeAreaExample全区实现沉浸式效果")) {
          this.demoPageNav.pushPathByName("SafeAreaExample全区实现沉浸式效果", true)

        }
        if (subModel.title.startsWith("SafeAreaExample1全区实现沉浸式效果")) {
          this.demoPageNav.pushPathByName("SafeAreaExample1全区实现沉浸式效果", true)
        }
        if (subModel.title.startsWith("SafeArea滚动列表底部延伸场景")) {
          this.demoPageNav.pushPathByName("SafeArea滚动列表底部延伸场景", true)
        }
        if (subModel.title.startsWith("SafeArea重要信息被软键盘遮挡")) {
          this.demoPageNav.pushPathByName("SafeArea重要信息被软键盘遮挡", true)
        }
        if (subModel.title.startsWith("SafeArea软键盘弹出导致布局错位")) {
          this.demoPageNav.pushPathByName("SafeArea软键盘弹出导致布局错位", true)
        }
        if (subModel.title.startsWith("SafeArea自定义弹窗被键盘顶起")) {
          this.demoPageNav.pushPathByName("SafeArea自定义弹窗被键盘顶起", true)
        }
        if (subModel.title.startsWith("SafeArea标题组件不避让")) {
          this.demoPageNav.pushPathByName("SafeArea标题组件不避让",true)
        }

        if (subModel.title.startsWith("测试NodeController")) {
          this.demoPageNav.pushPathByName("测试NodeController", true)
        }
        if (subModel.title.startsWith("测试Node扩展弹窗")) {
          this.demoPageNav.pushPathByName("测试Node扩展弹窗", true)
        }
        if (subModel.title.startsWith("Scroller嵌套Scroller")) {
          this.demoPageNav.pushPathByName("Scroller嵌套Scroller",true)
        }
        if (subModel.title.startsWith("Scroller嵌套Web")) {
          this.demoPageNav.pushPathByName("Scroller嵌套Web",true)
        }
        if (subModel.title.startsWith("测试滑动指示器")) {
          this.demoPageNav.pushPathByName("测试滑动指示器",true)
        }
        if (subModel.title.startsWith("push弹窗测试+移动cell")) {
          this.demoPageNav.pushPathByName("push弹窗测试+移动cell",true)
        }
        if (subModel.title.startsWith("listItem上下移动")) {
          this.demoPageNav.pushPathByName("listItem上下移动", true)
        }
        if (subModel.title.startsWith("listItem拖动移动位置")) {
          this.demoPageNav.pushPathByName("listItem拖动移动位置", true)
        }
        if (subModel.title.startsWith('list、gard拖拽交换位置')) {
          this.demoPageNav.pushPathByName('list、gard拖拽交换位置',true)
        }
        if (subModel.title.startsWith('解压zip文件')) {
          this.demoPageNav.pushPathByName('解压zip文件', true)
        }
        if (subModel.title.startsWith('图形绘制')) {
          this.demoPageNav.pushPathByName('图形绘制',true)
        }
        if (subModel.title.startsWith('list横向滚动固定头部')) {
          this.demoPageNav.pushPathByName('list横向滚动固定头部', true)
        }
        if (subModel.title.startsWith('多层滑动嵌套')) {
          this.demoPageNav.pushPathByName('多层滑动嵌套',true)
        }
        if (subModel.title.startsWith('多层嵌套滑动ScrollWebList')) {
          this.demoPageNav.pushPathByName('多层嵌套滑动ScrollWebList',true)
        }
        if (subModel.title.startsWith('渐变色')) {
          this.demoPageNav.pushPathByName('渐变色', true)
        }
      })

    })

  }

  @State navigationMode: number = NavigationMode.Stack;
  demoPageNav = ywDebugGlobal.getMainNav()

  async testAction(name:string) {
    if (name == '动态导入登录模块') {
      await import("@learn/login_import_module_har").then((result: ESObject) => {
        // 动态加载模块成功时，通过模块中的harInit接口加载页面
        result.harInit("register"); //然后在harInit函数中进行，动态 registerPage 页面
      }, (error: ESObject) => {
        // 动态加载模块失败时，打印错误日志
        hsLog.e(TAG,"error : " + JSON.stringify(error))
      });
    }
  }

  @Builder
  navPagesMap(name: string, param: Map<string, Object>) {
    if (name == "WebViewDemo") {

      webViewDemoBuilder("aa", new Map)
    } else if (name == "TestWeb") {
      TestWWebPageBuilder("xx")
    } else if (name == "PreWebViewDemo") {

      // TestPreWebBuilder("https://www.baidu.com")
      TestPreWebPageBuilder("https://zhuanlan.zhihu.com/p/719287092")

    } else if (name == "aaPreWebView") {

      TestPreWebPageBuilder("https://www.baidu.com")
    } else if (name == "bbPreWebView") {

      TestPreWebPageBuilder("https://www.zhihu.com")

      // TestPreWebPageBuilder("https://developer.huawei.com/consumer/cn/doc/harmonyos-faqs-V5/faqs-app-debugging-14-V5")
    } else if (name == "调试Observed") {
      TestObservedBuilder()
    } else if (name == "TestEventHub_Emitter") {
      TestEventHubEmitterBuilder()
    } else if (name == "TestPromptAlertBuilder") {
      TestPromptAlertBuilder()
    } else if (name == "TestPictureLibraryBuilder") {
      TestPictureLibraryBuilder()
    } else if (name == "SafeAreaExample全区实现沉浸式效果") {
      SafeAreaExample1Builder()
    } else if (name == "SafeAreaExample1全区实现沉浸式效果") {
      SafeAreaExample2Builder()
    } else if (name == "SafeArea滚动列表底部延伸场景") {
      SafeAreaExample3Builder()
    } else if (name == "SafeArea重要信息被软键盘遮挡") {
      SafeAreaExample4Builder()
    } else if (name == "SafeArea软键盘弹出导致布局错位") {
      SafeAreaExample5Builder()
    } else if (name == "SafeArea自定义弹窗被键盘顶起") {
      SafeAreaExample6Builder()
    } else if (name == "SafeArea标题组件不避让") {
      SafeAreaExample7Builder()
    }
    else if (name == "测试NodeController") {
      testNodeBuilder()
    } else if (name == "测试Node扩展弹窗") {
      testNodeExtendBuilder()
    }
    else if (name == "Scroller嵌套Scroller") {
      TestScrollTwoGestureBuilder()
    } else if (name == "Scroller嵌套Web") {
      TestScrollWebGestureBuilder()
    } else if (name == "测试滑动指示器") {
      TestIndicatorBuilder()
    } else if (name == "push弹窗测试+移动cell") {
      TestAlertViewBuilder()
    } else if (name == "listItem上下移动") {
      TestListItemMoveBuilder()
    } else if (name == "listItem拖动移动位置") {
      TestListItemDragMoveBuilder()
    } else if (name == "list two拖拽交换位置") {
      TestListDragViewTwoBuilder()
    }
    else if (name == '解压zip文件') {
      TestZipFileBuilder()
    }
    else if (name == 'list移动交换cell') {
      TestListExchangeBuilder()
    }
    else if (name == 'list、gard拖拽交换位置') {
      TestListDragViewBuilder()
    }
    else if (name == '图形绘制') {
      TestDrawPathPageBuilder()
    } else if (name == 'list横向滚动固定头部') {
      listerScrollMoreBuilder()
    } else if (name == '多层滑动嵌套') {
      scrollWebListBuilder()
    } else if (name == '多层嵌套滑动ScrollWebList') {
      scrollWebListCommentBuilder()
    } else if (name == '渐变色') {
      TestGradientPageBuilder()
    }


    // 这种写法，不写else最后一个跳转进去空白
    // if (name == "bbPreWebView") {
    //
    //   // TestPreWebPageBuilder("https://www.zhihu.com")
    //
    //   TestPreWebPageBuilder("https://developer.huawei.com/consumer/cn/doc/harmonyos-faqs-V5/faqs-app-debugging-14-V5")
    // }
    //
    // if (name == "PreWebViewDemo") {
    //
    //   // TestPreWebBuilder("https://www.baidu.com")
    //   TestPreWebPageBuilder("https://zhuanlan.zhihu.com/p/719287092")
    //
    // }
    // if (name == "aaPreWebView") {
    //
    //   TestPreWebPageBuilder("https://www.baidu.com")
    // }
    //
    // if (name == "WebViewDemo") {
    //
    //   webViewDemoBuilder("aa",new Map)
    // }

  }

  build() {
    Stack() {
      Navigation(this.demoPageNav) {

        Scroll() {
          Column() {
            List({ space: 10 }) {
              ForEach(this.tempGroupList, (subGrou: [], index) => {
                ListItemGroup({ header: this.itemHead("组") }) {
                  this.itemCellView(subGrou)
                }
              })

            }.borderRadius(12)
            .cachedCount(3) //不是懒加载，没用
            .clip(true)
            .sticky(StickyStyle.Header) // 设置吸顶，实现粘性标题效果
          }
          .width('100%')
          .height('100%')
          .padding(12)
          .backgroundColor('fff1f3f5')
        }
        .scrollable(ScrollDirection.Vertical)
        .height('100%')
        .width('100%')
        .edgeEffect(EdgeEffect.Spring)
        .scrollBar(BarState.Off)

        // .margin({top:'15%'})
        // .padding({ top: '15%' })

        // NavigationBar({ title: $r('app.string.empty'), flag: true })

      }
      .width('100%')
      .height('100%')
      // .hideTitleBar(true)
      // .navBarWidth('50%')
      .navDestination(this.navPagesMap)
      // .hideNavBar(this.isFullScreen)
      .mode(this.navigationMode)
      .onAppear(() => {
        hsLog.i(TAG, '--onAppear')
      })
      .onDisAppear(() => {
        hsLog.i(TAG, '--onDisAppear')

      })
      .onAreaChange((oldValue, newValue) => {
        hsLog.i(TAG, `--onAreaChange:${oldValue}  ${newValue}`)

      })
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .alignContent(Alignment.BottomEnd)
    // .backgroundColor(YWResColor.bgBase())
    .backgroundColor(Color.Green)

    // .padding({top:getAvoidPadding(this.avoidAreas).top})
    // .padding({ top:Number(AppStorage.get(YWConstants.kStatusBarHeight)) })

  }
}
