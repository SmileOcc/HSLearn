import { window } from '@kit.ArkUI';
import { initListerSafeWindow, initListerWindow } from './YWAvoidAreas';
import { initKeyboardSetting } from './YWKeyboardUtils';

export async function initWindowSetting(tWindow: window.WindowStage) {

  let windowObject = tWindow.getMainWindowSync()
  //所以不推荐使用这种方式来设置沉浸式。
  // windowObject.setWindowLayoutFullScreen(true)
  initListerWindow(windowObject)
  initListerSafeWindow(windowObject)
  initKeyboardSetting(windowObject)

}


// 页面中设置setWindowLayoutFullScreen
// 我们只需要某个页面全屏显示，这时候我们可以单独给这个页面设置setWindowLayoutFullScreen属性：
//
// aboutToAppear(): void {
//   window.getLastWindow(getContext())
//   .then(win => {
//   win.setWindowLayoutFullScreen(true)
// })
// }