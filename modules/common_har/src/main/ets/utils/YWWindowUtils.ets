import { display, window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hsLog } from '@learn/logger_har';


/**
 * 窗口工具类
 */
const TAG = 'YWWindowUtils'
export class YWWindowUtils {

  private constructor() {}

  private static windowStage: window.WindowStage;

  static getWindowStage() {
    if (YWWindowUtils.windowStage === undefined) {
      throw Error('YWWindowUtils setWindowStage')
    }
    return YWWindowUtils.windowStage
  }

  static setWindowStage(windowStage: window.WindowStage): void {
    YWWindowUtils.windowStage = windowStage;
  }

  /*
    * 设置横竖屏
    * @Params orientation: 旋转方向
    */
  static setWindowOrientation(windowStage: window.WindowStage, orientation: number): void {
    windowStage.getMainWindow((error, win: window.Window) => {
      win.setPreferredOrientation(orientation).then((data) => {
        // do some log
      }).catch((err: Error) => {
      });
    })
  }

  /**
   * 设置隐藏状态栏
   * @param windowStage
   */
  static hideSystemBar (windowStage: window.WindowStage) {
    windowStage.getMainWindow((error, win: window.Window) => {
      win.setWindowSystemBarEnable([])
    })
  }

  static hideWindowSystemBar (win: window.Window) {
    win.setWindowSystemBarEnable([])
  }

  /**
   * 设置全屏
   * @param windowStage
   */
  static setFullScreen (windowStage: window.WindowStage, full:boolean = true) {
    windowStage.setDefaultDensityEnabled(full)
  }


  /**
   * 缓存窗体,关闭时需要
   */
  private static cacheWindow: window.Window;

  /**
   * 根据参数创建窗口
   */
  static async createWindow(options: WinOptions): Promise<void> {
    if (!options) {
      options = new WinOptions();
    }
    if (!options.name) {
      options.name = 'subWindow';
    }
    if (options.windowType == undefined) {
      options.windowType = window.WindowType.TYPE_DIALOG;
    }
    if (!options.bgColor) {
      options.bgColor = '#33606266';
    }
    try {
      //创建窗口
      let windowClass = await window.createWindow({
        name: options.name,
        windowType: options.windowType,
        ctx: getContext() as common.UIAbilityContext
      });
      //将窗口缓存
      YWWindowUtils.cacheWindow = windowClass;
      await windowClass.setUIContent(options.contentRouter);
      //获取屏幕四大角
      let d = display.getDefaultDisplaySync();
      //设置窗口大小
      await windowClass.resize(d.width, d.height);
      // 设置窗口背景颜色
      windowClass.setWindowBackgroundColor(options.bgColor);
      //显示窗口
      await windowClass.showWindow();
    } catch (err) {
      let error = err as BusinessError;

      hsLog.e(`WindowUtil-createWindow-异常 ~ code: ${error.code} -·- message: ${error.message}`);
    }
  }


  //设置子窗口背景透明
  static setWindowBackgroundColor() {
    if (YWWindowUtils.cacheWindow) {
      YWWindowUtils.cacheWindow.setWindowBackgroundColor("#00000000")
    }
  }


  /**
   * 关闭窗口
   * @returns
   */
  static async closeWindow(): Promise<void> {
    if (YWWindowUtils.cacheWindow) {
      await YWWindowUtils.cacheWindow.destroyWindow();
    }
  }


  /**
   * 获取当前窗口
   * @param context
   * @returns
   */
  static getCurrentWindow(context: Context) {
    return window.getLastWindow(context);
  }

  /**
   * 获取窗口对象
   * @returns
   */
  static getScreenWidth(): number{
    let displayClass: display.Display | null = display.getDefaultDisplaySync();
    return px2vp(displayClass.width);
  }

  /**
   * 获取窗口对象
   * @returns
   */
  static getScreenHeight(): number{
    let displayClass: display.Display | null = display.getDefaultDisplaySync();
    return px2vp(displayClass.height);
  }

}



/**
 * 窗口入参对象
 */
class WinOptions {
  /**
   * 窗口名称 默认eftool
   */
  name?: string;
  /**
   * 窗口类型 默认TYPE_DIALOG
   */
  windowType?: window.WindowType;
  /**
   *窗口要显示的路由  如:pages/Welcome需要在main_pages.json中声明
   */
  contentRouter: string = '';
  /**
   * 窗口背景颜色,默认#33606266
   */
  bgColor?: string;
  /**
   * 窗口创建回调函数
   */
  callBack?: () => void;
}