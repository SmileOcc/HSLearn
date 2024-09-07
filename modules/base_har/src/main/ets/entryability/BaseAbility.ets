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
import { process } from '@kit.ArkTS';

import { BreakpointSystem, Constants,
  GlobalContext,
  KeyStorageManager, KLogger, PreferencesUtil,
  YWAppUtils } from '@learn/common_har'
// import KLogger from '@learn/common_har/src/main/ets/common/KLogger';

import { distributedKVStore } from '@kit.ArkData';
import { display, window } from '@kit.ArkUI';
// import { AppUtil, DisplayUtil } from '@pura/harmony-utils';
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';


const permissions: Array<Permissions> = ['ohos.permission.SYSTEM_FLOAT_WINDOW'];

abstract  class BaseAbility extends UIAbility {
  //本地页面内部使用LocalStorage保存数据，应用页面间通过AppStorage传递信息，PersistentStorage可以持久化存储数据信息
  //可以放全局，然后每个页面@Entry(localStorage),
  // 也可以在这里传过去，每个页面上先let storage = LocalStorage.GetShared()
  para: Record<string, number> = {
    'PropA': 47
  };
  localStorage: LocalStorage = new LocalStorage(this.para);

  private breakpointSystem: BreakpointSystem = new BreakpointSystem();



  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    // 通过在GlobalContext对象上绑定filesDir，可以实现UIAbility组件与UI之间的数据同步。
    // GlobalContext.getContext().setObject("filesDir", this.context.filesDir);
    // // GlobalContext.getContext().setObject("display", );

    let mainTid = process.tid
    KLogger.debug(`==== 主线程tid: ${mainTid}`)

    //首选项本地数据
    PreferencesUtil.getData(this.context)

    let config:distributedKVStore.KVManagerConfig = {
      bundleName: 'com.example.hmos_learn',
      context: this.context
    }

    const KSManager = new KeyStorageManager(config,'myHMStore')

    //权限
    this.checkPermissions(["ohos.permission.CAMERA"]);
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async configGlobalContext(windowStage: window.WindowStage) {

    windowStage.getMainWindow((err, data: window.Window) => {
      if (err.code) {
        KLogger.debug(err.code + '==== err')

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
      // 获取状态栏高度
      let avoidArea = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      KLogger.info("statusBarHeight===", avoidArea.topRect.height.toString())

      let isFullScreen = data.getWindowProperties().isFullScreen
      //获取不对
      let screen_w = data.getWindowProperties().windowRect.width
      let screen_h = data.getWindowProperties().windowRect.height

      KLogger.debug(screen_w + '====')
      KLogger.debug(screen_h + '====')

      KLogger.debug('===== aaaaa')
      AppStorage.setOrCreate<number>(Constants.kStatusBarHeight, px2vp(avoidArea.topRect.height))
      GlobalContext.getContext().setObject(Constants.kStatusBarHeight, px2vp(avoidArea.topRect.height))
    })

    //获取分辨率, 将获取到的分辨率存放在GlobalContext这个文件中的Map变量中
    GlobalContext.getContext().setObject('display', await display.getDefaultDisplaySync());

  }

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
      console.error('EntryAbility', 'checkPermissions', `Catch err: ${err}`);
      return;
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {

    YWAppUtils.init(this.context,windowStage)

    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // AppUtil.init(this.context, windowStage);
    //
    // KLogger.debug(AppUtil.getStatusBarHeight() + '')
    //
    // KLogger.debug(DisplayUtil.getWidth() + ' util')
    // KLogger.debug(DisplayUtil.getHeight() + ' util')

    // 获取屏幕宽高
    let screenWidth = display.getDefaultDisplaySync().width;
    let screenHeight = display.getDefaultDisplaySync().height;
    KLogger.debug(screenWidth + '')
    KLogger.debug(screenHeight + '')

    // this.configGlobalContext(windowStage)

    // showAlertView(this.context,windowStage)
    //设置全屏
    //this.requestFullScreen(windowStage, this.context)
    // YWAppUtils.setStatusBar(true,true,"")

    // 开发者可以在适当的时机，如主窗口上按钮点击事件等，创建子窗口。并不一定需要在onWindowStageCreate调用，这里仅作展示
    //this.showSubWindow();


    this.breakpointSystem.register();

    this.loadContent(windowStage)



  }

  protected loadContent(windowStage: window.WindowStage):void {
    // windowStage.loadContent('pages/Index', (err) => {
    windowStage.loadContent(this.initRootPage(), this.localStorage, (err) => {

      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }

      // 设置背景色实现沉浸式
      //windowStage.getMainWindowSync().setWindowBackgroundColor('#9F6BF5')

      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');

    // 开发者可以在适当的时机，如子窗口上点击关闭按钮等，销毁子窗口。并不一定需要在onWindowStageDestroy调用，这里仅作展示
    // this.destroySubWindow();

    this.breakpointSystem.unregister();

  }


  abstract initRootPage():string

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
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
      KLogger.debug(`requestFullScreen err = ${err}`)
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



}

export {BaseAbility}

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
    console.error(`getBundleInfoForSelf failed, code is ${err.code}, message is ${err.message}`);
    return abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
  }

  // 校验应用是否被授予权限
  try {
    grantStatus = await atManager.checkAccessToken(tokenId, permission);
  } catch (err) {
    console.error(`checkAccessToken failed, code is ${err.code}, message is ${err.message}`);
    return abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
  }
  return grantStatus
}

async function checkPermissions(): Promise<boolean> {
  const permissions: Array<Permissions> = ['ohos.permission.SYSTEM_FLOAT_WINDOW'];
  let grantStatus: abilityAccessCtrl.GrantStatus = await checkAccessToken(permissions[0]);

  if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
    // 已经授权，可以继续访问目标操作
    console.log('已授权')
    return true
  } else {
    // 申请权限
    console.log('没有授权')
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
            KLogger.debug('用户授权，可以继续访问目标操作')
          } else {
            // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
            KLogger.debug('用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限')
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
            KLogger.error('Failed to create the floatWindow. Cause: ' + JSON.stringify(err));
            return;
          }
          KLogger.info('Succeeded in creating the floatWindow. Data: ' + JSON.stringify(data));
          windowClass = data;

          // 2.悬浮窗窗口创建成功后，设置悬浮窗的位置、大小及相关属性等。
          windowClass.moveWindowTo(0, 200, (err) => {
            if (err.code) {
              KLogger.error('Failed to move the window. Cause:' + JSON.stringify(err));
              return;
            }
            KLogger.info('Succeeded in moving the window.');
          });
          windowClass.resize(1080, 151, (err) => {
            if (err.code) {
              KLogger.error('Failed to change the window size. Cause:' + JSON.stringify(err));
              return;
            }
            KLogger.info('Succeeded in changing the window size.');

          });

          // 3.为悬浮窗加载对应的目标页面。
          windowClass.setUIContent("pages/Index", (err) => {
            if (err.code) {
              KLogger.error('Failed to load the content. Cause:' + JSON.stringify(err));
              return;
            }
            KLogger.info('Succeeded in loading the content.');
            // 3.显示悬浮窗。
            windowClass.showWindow((err) => {
              if (err.code) {
                KLogger.error('Failed to show the window. Cause: ' + JSON.stringify(err));
                return;
              }
              KLogger.info('Succeeded in showing the window.');
            });

            try {
              windowClass.setWindowBackgroundColor('#00000000')
            } catch (exception) {
              KLogger.error('Failed to set the background color. Cause: ' + JSON.stringify(exception));
            }

            // 4.销毁悬浮窗。当不再需要悬浮窗时，可根据具体实现逻辑，使用destroy对其进行销毁。
            // windowClass.destroyWindow((err) => {
            //   if (err.code) {
            //     console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
            //     return;
            //   }
            //   console.info('Succeeded in destroying the window.');
            // });

          });

        })

      }).catch((err: BusinessError) => {
        KLogger.error(`requestPermissionsFromUser failed, code is ${err.code}, message is ${err.message}`);
      })

    }
  })

}

