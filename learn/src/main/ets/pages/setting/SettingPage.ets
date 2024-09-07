import { NavigationBar } from '../../common/NavigationBar'
import SetItemModel from './model/SetItemModel'
import { router, window } from '@kit.ArkUI'
import { Constants } from '../../../../../../modules/common_har/src/main/ets/common/Constants'
import { Want } from '@kit.AbilityKit'
import common from '@ohos.app.ability.common';
import RouterUtils from '../../../../../../modules/common_har/src/main/ets/utils/RouterUtils'
import Logger from '../../../../../../modules/common_har/src/main/ets/common/KLogger'
import { PreferencesUtil } from '../../../../../../modules/common_har/src/main/ets/utils/PreferencesUtil'
import { PhoneLayoutFactor, TabletLayoutFactor, TestLayoutFactory } from '../base/TestLayoutFactory'
// import { DisplayUtil } from '@pura/harmony-utils'
// import { CacheUtil, OutDTO, IdCardUtil, ToastUtil, ActionUtil, DialogUtil,LoadingUtil} from '@yunkss/eftool'

import { rcp } from "@kit.RemoteCommunicationKit";
import { TigerOpenApi, TigerOpenImp } from '@learn/tiger_har/Index'
import { GlobalThis } from '@learn/common_har/Index'
import dataPreferences from '@ohos.data.preferences';
import { BusinessError } from '@kit.BasicServicesKit'

//导入har库
import('STHarLib')


interface UserInfoInterface {
  username: string,
  age: number,
  sex: string
}

@Entry
@Component
struct SettingPage {
  private context = getContext(this) as common.UIAbilityContext
  @State title: string = globalThis?.key
  @State tempGroupList: SetItemModel[][] = new Array
  @State allGroupList: SetItemModel[] = new Array
  @State showLoading: boolean = false
  private contactsGroups: UserInfoInterface[] = []

  private tigerOpenApi:TigerOpenApi =  new TigerOpenImp()

  onPageShow() {
    //全局数据获取
    const KEY_APP_PRIVACY = 'nutsusKey';

    let author = GlobalThis.getInstance().getAttribute("author");
    let org = GlobalThis.getInstance().getAttribute("org");

    let context: common.UIAbilityContext | undefined = GlobalThis.getInstance().getContext("context");
    if (context != undefined) {
      let label = context.abilityInfo.bundleName;
    }

    let preferences: Promise<dataPreferences.Preferences> | undefined = GlobalThis.getInstance().getPreferences("preferences")
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
  aboutToAppear(): void {

    // Logger.debug(DisplayUtil.getWidth() +' util11')//1260 util11
    // Logger.debug(DisplayUtil.getHeight() +' util11')//2720 util11

    let twww = Constants.SCREEN_WIDTH() //387.6923076923077 loc
    let thhhh = Constants.SCREEN_HEIGHT() //836.9230769230769 loc

    Logger.debug(twww +' loc')
    Logger.debug(thhhh +' loc')

    // window.getLastWindow(this.context).then((windowClass) => {
    //   windowClass.setWindowSystemBarEnable(["status", "navigation"]).then(() => {
    //   })
    // })
    let isPhone = true
    let factory:TestLayoutFactory = isPhone ? new PhoneLayoutFactor() : new TabletLayoutFactor()

    factory.testEvent()


    let usetInfo = PreferencesUtil.getInstance().mUserInfo
    Logger.debug(JSON.stringify(usetInfo))
    Logger.debug('====mmmmm')

    let userinfo: UserInfoInterface = {
      username: "张三",
      age: 20,
      sex: "男"
    }

    this.contactsGroups.push(userinfo)

    let list: String[] = Array(5).fill(Math.random().toString().slice(2, 2 + 4))
    let gropList: String[][] = [
      ["请求调试", "数据库DBUtils", "分布式键值数据库distributedKVStore","首选项PreferencesUtil","共享LocalStoragePage", "LocalStorageAppStoragePage", "调试preferences", "调试Axios请求"],
      ["docAbility-specified", "savedAbility-docAbility-multition",
        "TestHarPage 通过routerName跳转", "TestHarTwoPg 通过routerName跳转","Share_Har 页面跳转", "网页打开","浏览器打开", "登录页"],
      ["TaskPoolPage", "TaskPoolCpuPage", "TaskPoolSyncTaskPage","worker Test", "其他"],
      ["消息列表 MessageListPage","scroll集合","layoutWeight","PullRefreshPage","PullRefreshLazyPage","PullRefreshListPage","SwiperStackPage","TopSlideMenuTestPage"],
      ["图片相册PhotoCameraPage", "保存图片相册", "window悬浮弹窗", "buildParams Page","ProvideConsumPage祖孙","showLoading全局"],
      ["Emitter组件间的通信和数据传递", "通知NotificationPage"],
      ["文件路径FilePagePage"],
      ["MarginPaddingPage"],
      ["设备硬件信息：HardwareInfoPage"],
      ["支付首页全适配：PaymentHomePage"],
      ["tiger_har_app"],

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

        if (subModel.title.startsWith('登录')) {
          RouterUtils.openLogin().then(()=> {
            Logger.debug('进入登录页')
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

      })

    })

  }

  build() {

    Stack({ alignContent: Alignment.TopEnd }) {
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
      .padding({ top: '15%' })

      NavigationBar({ title: $r('app.string.empty'), flag: true })

      // LoadingUtil({
      //   options: { show: this.showLoading, alignment: DialogAlignment.Top, content: '更改了加载提示...' }
      // });

      // LoadingUtil({
      //   options: { show: this.showLoading, alignment: DialogAlignment.Center}
      // });
    }
    .backgroundColor(Constants.COLOR_PAGE_BGC)

  }
}