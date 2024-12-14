import router from '@ohos.router'
import { Size } from '@ohos/hypium';
import Curves from '@ohos.curves'
import { window } from '@kit.ArkUI';

import { HWAlertView, CreateAlertMsgView, HWConstants, TEST_WIDTH, TEST_HEIGHT, HWTTLogger } from 'STHarLib'

import { HWSuccessPage, ShareTipView, ShareResManager } from 'ShareHarLibs'

import { StorageUtils, StorageKeys } from '../../../../../modules/common_har/src/main/ets/utils/PreferenceStorageUtils'

import { KSManager } from '../entryability/EntryAbility'
import { BusinessError } from '@kit.BasicServicesKit';

import { HMItemInfo } from '../pages/login/model/HMItemInfo'
import QDImageCompressionUtils from '../../../../../modules/common_har/src/main/ets/utils/QDImageCompressionUtils';
import { preferences } from '@kit.ArkData';
import { UserInfoManager } from '../model/UserInfoManager';
import KLogger from '../../../../../modules/common_har/src/main/ets/common/KLogger';

const TAG: string = '[AccountInfo]'

// import {ffff} from '@ohos.data.preferences'
enum omger {
  gred = 111,
  rom = 222
}

let kkkaid:Record<string,string> = {'a':'b','d':'y'}

//元组
let min: [string, number]
min = ["哈喽", 111]
// min = [111,"哈喽"]  错误

let options = {
  name: 'myPage',
  params: { url: "123456" }
} as router.NamedRouterOptions;


enum Gender {
  nan = 1,
  nv = 0
}

@Entry
@Component
export struct Account {
  @State message: string = 'Hello Mine';
  scroller: Scroller = new Scroller()
  tttLogger = new HWTTLogger()
  eventBlock: ((item: HMItemInfo) => void) | undefined

  aboutToAppear(): void {

    let kkk = UserInfoManager.getInstance()

    this.getWindowProperties()

    // preferences.deletePreferences()

    let score: number | string = 'A'
    console.log(`=======score:${score}`) // 98

    StorageUtils.put(StorageKeys.USER_LOGIN, true)
    StorageUtils.put(StorageKeys.USER_INFO_KEY, "user_info_key001")

    setTimeout(() => {
      StorageUtils.get(StorageKeys.USER_INFO_KEY).then((result) => {
        //showToast(result.toString())
        console.debug(`===== ${result}`)
      })


    }, 3000)

    let isLogin = this.getUserLogin

    KSManager.putData("ksKey_name", "{\"msg\":\"success\",\"code\":200}")

    setTimeout(() => {
      KSManager.getData<string>("ksKey_name").then((value:string) => {
        console.debug(`===== ${value}`)

      }).catch((err: BusinessError) => {

      })



    }, 3000)

    // 重复执行内容，可设置时间延迟间隔（执行多次）
    // let intervalID = setInterval(() => {
    //   console.log('do after 2s delay.')
    //
    // }, 2000)
    // clearInterval(intervalID)  // 手动取消定时器
  }

  async getUserLogin() {
    let hasLogin = await StorageUtils.get(StorageKeys.USER_LOGIN, false)
    console.debug(`===== ${hasLogin}`)
    return hasLogin
    //LogUtils.debug('网络请求Request 登录状态校验>>>', `${hasLogin.toString()}`);
  }

  async getWindowProperties() {

    let windowClass = await window.getLastWindow(getContext());

    // 获取窗口属性

    let properties = windowClass.getWindowProperties();

    // 获取窗口宽高

    console.log("width: " + properties.windowRect.width);

    console.log("height: " + properties.windowRect.height);

  }

  @Builder
  headerView() {
    Column() {
      Row() {
        Button('登录', { type: ButtonType.Normal, buttonStyle: ButtonStyleMode.NORMAL })
          .height(30)
          .fontSize(14)
          .buttonStyle(ButtonStyleMode.NORMAL)
          .onClick(() => {
            // router.pushUrl({ url: 'pages/login/LoginPage' })

            QDImageCompressionUtils.getPhoto((str)=>{})

          })
        Button('消息', { type: ButtonType.Normal })
          .height(30)
          .height(46)
          .fontSize(14)
          .buttonStyle(ButtonStyleMode.NORMAL)
          .onClick(() => {
            router.pushUrl({ url: 'pages/message/MessageListPage' })
          })
        Button('设置', { type: ButtonType.Normal, buttonStyle: ButtonStyleMode.NORMAL })
          .height(30)
          .height(46)
          .fontSize(14)
          .buttonStyle(ButtonStyleMode.NORMAL)
          .onClick(() => {
            router.pushUrl({ url: 'pages/setting/SettingPage' })
          })
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
      .height(46)
      .backgroundColor(Color.Orange)

      Row() {
        Row() {
          Image($r('app.media.right_head'))// .margin(2)
            .width(64)
            .height(64)
            .objectFit(ImageFit.Fill)
            .backgroundColor(Color.Red)
            .borderRadius(32)
            .borderColor(Color.Yellow)
            .borderWidth(1)
            .clip(true)

          Blank().width(8)
          Column({ space: 5 }) {

            Text('一鸣1')
              // .textAlign(TextAlign.Start)
              .fontSize(18)
              .fontColor(Color.Red)
            Text('介绍描述介012 描述介012 描述介012 描述介012 描述介012')
              // .textAlign(TextAlign.Start)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(2)
              .fontSize(14)
              // .padding({left:8,right:8})


            // .lineHeight(18)
          }
          .width('70%')
          .backgroundColor(Color.Gray)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Start)
          // .padding({left:8,right:8})

        }
        .layoutWeight(7)
        .justifyContent(FlexAlign.Start)


        Row() {
          Text('个人主页')
            .textAlign(TextAlign.Center)
          Image($r('app.media.right'))
            .width('12vp')
            .height('12vp')
            .margin({left:4})
            // .objectFit(ImageFit.Cover)

        }
        .layoutWeight(3)
        .backgroundColor(0xF5DEB3)
        .height('100%')
        .justifyContent(FlexAlign.End)
      }
      .width('100%')
      .height(64)
      .backgroundColor(Color.Gray)

      Blank()
        .height(12)
      Row() {

      }
      .height(120)
      .backgroundColor(Color.Pink)
      .alignItems(VerticalAlign.Center)
    }
  }

  build() {
    // Stack({ alignContent: Alignment.TopStart }) {
    Scroll(this.scroller) {
      Column({ space: 12 }) {
        this.headerView()

        Text(this.message)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .height(60)

        Button('Scroller')
          .width('70%')
          .height(44)
          .fontSize(20)
          .fontColor(Color.Red)
          .type(ButtonType.Capsule)
          .onClick(() => {
            console.log("====tap test")
            router.pushUrl({ url: 'pages/accountInfo/ScrollListPage' })
          })

        Button('Column/Row01')
          .width('70%')
          .height(44)
          .fontSize(20)
          .fontColor(Color.Red)
          .type(ButtonType.Capsule)
          .onClick(() => {
            console.log("====tap test")
            router.pushUrl({ url: 'pages/columnRowShow/layoutWeightPage' })
          })

        Button('Column/Row02')
          .width('70%')
          .height(44)
          .fontSize(20)
          .fontColor(Color.Red)
          .type(ButtonType.Capsule)
          .onClick(() => {
            console.log("====tap test")
            router.pushUrl({ url: 'pages/columnRowShow/layoutPercentWidthPage' })
          })

        Button($r('app.string.title_record'))
          .id('accountBt')
          .margin(10)
          .width('60%')
          .fontSize(20)
          .fontColor(Color.Blue)
          .onClick(() => {
            AlertDialog.show(
              {
                title: 'title===',
                message: '===msg====',
                primaryButton: {
                  value: 'confirm',
                  action: () => {
                    router.replaceUrl({
                      url: 'pages/Home'
                    })
                  }
                },
                secondaryButton: {
                  value: 'cancel',
                  action: () => {
                    KLogger.info(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  KLogger.info(TAG, `AlertDialog close`)
                }
              })
          })

        //这样有问题
        // HWAlertView.CreateAlert("ddd",null)

        CreateAlertMsgView("create", () => {
          this.tttLogger.debug("==== msg")
          console.log("=====odd")

        })

        Button("share har module 页面")
          .id('accountBt')
          .margin(10)
          .fontSize(20)
          .fontColor(Color.Blue)
          .onClick(() => {
            console.debug("======= share page 听说 测试版 这个还没有授权")
            //'@bundle:包名（bundleName）/模块名（moduleName）/路径/页面所在的文件名(不加.ets后缀)'
            router.pushUrl({ url: '@bundle:com.example.hmos_learn/ShareHarLibs/src/main/ets/pages/HWSuccessPage' })
          })

        ShareTipView()
        Text("nnnnnn")
      }

      .width('90%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)

    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Auto)
    .scrollBarColor(Color.Red)
    .scrollBarWidth(10)
    .edgeEffect(EdgeEffect.Spring)
    .padding({ bottom: 50 })
    .onScrollStart(() => {
      //console.log("滚动==开始")
    })
    .onScroll((a, b) => {
      //console.log(`滚动===${a} : ${b}`)
    })
    .onScrollStop(() => {
      //console.log("滚动==结束")

    })
    .onScrollEdge((edg) => {
      //滚动到边缘事件回调
      console.log(edg.toString())
    })
    .height('100%')
    .backgroundColor(Color.Yellow)
  }

  // }


}