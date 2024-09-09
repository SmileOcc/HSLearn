import { window } from '@kit.ArkUI';

export async function initKeyboardSetting(tWindow:window.Window) {

  let area = tWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD)
  AppStorage.set("kKeyboardArea",area)


  tWindow.on("keyboardHeightChange",(value)=>{
    let newArea = tWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD)
    AppStorage.set("kKeyboardArea",newArea)
  })

}
