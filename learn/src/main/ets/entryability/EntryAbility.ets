import {
  abilityAccessCtrl,
  AbilityConstant,
  bundleManager,
  Context,
  Permissions,
  UIAbility,
  Want
} from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { display, window } from '@kit.ArkUI';

import distributedKVStore from '@ohos.data.distributedKVStore'
// import KeyStorageManager from '../../../../../modules/common_har/src/main/ets/common/KeyStorageManager'

import { kyStoreManger } from '@learn/common_har'
import { hsLog } from '@learn/logger_har';
import { PreferencesUtil } from '../../../../../modules/common_har/src/main/ets/utils/PreferencesUtil';
import { YWConstants } from '@learn/constants_har';
import { UserInfoModel } from '../pages/accountInfo/model/UserInfoModel';
import { BusinessError } from '@kit.BasicServicesKit';
import { GlobalContext } from '../../../../../modules/common_har/src/main/ets/common/GlobalContext'
import { notificationManager } from '@kit.NotificationKit';
// import { AppUtil } from '@pura/harmony-utils';
// import { DisplayUtil, StrUtil, ToastUtil, DeviceUtil, RandomUtil } from '@pura/harmony-utils';
import { process } from '@kit.ArkTS';
import { BreakpointSystem } from '../../../../../modules/common_har/src/main/ets/common/BreakPointSystem';


const permissions: Array<Permissions> = ['ohos.permission.SYSTEM_FLOAT_WINDOW'];

export  let windowStage_: window.WindowStage;
let sub_windowClass: window.Window;

const TAG = 'EntryAbility'
export default class EntryAbility extends UIAbility {
  //本地页面内部使用LocalStorage保存数据，应用页面间通过AppStorage传递信息，PersistentStorage可以持久化存储数据信息
  //可以放全局，然后每个页面@Entry(localStorage),
  // 也可以在这里传过去，每个页面上先let storage = LocalStorage.GetShared()
  para: Record<string, number> = {
    'PropA': 47
  };
  localStorage: LocalStorage = new LocalStorage(this.para);

  private breakpointSystem: BreakpointSystem = new BreakpointSystem();

  async checkPermissions(permissions: Array<Permissions>): Promise<void> {
    const accessManager = abilityAccessCtrl.createAtManager();
    try {
      const bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;
      const bundleInfo = await bundleManager.getBundleInfoForSelf(bundleFlags);
      const grantStatus = await accessManager.checkAccessToken(bundleInfo.appInfo.accessTokenId, permissions[0]);

      if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        accessManager.requestPermissionsFromUser(this.context, permissions)
      }
    } catch (err) {
      hsLog.e('EntryAbility', 'checkPermissions', `Catch err: ${err}`);
      return;
    }
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hsLog.i(TAG, 'testTag', '%{public}s', 'Ability onCreate');

    // 通过在GlobalContext对象上绑定filesDir，可以实现UIAbility组件与UI之间的数据同步。
    // GlobalContext.getContext().setObject("filesDir", this.context.filesDir);
    // // GlobalContext.getContext().setObject("display", );

    let mainTid = process.tid
    hsLog.d(TAG,`==== 主线程tid: ${mainTid}`)

    //首选项本地数据
    PreferencesUtil.getData(this.context)

    let config:distributedKVStore.KVManagerConfig = {
      bundleName: 'com.example.hmos_learn',
      context: this.context
    }

    kyStoreManger.init(config,'myHMStore')

    // hsLog.i(`=========${YWConstants.screenWidth}`)//1260
    // hsLog.i(`=========${px2vp(display.getDefaultDisplaySync().width)}`)//1260
    //
    // //这个造成上面错误
    let localUseInf = AppStorage.get<UserInfoModel>(YWConstants.kStorageLocalUser)
    if (localUseInf == undefined) {
      localUseInf = new UserInfoModel()
      localUseInf.name = 'occ'
      localUseInf.isVip = true
      localUseInf.vipDesc = '普通会员'
      localUseInf.nickName = '一杯水'
      localUseInf.tel = '13122223333'
      localUseInf.avatar = 'https://www.keaidian.com/uploads/allimg/191208/2019030707555443178.jpg'

      //这里暂时有个现象， AppStorage、PersistentStorage 存的key不一样，对象是同一个，修改一个另一个也修改了
      AppStorage.setOrCreate(YWConstants.kAppStorageStorageLocalUser,localUseInf)
      PersistentStorage.persistProp(YWConstants.kStorageLocalUser,localUseInf);

      let localUseInfTwo = new UserInfoModel()
      localUseInfTwo.name = 'offf'
      localUseInfTwo.isVip = true
      localUseInfTwo.vipDesc = '普通会员'
      localUseInfTwo.nickName = '一杯水'
      localUseInfTwo.tel = '13122223333'
      localUseInfTwo.avatar = 'https://www.keaidian.com/uploads/allimg/191208/2019030707555443178.jpg'
      PersistentStorage.persistProp(YWConstants.kAppStorageStorageLocalThreeUser,localUseInfTwo);


    }

    //权限
    this.checkPermissions(["ohos.permission.CAMERA"]);
    this.remoteNotification()
  }

  onDestroy(): void {
    hsLog.i('testTag', '%{public}s', 'Ability onDestroy');
  }

  async configGlobalContext(windowStage: window.WindowStage) {

    windowStage.getMainWindow((err, data: window.Window) => {
      if (err.code) {
        hsLog.d(err.code + '==== err')

        return
      }
      GlobalContext.getContext().setObject("mainWindow", data);
      // 设置全屏展示，沉浸式
      //data.setWindowLayoutFullScreen(true);
      let sysBarProps = {
        statusBarColor: '#00000000',
        navigationBarColor: '#00000000',
        // 以下两个属性从API Version 8开始支持A03d00/JSAPP
        // statusBarContentColor: '#2B3141',
        // navigationBarContentColor: '#2B3141'
      } as window.SystemBarProperties;
      data.setWindowSystemBarProperties(sysBarProps)
    })

    //获取分辨率, 将获取到的分辨率存放在GlobalContext这个文件中的Map变量中
    GlobalContext.getContext().setObject('display', await display.getDefaultDisplaySync());

  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hsLog.i(TAG, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // AppUtil.init(this.context, windowStage);
    //
    // hsLog.d(AppUtil.getStatusBarHeight() + '')
    //
    // hsLog.d(DisplayUtil.getWidth() + ' util')
    // hsLog.d(DisplayUtil.getHeight() + ' util')

    // 获取屏幕宽高
    let screenWidth = display.getDefaultDisplaySync().width;
    let screenHeight = display.getDefaultDisplaySync().height;
    hsLog.d(screenWidth + '')
    hsLog.d(screenHeight + '')

    // this.configGlobalContext(windowStage)

    // showAlertView(this.context,windowStage)
    //设置全屏
    //this.requestFullScreen(windowStage, this.context)

    windowStage_ = windowStage;
    // 开发者可以在适当的时机，如主窗口上按钮点击事件等，创建子窗口。并不一定需要在onWindowStageCreate调用，这里仅作展示
    //this.showSubWindow();

    this.breakpointSystem.register();

    // windowStage.loadContent('pages/Index', (err) => {
    windowStage.loadContent('pages/Index', this.localStorage, (err) => {

      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }

      // 设置背景色实现沉浸式
      //windowStage.getMainWindowSync().setWindowBackgroundColor('#9F6BF5')

      hsLog.i(TAG, 'testTag', 'Succeeded in loading the content.');
    });

    window.getLastWindow(getContext(this)).then((win) => {
      win.setPreferredOrientation(window.Orientation.AUTO_ROTATION_RESTRICTED)
    })
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hsLog.i(TAG, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');

    // 开发者可以在适当的时机，如子窗口上点击关闭按钮等，销毁子窗口。并不一定需要在onWindowStageDestroy调用，这里仅作展示
    this.destroySubWindow();

    this.breakpointSystem.unregister();

  }

  onForeground(): void {
    // Ability has brought to foreground
    hsLog.i(TAG, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hsLog.i(TAG, 'testTag', '%{public}s', 'Ability onBackground');
  }



  // 实现方案有三种，分别是：
  // setWindowLayoutFullScreen方法实现沉浸式
  // 设置背景色统一实现沉浸式
  // expandSafeArea属性实现沉浸式

  //设置全屏
  private requestFullScreen(windowStage: window.WindowStage, context: Context) {
    //1
    try {
      let windowClass = windowStage.getMainWindowSync()
      let area = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      if (area.topRect.height > 0) {
        // 2.设置导航栏、状态栏不显示。
        windowClass.setWindowSystemBarEnable([], (err) => {

        });
        windowClass.setWindowLayoutFullScreen(true)
      }
    } catch (err) {
      hsLog.d(`requestFullScreen err = ${err}`)
    }

    //2
    // let windowClass: window.Window
    // windowStage.getMainWindow((err, data) => {
    //   // 1.获取应用主窗口
    //   windowClass = data;
    //   // 2.设置导航栏、状态栏不显示。
    //   windowClass.setWindowSystemBarEnable([], (err) => {
    //
    //   });
    //   // 3.设置全屏
    //   windowClass.setWindowLayoutFullScreen(true).then(() => {
    //
    //   })
    //   // 4.获取底部导航栏高度，此时的高度单位是px
    //   let navigationHeight = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).bottomRect.height
    //   PersistentStorage.persistProp("navigationHeight",navigationHeight)
    //   windowStage.loadContent('pages/Index', (err, data) => {
    //
    //   });
    // })

  }


  async remoteNotification() {
    // 请求用户推送权限
    notificationManager.isNotificationEnabled().then((data: boolean) => {
      hsLog.i("isNotificationEnabled success, data: " + JSON.stringify(data));
      if (!data) {
        notificationManager.requestEnableNotification().then(async () => {
          hsLog.i(`[ANS] requestEnableNotification success`)
        }).catch(() => {

        })
      }
    }).catch(() => {

    })
  }

  showSubWindow() {
    // 1.创建应用子窗口。
    windowStage_.createSubWindow("mySubWindow", (err, data) => {
      if (err.code) {
        hsLog.e('Failed to create the subwindow. Cause: ' + JSON.stringify(err));
        return;
      }
      sub_windowClass = data;
      hsLog.i('Succeeded in creating the subwindow. Data: ' + JSON.stringify(data));
      // 2.子窗口创建成功后，设置子窗口的位置、大小及相关属性等。
      sub_windowClass.moveWindowTo(300, 300, (err) => {
        if (err.code) {
          hsLog.e('Failed to move the window. Cause:' + JSON.stringify(err));
          return;
        }
        hsLog.i('Succeeded in moving the window.');
      });
      sub_windowClass.resize(500, 500, (err) => {
        if (err.code) {
          hsLog.e('Failed to change the window size. Cause:' + JSON.stringify(err));
          return;
        }
        hsLog.i('Succeeded in changing the window size.');
      });
      // 3.为子窗口加载对应的目标页面。
      sub_windowClass.setUIContent("pages/page3", (err) => {
        if (err.code) {
          hsLog.e('Failed to load the content. Cause:' + JSON.stringify(err));
          return;
        }
        hsLog.i('Succeeded in loading the content.');
        // 3.显示子窗口。
        sub_windowClass.showWindow((err) => {
          if (err.code) {
            hsLog.e('Failed to show the window. Cause: ' + JSON.stringify(err));
            return;
          }
          hsLog.i('Succeeded in showing the window.');
        });
      });
    })
  }

  destroySubWindow() {
    // 4.销毁子窗口。当不再需要子窗口时，可根据具体实现逻辑，使用destroy对其进行销毁。
    sub_windowClass.destroyWindow((err) => {
      if (err.code) {
        hsLog.e('Failed to destroy the window. Cause: ' + JSON.stringify(err));
        return;
      }
      hsLog.i('Succeeded in destroying the window.');
    });
  }
}

async function checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
  let atManager = abilityAccessCtrl.createAtManager();
  let grantStatus: abilityAccessCtrl.GrantStatus;

  // 获取应用程序的accessTokenID
  let tokenId: number;
  try {
    let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
  } catch (err) {
    hsLog.e(`getBundleInfoForSelf failed, code is ${err.code}, message is ${err.message}`);
    return abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
  }

  // 校验应用是否被授予权限
  try {
    grantStatus = await atManager.checkAccessToken(tokenId, permission);
  } catch (err) {
    hsLog.e(`checkAccessToken failed, code is ${err.code}, message is ${err.message}`);
    return abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
  }
  return grantStatus
}

async function checkPermissions(): Promise<boolean> {
  const permissions: Array<Permissions> = ['ohos.permission.SYSTEM_FLOAT_WINDOW'];
  let grantStatus: abilityAccessCtrl.GrantStatus = await checkAccessToken(permissions[0]);

  if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
    // 已经授权，可以继续访问目标操作
    hsLog.i('已授权')
    return true
  } else {
    // 申请权限
    hsLog.i('没有授权')
    return false
  }
}


function showAlertView(context: Context, windowStage: window.WindowStage) {

  let atManager = abilityAccessCtrl.createAtManager();

  checkPermissions().then((result) => {
    if (result) {
      // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
      atManager.requestPermissionsFromUser(context, permissions).then((data) => {
        let grantStatus: Array<number> = data.authResults;
        let length: number = grantStatus.length;

        for (let i = 0; i < length; i++) {
          if (grantStatus[i] === 0) {
            // 用户授权，可以继续访问目标操作
            hsLog.d('用户授权，可以继续访问目标操作')
          } else {
            // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
            hsLog.d('用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限')
            return;
          }
        }

        // 授权成功
        // 1.创建悬浮窗。
        let windowClass: window.Window
        // let config = {name: "floatWindow", windowType: window.WindowType.TYPE_FLOAT, ctx: context};
        window.createWindow({
          name: "floatWindow",
          windowType: window.WindowType.TYPE_FLOAT,
          ctx: context
        }, (err, data) => {
          if (err.code) {
            hsLog.e('Failed to create the floatWindow. Cause: ' + JSON.stringify(err));
            return;
          }
          hsLog.i('Succeeded in creating the floatWindow. Data: ' + JSON.stringify(data));
          windowClass = data;

          // 2.悬浮窗窗口创建成功后，设置悬浮窗的位置、大小及相关属性等。
          windowClass.moveWindowTo(0, 200, (err) => {
            if (err.code) {
              hsLog.e('Failed to move the window. Cause:' + JSON.stringify(err));
              return;
            }
            hsLog.i('Succeeded in moving the window.');
          });
          windowClass.resize(1080, 151, (err) => {
            if (err.code) {
              hsLog.e('Failed to change the window size. Cause:' + JSON.stringify(err));
              return;
            }
            hsLog.i('Succeeded in changing the window size.');

          });

          // 3.为悬浮窗加载对应的目标页面。
          windowClass.setUIContent("pages/Index", (err) => {
            if (err.code) {
              hsLog.e('Failed to load the content. Cause:' + JSON.stringify(err));
              return;
            }
            hsLog.i('Succeeded in loading the content.');
            // 3.显示悬浮窗。
            windowClass.showWindow((err) => {
              if (err.code) {
                hsLog.e('Failed to show the window. Cause: ' + JSON.stringify(err));
                return;
              }
              hsLog.i('Succeeded in showing the window.');
            });

            try {
              windowClass.setWindowBackgroundColor('#00000000')
            } catch (exception) {
              hsLog.e('Failed to set the background color. Cause: ' + JSON.stringify(exception));
            }

            // 4.销毁悬浮窗。当不再需要悬浮窗时，可根据具体实现逻辑，使用destroy对其进行销毁。
            // windowClass.destroyWindow((err) => {
            //   if (err.code) {
            //     hsLog.e('Failed to destroy the window. Cause: ' + JSON.stringify(err));
            //     return;
            //   }
            //   hsLog.i('Succeeded in destroying the window.');
            // });

          });

        })

      }).catch((err: BusinessError) => {
        hsLog.e(`requestPermissionsFromUser failed, code is ${err.code}, message is ${err.message}`);
      })

    }
  })

}

