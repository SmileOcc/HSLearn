import { NavigationBar } from '../../common/NavigationBar'
import SetItemModel from './model/SetItemModel'
import { router, window } from '@kit.ArkUI'
import { Want } from '@kit.AbilityKit'
import common from '@ohos.app.ability.common';
import RouterUtils from '../../../../../../modules/common_har/src/main/ets/utils/RouterUtils'
import { hsLog } from '@learn/logger_har';import { PreferencesUtil } from '../../../../../../modules/common_har/src/main/ets/utils/PreferencesUtil'
import { PhoneLayoutFactor, TabletLayoutFactor, TestLayoutFactory } from '../base/TestLayoutFactory'
// import { DisplayUtil } from '@pura/harmony-utils'
// import { CacheUtil, OutDTO, IdCardUtil, ToastUtil, ActionUtil, DialogUtil,LoadingUtil} from '@yunkss/eftool'
import { rcp } from "@kit.RemoteCommunicationKit";
import { TigerOpenApi, TigerOpenImp } from '@learn/tiger_har/Index'
import { ENU_PREFS, hsGlobalThis, YWNavRouterUtils } from '@learn/common_har'
import dataPreferences from '@ohos.data.preferences';
import { BusinessError } from '@kit.BasicServicesKit'
import { YWConstants } from '@learn/constants_har'
import { YWTaskPoolUtils } from '@learn/taskpool_har';
import { taskpool } from '@kit.ArkTS';
import { CatOpenImp } from '@learn/cat_har';

//导入har库
import('STHarLib')


interface UserInfoInterface {
  username: string,
  age: number,
  sex: string
}


export let resolvePromise2:((value:void | Promise<void>)=>void)

export  const testPromise2:Promise<void> = new Promise<void>((resolve)=>{
  resolvePromise2 = resolve
})

export let resolvePromise:((value:string | Promise<string>)=>void)

export  const testPromise:Promise<string> = new Promise<string>((resolve)=>{
  resolvePromise = resolve
})

const TAG = 'SettingPage'

export const RootSettingBuilder = wrapBuilder(settingBuilder)

@Builder function settingBuilder(name:string, params:Map<string,Object>){
  NavDestination(){
    SettingPage()
  }
  .hideTitleBar(true)
}
@Entry
@Component
export struct SettingPage {
  private context = getContext(this) as common.UIAbilityContext
  @State tempGroupList: SetItemModel[][] = new Array
  @State allGroupList: SetItemModel[] = new Array
  @State showLoading: boolean = false
  private contactsGroups: UserInfoInterface[] = []

  private tigerOpenApi:TigerOpenApi =  new TigerOpenImp()

  onPageShow() {
    //全局数据获取
    const KEY_APP_PRIVACY = 'nutsusKey';

    let kkk22 = AppStorage.get("aaa") as string
    let kkk2233 = AppStorage.get("isLoginGG") as string


    let author = hsGlobalThis.getAttribute("author");
    let org = hsGlobalThis.getAttribute("org");

    let context: common.UIAbilityContext | undefined = globalThis.getMainAbilityContext();
    if (context != undefined) {
      let label = context.abilityInfo.bundleName;
    }

    let preferences: Promise<dataPreferences.Preferences> | undefined = globalThis.getPref(ENU_PREFS.Global)
    if (preferences != undefined) {
      preferences.then((result: dataPreferences.Preferences) => {
        result.get(KEY_APP_PRIVACY, "").then((data) => {
          let message = String(data);
        })
      }).catch((err: BusinessError) => {
        console.error('xx get the preferences failed, err: ' + err);
      })
    }
  }

  async testBBB() {

    hsLog.i(TAG,'====taskPool 1')


    //这个有问题
    taskpool.Task.sendData("action","aaa",true)
    hsLog.i(TAG,'====taskPool 2')

  }

  async testAAA() {

    testPromise.then((value)=>{
      hsLog.i(TAG,'====testPromise 2')
    })
    setTimeout(()=>{
      hsLog.i(TAG,'====testPromise 1')
      resolvePromise("xxx")
    }, 3000)


    let taskk = new taskpool.Task(this.testBBB)
    taskk.onReceiveData((action:string,arg1:string,arg2:boolean) =>{
      hsLog.i(TAG,'====taskPool 3')

    })
    YWTaskPoolUtils.serialRun(taskk)
    hsLog.i(TAG,'====taskPool 4')

  }
  aboutToAppear(): void {

    this.testAAA()

    // hsLog.d(DisplayUtil.getWidth() +' util11')//1260 util11
    // hsLog.d(DisplayUtil.getHeight() +' util11')//2720 util11


    // window.getLastWindow(this.context).then((windowClass) => {
    //   windowClass.setWindowSystemBarEnable(["status", "navigation"]).then(() => {
    //   })
    // })
    let isPhone = true
    let factory:TestLayoutFactory = isPhone ? new PhoneLayoutFactor() : new TabletLayoutFactor()

    factory.testEvent()


    let usetInfo = PreferencesUtil.getInstance().mUserInfo
    hsLog.d(JSON.stringify(usetInfo))
    hsLog.d('====mmmmm')

    let userinfo: UserInfoInterface = {
      username: "张三",
      age: 20,
      sex: "男"
    }

    this.contactsGroups.push(userinfo)

    let list: String[] = Array(5).fill(Math.random().toString().slice(2, 2 + 4))
    let gropList: String[][] = [
      ["基础数据","自定义tab","相对布局Relative","横竖屏旋转","测试NavDestination","测试弹窗WrapBuilder"],
      ["请求调试", "数据库DBUtils", "分布式键值数据库distributedKVStore","首选项PreferencesUtil","共享LocalStoragePage", "LocalStorageAppStoragePage", "调试preferences", "调试Axios请求"],
      ["docAbility-specified",
        "savedAbility-docAbility-multition",
        "TestHarPage 通过routerName跳转",
        "TestHarTwoPg 通过routerName跳转",
        "Share_Har 页面跳转",
        "网页打开",
        "浏览器打开",
        "登录页",
        "登录注册页1","登录注册页2"],
      ["录音转文字"],
      ["TaskPoolPage", "TaskPoolCpuPage", "TaskPoolSyncTaskPage","worker Test", "其他"],
      ["消息列表 MessageListPage","list分组红点","scroll集合","自动缩放适配","layoutWeight","PullRefreshPage","PullRefreshLazyPage","PullRefreshListPage","SwiperStackPage","TopSlideMenuTestPage"],
      ["图片相册PhotoCameraPage", "保存图片相册","图片上传", "window悬浮弹窗", "buildParams Page","ProvideConsumPage祖孙","showLoading全局"],
      ["Emitter组件间的通信和数据传递", "通知NotificationPage"],
      ["文件路径FilePagePage"],
      ["MarginPaddingPage"],
      ["设备硬件信息：HardwareInfoPage"],
      ["支付首页全适配：PaymentHomePage"],
      ["tiger_har_app","cat_har_app"],

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
            url:'pages/base/TestDataHandlePage',
            params:{}
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
          router.pushUrl({ url: '@bundle:com.example.hmos_learn/ShareHarLibs/src/main/ets/pages/HWSuccessPage' })

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

        if (subModel.title.startsWith('网页打开')){
          RouterUtils.openWeb('https://www.baidu.com')
        }

        if (subModel.title.startsWith('浏览器')) {
          RouterUtils.openBrowser(this.context,'https://www.baidu.com')
        }

        // if (subModel.title.includes('登录注册页1')) {
        if (subModel.title.startsWith('登录注册页1')) {
          RouterUtils.jumpRouter('pages/base/registerlogin/LoginPageOne')
          return
        }
        if (subModel.title.startsWith('"登录注册页2"')) {

        }

        if (subModel.title.startsWith('登录')) {
          RouterUtils.openLogin().then(()=> {
            hsLog.d('进入登录页')
          })
            .catch(()=> {

            })
        }

        if (subModel.title.startsWith('Emitter组件间的通信和数据传递')) {
          RouterUtils.jumpRouter('pages/base/EmitterBasePage')
        }

        if (subModel.title.startsWith('首选项PreferencesUtil')) {
          console.info('====当前内存信息 1 ',JSON.stringify(PreferencesUtil.getInstance()))
          PreferencesUtil.getInstance().mUserInfo.userToken = "测试测试"
          PreferencesUtil.saveData(this.context)
          console.info('====当前内存信息 2 ',JSON.stringify(PreferencesUtil.getInstance()))

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

        if (subModel.title.startsWith('showLoading')){
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

          this.tigerOpenApi.openTigerApp("tiger_id","123")
        }
        if (subModel.title.startsWith('cat_har_app')) {
          const catApi = new CatOpenImp()
          catApi.openCatApp("cat_id","123")

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

        if (subModel.title.includes('测试NavDestination')) {
          RouterUtils.jumpRouter('pages/base/navtest/TestNavigationDestionationPage')
        }

        if (subModel.title.includes('测试弹窗WrapBuilder')) {
          RouterUtils.jumpRouter('pages/base/wrapbuilder/dialog/TestWrapBuilderDialog')
        }
      })

    })

  }

  build() {

    Stack({ alignContent: Alignment.TopEnd }) {
      Scroll() {
        Column() {
          List({ space: 10 }) {
            // ForEach(this.tempGroupList, (subGrou: [], index) => {
            //   ListItemGroup({ header: this.itemHead("组") }) {
            //     this.itemCellView(subGrou)
            //   }
            // })

            Repeat<SetItemModel[]>(this.tempGroupList)
              .each((res: RepeatItem<SetItemModel[]>)=>{

                  ListItemGroup({ header: this.itemHead("组") }) {
                    this.itemCellView(res.item)
                  }
              })
              .key((item: SetItemModel[]) => "innerList_" + item.toString())

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
      .padding({ top: '15%' })

      NavigationBar({ title: $r('app.string.empty'), flag: true })

      // LoadingUtil({
      //   options: { show: this.showLoading, alignment: DialogAlignment.Top, content: '更改了加载提示...' }
      // });

      // LoadingUtil({
      //   options: { show: this.showLoading, alignment: DialogAlignment.Center}
      // });
    }
    .backgroundColor(YWConstants.COLOR_PAGE_BGC)

  }
}