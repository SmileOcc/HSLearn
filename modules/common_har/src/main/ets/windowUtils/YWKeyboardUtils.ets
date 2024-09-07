import { window } from '@kit.ArkUI';

export async function initKeyboardSetting(tWindow:window.Window) {

  tWindow.on("keyboardHeightChange",(value)=>{
    AppStorage.set("kKeyboardHeight",value)
  })

}
