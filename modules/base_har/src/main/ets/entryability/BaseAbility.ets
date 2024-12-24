import {
  abilityAccessCtrl,
  AbilityConstant,
  AbilityLifecycleCallback,
  bundleManager,
  Context,
  errorManager,
  Permissions,
  UIAbility,
  Want
} from '@kit.AbilityKit';

import { hilog } from '@kit.PerformanceAnalysisKit';
import { process } from '@kit.ArkTS';

import {
  BreakpointSystem,
  GlobalContext,
  YWAppUtils,
  YWWindowUtils,
  initWindowSetting,
  ENU_CONTEXT
} from '@learn/common_har'
import { hsLog } from '@learn/logger_har';

import { display, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { YWDarkManager } from '@learn/dark_har';


const permissions: Array<Permissions> = ['ohos.permission.SYSTEM_FLOAT_WINDOW'];

const TAG = 'BaseAbility'

abstract class BaseAbility extends UIAbility {
  //启动根页面
  abstract initRootPage(): string

  // 定义生命周期ID
  lifecycleId: number = -1;
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  private registerId?: number
  localStorage: LocalStorage = new LocalStorage();

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    //在应用入口存储当前上下文，通过get方法拿到当前上下文
    AppStorage.setOrCreate<Context>(ENU_CONTEXT.UI_Root, this.context)
    // const ctx = AppStorage.get<Context>('context')

    this.initDark()
    this.initParams()
    this.initErrorManager()
    this.registerLifeCycle()

    let mainTid = process.tid
    hsLog.d(`==== 主线程tid: ${mainTid}`)
  }

  onWindowStageWillDestroy(windowStage: window.WindowStage): void {
    //注销错误观测器
    errorManager.off('error', this.registerId, (result) => {

    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');

    // 开发者可以在适当的时机，如子窗口上点击关闭按钮等，销毁子窗口。并不一定需要在onWindowStageDestroy调用，这里仅作展示
    // this.destroySubWindow();
    this.breakpointSystem.unregister();
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  onDestroy(): void {
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onDestroy');

    // 获取应用上下文
    let applicationContext = this.context.getApplicationContext();
    // 取消应用内生命周期回调
    applicationContext.off('abilityLifecycle', this.lifecycleId);
  }

  protected loadContent(windowStage: window.WindowStage): void { //子类重写了

    this.loadRootPage(windowStage)
  }

  loadRootPage(windowStage: window.WindowStage): void {
    windowStage.loadContent(this.initRootPage(), this.localStorage, (err) => {
      if (err.code) {
        hilog.error(0x0000, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }

      // 设置背景色实现沉浸式
      //windowStage.getMainWindowSync().setWindowBackgroundColor('#9F6BF5')
      hilog.info(0x0000, TAG, 'Succeeded in loading the content.');
    });
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    YWAppUtils.init(this.context, windowStage)

    //全局配置context
    // this.configGlobalContext(windowStage)

    // showAlertView(this.context,windowStage)
    //设置全屏
    // this.requestFullScreen(windowStage, this.context)
    //YWAppUtils.setStatusBar(true,true,"")

    this.breakpointSystem.register();

    this.loadContent(windowStage)
  }

  initDark() {
    YWDarkManager.initConfigDark(this.context)
  }

  initParams() {}

  private registerLifeCycle() {

    let abilityLifecycleCallback: AbilityLifecycleCallback = {
      // 当UIAbility创建时被调用
      onAbilityCreate(uiAbility) {
        hsLog.i(TAG, `onAbilityCreate uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
      },
      // 当窗口创建时被调用
      onWindowStageCreate(uiAbility, windowStage: window.WindowStage) {
        hsLog.i(TAG, `onWindowStageCreate uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
        hsLog.i(TAG, `onWindowStageCreate windowStage: ${JSON.stringify(windowStage)}`);
      },
      // 当窗口处于活动状态时被调用
      onWindowStageActive(uiAbility, windowStage: window.WindowStage) {
        hsLog.i(TAG, `onWindowStageActive uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
        hsLog.i(TAG, `onWindowStageActive windowStage: ${JSON.stringify(windowStage)}`);
      },
      // 当窗口处于非活动状态时被调用
      onWindowStageInactive(uiAbility, windowStage: window.WindowStage) {
        hsLog.i(TAG, `onWindowStageInactive uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
        hsLog.i(TAG, `onWindowStageInactive windowStage: ${JSON.stringify(windowStage)}`);
      },
      // 当窗口被销毁时被调用
      onWindowStageDestroy(uiAbility, windowStage: window.WindowStage) {
        hsLog.i(TAG, `onWindowStageDestroy uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
        hsLog.i(TAG, `onWindowStageDestroy windowStage: ${JSON.stringify(windowStage)}`);
      },
      // 当UIAbility被销毁时被调用
      onAbilityDestroy(uiAbility) {
        hsLog.i(TAG, `onAbilityDestroy uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
      },
      // 当UIAbility从后台转到前台时触发回调
      onAbilityForeground(uiAbility) {
        hsLog.i(TAG, `onAbilityForeground uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
      },
      // 当UIAbility从前台转到后台时触发回调
      onAbilityBackground(uiAbility) {
        hsLog.i(TAG, `onAbilityBackground uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
      },
      // 当UIAbility迁移时被调用
      onAbilityContinue(uiAbility) {
        hsLog.i(TAG, `onAbilityContinue uiAbility.launchWant: ${JSON.stringify(uiAbility.launchWant)}`);
      }
    };
    // 获取应用上下文
    let applicationContext = this.context.getApplicationContext();
    // 注册应用内生命周期回调
    this.lifecycleId = applicationContext.on('abilityLifecycle', abilityLifecycleCallback);
    hsLog.i(TAG, `register callback number: ${this.lifecycleId}`);
  }

  initErrorManager() {

    //ErrorManager可以提供对错误观察器的注册和注销的能力，建议在主EntryAbility或者AbilityStage中
    this.registerId = errorManager.on('error', {
      onUnhandledException: (errMsg) => {
        console.log('产生未捕获异常时的回调，onUnhandledException:', errMsg);
      },
      onException: (errorObj) => {
        console.log('产生异常上报JS层时的回调，onException');

      }
    })
  }

  async configGlobalContext(windowStage: window.WindowStage) {

    initWindowSetting(windowStage)

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
      // 获取状态栏高度
      let avoidArea = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      hsLog.i("statusBarHeight===", avoidArea.topRect.height.toString())

      let isFullScreen = data.getWindowProperties().isFullScreen

    })

    //获取分辨率, 将获取到的分辨率存放在GlobalContext这个文件中的Map变量中
    GlobalContext.getContext().setObject('display', await display.getDefaultDisplaySync());

    //自动旋转
    window.getLastWindow(getContext(this)).then((win) => {
      win.setPreferredOrientation(window.Orientation.AUTO_ROTATION_RESTRICTED)
    })

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
        YWWindowUtils.hideSystemBar(windowStage)
        YWWindowUtils.setFullScreen(windowStage)
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
}

export { BaseAbility }

async function checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
  let atManager = abilityAccessCtrl.createAtManager();
  let grantStatus: abilityAccessCtrl.GrantStatus;

  // 获取应用程序的accessTokenID
  let tokenId: number;
  try {
    let bundleInfo: bundleManager.BundleInfo =
      await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
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
            //     console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
            //     return;
            //   }
            //   console.info('Succeeded in destroying the window.');
            // });

          });

        })

      }).catch((err: BusinessError) => {
        hsLog.e(`requestPermissionsFromUser failed, code is ${err.code}, message is ${err.message}`);
      })

    }
  })

}

