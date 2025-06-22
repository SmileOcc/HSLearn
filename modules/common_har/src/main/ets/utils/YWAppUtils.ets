import bundleManager from '@ohos.bundle.bundleManager';
import { BusinessError } from '@ohos.base';
import { KeyboardAvoidMode, promptAction, window } from '@kit.ArkUI';
import { resourceManager } from '@kit.LocalizationKit';
import { common, Want } from '@kit.AbilityKit';
import { hsLog } from '@learn/logger_har';
import { YWDeviceUtils } from './YWDeviceUtils';
import { emitter } from '@kit.BasicServicesKit';


/**
 * App相关工具类(使用该工具前请在UIAbility的onWindowStageCreate方法中调用YWAppUtils的init方法初始化)
 * 一些基础跳转页：设置、商店、网络、蓝牙、want
 */

const TAG ='YWAppUtils'
export class YWAppUtils{

  private constructor() {}
  private static bundleInfo?: bundleManager.BundleInfo;

  private static readonly uri_info: string = 'application_info_entry' //应用设置页面
  private static readonly uri_network: string = "mobile_network_entry"; //移动网络设置页面
  private static readonly uri_notification: string = "systemui_notification_settings"; //通知设置页面
  private static readonly uri_bluetooth: string = "bluetooth_entry"; //蓝牙设置页面
  private static readonly uri_nfc: string = "nfc_settings"; //NFC设置页面
  private static context: common.UIAbilityContext; //common.UIAbilityContext，上下文
  private static windowStage: window.WindowStage;

  // 默认的顶部导航栏高度
  public static readonly STATUS_BAR_HEIGHT = 38.8;
  // 默认的底部导航条高度
  public static readonly BOTTOM_AVOID_HEIGHT = 10;

  /**
   * 初始化方法,缓存全局变量，在UIAbility的onWindowStageCreate方法中初始化该方法。
   * @param windowStage 窗口管理器
   */
  static init(context: common.UIAbilityContext, windowStage: window.WindowStage) {
    YWAppUtils.context = context;
    YWAppUtils.windowStage = windowStage;
  }

  static getWindowStage() {
    if (YWAppUtils.windowStage === undefined) {
      throw Error('YWAppUtils setWindowStage')
    }
    return YWAppUtils.windowStage
  }

  /**
   * 获取上下文，common.UIAbilityContext
   * @returns
   */
  static getContext(): common.UIAbilityContext {
    if (!YWAppUtils.context) {
      YWAppUtils.context = getContext() as common.UIAbilityContext; //兜底
      hsLog.e("context为空，请在UIAbility的onWindowStageCreate方法中调用YWAppUtils的init方法初始化！");
    }
    return YWAppUtils.context;
  }

  /**
   * 获取主窗口
   */
  static getMainWindow(): window.Window {
    if (!YWAppUtils.windowStage) {
      hsLog.e("windowStage为空，请在UIAbility的onWindowStageCreate方法中调用YWAppUtils的init方法初始化！");
    }
    return YWAppUtils.windowStage.getMainWindowSync();
  }

  /**
   * 获取UIContext
   * @returns
   */
  static getUIContext(): UIContext {
    return YWAppUtils.getMainWindow().getUIContext();
  }

  /**
   * 获取当前窗口的属性
   * @param windowClass 不传该值，获取主窗口的属性
   * @returns
   */
  static getWindowProperties(windowClass?: window.Window): window.WindowProperties {
    if (!windowClass) {
      windowClass = YWAppUtils.getMainWindow()
    }
    return windowClass.getWindowProperties();
  }


  /**
   * 获取虚拟键盘抬起时的页面避让模式（OFFSET-上抬模式、RESIZE-压缩模式）。
   */
  static getKeyboardAvoidMode(): KeyboardAvoidMode {
    let mode = YWAppUtils.getUIContext().getKeyboardAvoidMode();
    if (typeof mode === 'string') {
      if ('KeyBoardAvoidMode.RESIZE' === mode) {
        return KeyboardAvoidMode.RESIZE;
      } else {
        return KeyboardAvoidMode.OFFSET;
      }
    }
    return mode;
  }

  /**
   * 设置虚拟键盘弹出时，页面的避让模式。
   * @param value （OFFSET-上抬模式、RESIZE-压缩模式）
   */
  static setKeyboardAvoidMode(value: KeyboardAvoidMode) {
    YWAppUtils.getUIContext().setKeyboardAvoidMode(value);
  }


  /**
   * 设备当前是否以竖屏方式显示（竖屏）
   */
  static isPortrait(): Boolean {
    let direction = YWDeviceUtils.getDirection();
    return direction == resourceManager.Direction.DIRECTION_VERTICAL;
  }

  /**
   * 设备当前是否以横屏方式显示（横屏）
   */
  static isLandscape(): Boolean {
    let direction = YWDeviceUtils.getDirection();
    return direction == resourceManager.Direction.DIRECTION_HORIZONTAL;
  }


  /**
   * 设置窗口的显示方向属性，使用Promise异步回调。
   * Orientation 窗口显示方向类型枚举:
   *   UNSPECIFIED  0  表示未定义方向模式，由系统判定。
   *   PORTRAIT  1  表示竖屏显示模式。
   *   LANDSCAPE  2  表示横屏显示模式。
   *   PORTRAIT_INVERTED  3  表示反向竖屏显示模式。
   *   LANDSCAPE_INVERTED  4  表示反向横屏显示模式。
   *   AUTO_ROTATION  5  表示传感器自动旋转模式。
   *   AUTO_ROTATION_PORTRAIT  6  表示传感器自动竖向旋转模式。
   *   AUTO_ROTATION_LANDSCAPE  7  表示传感器自动横向旋转模式。
   *   AUTO_ROTATION_RESTRICTED  8  表示受开关控制的自动旋转模式。
   *   AUTO_ROTATION_PORTRAIT_RESTRICTED  9  表示受开关控制的自动竖向旋转模式。
   *   AUTO_ROTATION_LANDSCAPE_RESTRICTED  10  表示受开关控制的自动横向旋转模式。
   *   LOCKED  11  表示锁定模式。
   */
  static setPreferredOrientation(orientation: window.Orientation, windowClass?: window.Window): Promise<void> {
    if (!windowClass) {
      windowClass = YWAppUtils.getMainWindow();
    }
    return windowClass.setPreferredOrientation(orientation);
  }


  /**
   * 设置屏幕亮度值，使用Promise异步回调。
   * @param brightness  屏幕亮度值。该参数为浮点数，取值范围为[0.0, 1.0]或-1.0。1.0表示最亮，-1.0表示默认亮度。
   * @returns
   */
  static setWindowBrightness(brightness: number, windowClass?: window.Window): Promise<void> {
    if (!windowClass) {
      windowClass = YWAppUtils.getMainWindow();
    }
    return windowClass.setWindowBrightness(brightness);
  }


  /**
   * 设置屏幕是否为常亮状态，使用Promise异步回调。
   * @param isKeepScreenOn  true表示常亮；false表示不常亮。
   * @returns
   */
  static setWindowKeepScreenOn(isKeepScreenOn: boolean, windowClass?: window.Window): Promise<void> {
    if (!windowClass) {
      windowClass = YWAppUtils.getMainWindow();
    }
    return windowClass.setWindowKeepScreenOn(isKeepScreenOn);
  }


  /**
   * 设置窗口是否为隐私模式。设置为隐私模式的窗口，窗口内容将无法被截屏或录屏。
   * @param isPrivacyMode 窗口是否为隐私模式。true表示模式开启；false表示模式关闭。
   * @returns
   */
  static setWindowPrivacyMode(isPrivacyMode: boolean, windowClass?: window.Window): Promise<void> {
    if (!windowClass) {
      windowClass = YWAppUtils.getMainWindow();
    }
    return windowClass.setWindowPrivacyMode(isPrivacyMode);
  }


  /**
   * 设置窗口的背景色。Stage模型下，该接口需要在loadContent()或setUIContent()调用生效后使用。
   * @param color 需要设置的背景色，为十六进制RGB或ARGB颜色，不区分大小写，例如#00FF00或#FF00FF00。
   * @returns
   */
  static setWindowBackgroundColor(color: string, windowClass?: window.Window) {
    if (!windowClass) {
      windowClass = YWAppUtils.getMainWindow();
    }
    return windowClass.setWindowBackgroundColor(color);
  }

  /**
   * 设置点击时是否支持切换焦点窗口，使用Promise异步回调。
   * @param isFocusable 点击时是否支持切换焦点窗口。true表示支持；false表示不支持。
   * @returns
   */
  static setWindowFocusable(isFocusable: boolean, windowClass?: window.Window): Promise<void> {
    if (!windowClass) {
      windowClass = YWAppUtils.getMainWindow();
    }
    return windowClass.setWindowFocusable(isFocusable);
  }

  /**
   * 设置窗口是否为可触状态，使用Promise异步回调。
   * @param isTouchable 窗口是否为可触状态。true表示可触；false表示不可触。
   * @returns
   */
  static setWindowTouchable(isTouchable: boolean, windowClass?: window.Window): Promise<void> {
    if (!windowClass) {
      windowClass = YWAppUtils.getMainWindow();
    }
    return windowClass.setWindowTouchable(isTouchable);
  }


  /**
   * 获取状态栏的高度，单位为px。
   * @returns
   */
  static getStatusBarHeight(): number {
    let windowClass = YWAppUtils.getMainWindow();
    let avoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    return avoidArea.topRect.height;
  }

  /**
   * 获取底部导航条的高度，单位为px。
   * @returns
   */
  static getNavigationIndicatorHeight(): number {
    let windowClass = YWAppUtils.getMainWindow();
    let avoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    return avoidArea.bottomRect.height;
  }

  /**
   * 获取主窗口顶部导航栏高度
   * @returns {callback((statusBarHeight: number) => void))}
   */
  static getNavStatusBarHeight(callback: ((statusBarHeight: number) => void)): void {
    if (!YWAppUtils.windowStage) {
      hsLog.e("windowStage为空，请在UIAbility的onWindowStageCreate方法中调用YWAppUtils的init方法初始化！");
      return;
    }
    YWAppUtils.windowStage.getMainWindow((err, windowClass: window.Window) => {
      if (err.code) {
        hsLog.e(`Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
        return;
      }
      try {
        const type = window.AvoidAreaType.TYPE_SYSTEM;
        const avoidArea = windowClass.getWindowAvoidArea(type);
        const height = avoidArea.topRect.height;
        hsLog.i("Successful get statusHeight" + height);
        callback(height);
      } catch (err) {
        callback(YWAppUtils.STATUS_BAR_HEIGHT);
        hsLog.e("Failed to get statusHeight");
      }
    });
  }

  /**
   * 获取主窗口底部导航条高度
   * @returns {callback: ((bottomAvoidHeight: number) => void)}
   */
  static getBottomAvoidHeight(callback: ((bottomAvoidHeight: number) => void)): void {
    if (!YWAppUtils.windowStage) {
      hsLog.e('windowStage is undefined.');
      return;
    }
    YWAppUtils.windowStage.getMainWindow((err, windowClass: window.Window) => {
      if (err.code) {
        hsLog.e(`Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
        return;
      }
      try {
        const type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR;
        const avoidArea = windowClass.getWindowAvoidArea(type);
        const height = avoidArea.bottomRect.height;
        hsLog.i('Successful get bottomAvoidHeight ==' + height);
        callback(height);
      } catch (err) {
        callback(YWAppUtils.BOTTOM_AVOID_HEIGHT);
        hsLog.e("Failed to get bottomAvoidHeight");
      }
    });
  }

  /**
   * 设置沉浸式状态栏
   * @param isLayoutFullScreen 窗口的布局是否为沉浸式布局（该沉浸式布局状态栏、导航栏仍然显示）。true表示沉浸式布局；false表示非沉浸式布局。
   * @param enable 设置窗口全屏模式时状态栏、导航栏或底部导航条是否显示，true表示显示 false表示隐藏。
   * @param color 设置窗口的背景颜色。
   * @param systemBarProperties 状态栏、导航栏的属性:
   *   statusBarColor 状态栏背景颜色，为十六进制RGB或ARGB颜色，不区分大小写，例如#00FF00或#FF00FF00。默认值：#0x66000000。
   *   statusBarContentColor 状态栏文字颜色。当设置此属性后， isStatusBarLightIcon属性设置无效。默认值：#0xE5FFFFFF。
   *   isStatusBarLightIcon 状态栏图标是否为高亮状态。true表示高亮；false表示不高亮。默认值：false。
   *   navigationBarColor 导航栏背景颜色，为十六进制RGB或ARGB颜色，不区分大小写，例如#00FF00或#FF00FF00。默认值：#0x66000000。
   *   navigationBarContentColor  导航栏文字颜色。当设置此属性后， isNavigationBarLightIcon属性设置无效。默认值：#0xE5FFFFFF。
   *   isNavigationBarLightIcon 导航栏图标是否为高亮状态。true表示高亮；false表示不高亮。默认值：false。
   */
  static setStatusBar(isLayoutFullScreen: boolean = true, enable: boolean = true, color: string = '#FFFFFF', systemBarProperties?: window.SystemBarProperties) {
    //加载主窗口
    let windowClass = YWAppUtils.getMainWindow();

    //1.设置全屏模式
    windowClass.setWindowLayoutFullScreen(isLayoutFullScreen).then(() => {
      windowClass.setWindowBackgroundColor(color);
    }).catch((error: BusinessError) => {
      hsLog.e(`setWindowLayoutFullScreen-异常 ~ code: ${error.code} -·- message: ${error.message}`);
    });

    windowClass.setWindowSystemBarEnable(enable ? ['status', 'navigation'] : []).then(() => {
      windowClass.setSpecificSystemBarEnabled("navigationIndicator", enable); //底部导航条。
    }).catch((error: BusinessError) => {
      hsLog.e(`setWindowSystemBarEnable-异常 ~ code: ${error.code} -·- message: ${error.message}`);
    });
    if (systemBarProperties) {
      windowClass.setWindowSystemBarProperties(systemBarProperties).catch((error: BusinessError) => {
        hsLog.e(`setWindowSystemBarProperties-异常 ~ code: ${error.code} -·- message: ${error.message}`);
      });
    }
  }

  static setSystemBarContentColor(color: string) {
    if (!YWAppUtils.windowStage) {
      hsLog.e("windowStage为空，请在UIAbility的onWindowStageCreate方法中调用YWAppUtils的init方法初始化！");
      return;
    }
    YWAppUtils.windowStage.getMainWindow((err, windowClass: window.Window) => {
      if (err.code) {
        hsLog.e(`Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
        return;
      }
      try {
        // 设置导航栏，状态栏内容颜色
        windowClass.setWindowSystemBarProperties({
          statusBarContentColor: color
        });
        hsLog.i('Successful to set windowLayoutFullScreen');
      } catch (err) {
        hsLog.e("Failed to set windowLayoutFullScreen");
      }
    });
  }

  /**
   * 当前主窗口是否开启沉浸模式
   * @returns {void}
   */
  static setImmersive(popPage?: () => void) {
    if (!YWAppUtils.windowStage) {
      hsLog.e("windowStage为空，请在UIAbility的onWindowStageCreate方法中调用YWAppUtils的init方法初始化！");
      return;
    }
    YWAppUtils.windowStage.getMainWindow((err, windowClass: window.Window) => {
      if (err.code) {
        hsLog.e(`Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
        return;
      }
      try {
        // 设置沉浸式全屏
        windowClass.setWindowLayoutFullScreen(true)
          .then(() => {
            YWAppUtils.registerEmitter(windowClass, popPage);
          })
        hsLog.i('Successful to set windowLayoutFullScreen');
      } catch (err) {
        hsLog.e("Failed to set windowLayoutFullScreen");
      }
    });
  }

  /*
   * 添加事件订阅
   */
  // TODO: 知识点：通过emitter.on监听的方式来改变沉浸式适配和状态栏的变化。
  static registerEmitter(windowClass: window.Window, popPage?: () => void) {
    // 定义返回主页时发送的事件id
    let innerEvent: emitter.InnerEvent = {
      eventId: 2
    };
    emitter.on(innerEvent, (data: emitter.EventData) => {
      // 收到返回事件，显示状态栏和导航栏，退出全屏模式，再返回主页
      if (data?.data?.backPressed) {
        // 设置导航栏，状态栏内容为白色
        windowClass.setWindowSystemBarProperties({
          statusBarContentColor: '#000000'
        })
          .then(() => {
            if (popPage) {
              popPage();
            } else {

            }
          });
      }
    })
  }

  /*
   * 取消事件订阅
   */
  static deleteEmitter() {
    emitter.off(2);
  }




  /**
   * 获取当前应用的BundleInfo
   * @returns
   */
  static async getBundleInfo(): Promise<bundleManager.BundleInfo | undefined> {
    if (YWAppUtils.bundleInfo !== undefined) {
      return YWAppUtils.bundleInfo
    }
    try {
      YWAppUtils.bundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    } catch (e) {
      const error = e as BusinessError
      hsLog.e(TAG,`getBundleInfo error: ${error.code}  msg:${error.message}`)
    }
    return YWAppUtils.bundleInfo
  }


  /**
   * 获取应用程序的配置信息
   * @returns
   */
  static async getAppInfo(){

    const bundleInfo = await YWAppUtils.getBundleInfo();
    if (bundleInfo === undefined) {
      hsLog.e(TAG,`getAppInfo error: bundleInfo undefined`)
      return undefined
    }
    return bundleInfo!.appInfo
  }

  /**
   * 获取包名
   * @returns
   */
  static async getBundleName(): Promise<string> {
    const info = await YWAppUtils.getBundleInfo();
    if (info === undefined) {
      return '';
    }
    return info.name;
  }


  /**
   * 跳转应用设置页面（调用此方法到设置，手动开启权限）
   */
  static async toAppSetting(uri: string = YWAppUtils.uri_info): Promise<void> {
    let context = YWAppUtils.getContext();
    let want: Want = {
      bundleName: 'com.huawei.hmos.settings', //设置应用bundleName
      abilityName: 'com.huawei.hmos.settings.MainAbility', //设置应用abilityName
      uri: uri, //目标页面
      parameters: {
        bundleName: context.abilityInfo.bundleName, //拉起方应用包名
        pushParams: context.abilityInfo.bundleName, //拉起方应用包名
      }
    }
    return await context.startAbility(want)
  }

  /**
   * 跳转移动网络设置页面
   */
  static toNetworkSetting(): Promise<void> {
    return YWAppUtils.toAppSetting(YWAppUtils.uri_network);
  }

  /**
   * 跳转通知设置页面
   */
  static toNotificationSetting(): Promise<void> {
    return YWAppUtils.toAppSetting(YWAppUtils.uri_notification);
  }

  /**
   * 跳转蓝牙设置页面
   */
  static toBluetoothSetting(): Promise<void> {
    return YWAppUtils.toAppSetting(YWAppUtils.uri_bluetooth);
  }

  /**
   * 跳转NFC设置页面
   */
  static toNfcSetting(): Promise<void> {
    return YWAppUtils.toAppSetting(YWAppUtils.uri_nfc);
  }

  /**
   * 跳转到浏览器
   * @param url
   */
  static jumpBrows(url: string) {
    let want: Want = {
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri: url
    }
    YWAppUtils.jumpWant(want)
  }

  static jumpStore(appId: string) {
    const want: Want = {
      uri: `store://appgallery.huawei.com/app/detail?id=${appId}`
    };
    YWAppUtils.jumpWant(want)
  }

  /**
   * 显式跳转的其他应用
   * @param bundleName
   * @param abilityName
   * @param deviceId 传空时，表示本设备
   */
  static jumpApp(bundleName: string, abilityName: string, deviceId?: string) {
    let want: Want = {
      deviceId: deviceId, // deviceId为空表示本设备
      bundleName: bundleName,
      abilityName: abilityName,
    };

    YWAppUtils.jumpWant(want)
  }

  /**
   * 隐式跳转到其他应用打开内容
   * @param deviceId
   * @param bundleName
   * @param abilityName
   */
  static jumpAction(action: string, entities: string, uri: string, type: string) {
    let want: Want = {
      action: action,
      entities: [entities], // entities can be omitted
      uri: uri,
      type: type,
    };

    YWAppUtils.jumpWant(want)
  }

  static jumpWant(want: Want) {
    YWAppUtils.getContext().startAbility(want)
  }

  static jumpUrl(url: string) {
    if (!url) {
      return;
    }
    if (url.startsWith('http://') || url.startsWith('https://')) {
      YWAppUtils.jumpBrows(url);
      return;
    }
    const data: Record<string, string> = JSON.parse(url);
    if (data === undefined) {
      return;
    }
    const appId: string = data['appId'];
    if (appId !== undefined) {
      YWAppUtils.jumpStore(appId);
      return;
    }

    //{"deviceId":"","bundleName":"cn.","abilityName":"EntryAbility"}
    const deviceId: string = data['deviceId'];
    const bundleName: string = data['bundleName'];
    const abilityName: string = data['abilityName'];

    if (bundleName !== undefined && abilityName !== undefined) {
      YWAppUtils.jumpApp(bundleName, abilityName, deviceId);
      return;
    }

    //{"action":"ohos.want.action.search","entities":"entity.system.browsable","uri":"https://www.test.com:8080/query/student","type":"text/plain"}
    const action: string = data['action'];
    const entities: string = data['entities'];
    const uri: string = data['uri'];
    const type: string = data['type'];

    if (action !== undefined && entities !== undefined && uri !== undefined && type !== undefined) {
      YWAppUtils.jumpAction(action, entities, uri, type);
      return;
    }
  }
}