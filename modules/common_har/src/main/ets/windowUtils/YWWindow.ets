import { window } from '@kit.ArkUI';
import { initListerSafeWindow, initListerWindow } from './YWAvoidAreas';
import { initKeyboardSetting } from './YWKeyboardUtils';

export async function initWindowSetting(tWindow: window.WindowStage) {

  let windowObject = tWindow.getMainWindowSync()
  windowObject.setWindowLayoutFullScreen(true)
  initListerWindow(windowObject)
  initListerSafeWindow(windowObject)
  initKeyboardSetting(windowObject)

}