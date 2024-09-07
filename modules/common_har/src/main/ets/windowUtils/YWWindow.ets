import { window } from '@kit.ArkUI';
import { initListerWindow } from './YWAvoidAreas';
import { initKeyboardSetting } from './YWKeyboardUtils';

export async function initWindowSetting(twindow: window.WindowStage) {

  let windowObject = twindow.getMainWindowSync()
  initListerWindow(windowObject)
  initKeyboardSetting(windowObject)

}