import { window } from '@kit.ArkUI';
import { initListerSafeWindow, initListerWindow } from './YWAvoidAreas';
import { initKeyboardSetting } from './YWKeyboardUtils';

export async function initWindowSetting(twindow: window.WindowStage) {

  let windowObject = twindow.getMainWindowSync()
  windowObject.setWindowLayoutFullScreen(true)
  initListerWindow(windowObject)
  initListerSafeWindow(windowObject)
  initKeyboardSetting(windowObject)

}