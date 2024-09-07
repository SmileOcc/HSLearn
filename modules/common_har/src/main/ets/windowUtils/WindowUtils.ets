import { window } from '@kit.ArkUI';

export class WindowUtils {
  // 顶部状态栏高度
  static statusBarHeight: number = 0;

  // 底部导航栏高度
  static navigationBarHeight: number = 0;

  // 是否开启全屏布局
  static isFullScreenLayout: boolean;

  // 当前状态栏内容颜色
  static statusBarContentColor: string;

  // 应用主窗口对象
  static appMainWindow: window.Window;

  // 初始化方法
  static initialize(windowStage: window.WindowStage, isFullScreen: boolean) {
    // 获取应用主窗口对象
    WindowUtils.appMainWindow = windowStage.getMainWindowSync();

    // 设置全屏布局状态
    WindowUtils.isFullScreenLayout = isFullScreen;

    // 如果开启全屏布局，则设置窗口为全屏模式
    if (WindowUtils.isFullScreenLayout) {
      WindowUtils.appMainWindow.setWindowLayoutFullScreen(isFullScreen);
    }

    // 获取顶部状态栏区域，并计算高度
    let avoidAreaTop = WindowUtils.appMainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    WindowUtils.statusBarHeight = Number(px2vp(avoidAreaTop.topRect.height).toPrecision(5));

    // 获取底部导航栏区域，并计算高度
    let avoidAreaBottom = WindowUtils.appMainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    WindowUtils.navigationBarHeight = Number(px2vp(avoidAreaBottom.bottomRect.height).toPrecision(5));

    // 监听折叠屏状态
    // WindowUtils.listenDisplayFoldStatus();
  }


}