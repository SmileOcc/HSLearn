import { Size, window } from '@kit.ArkUI'
import { Rect } from '@ohos.UiTest';

export interface YWAvoidAreas {
  system:window.AvoidArea;
  cutout:window.AvoidArea;
  system_gesture:window.AvoidArea;
  keyboard:window.AvoidArea;
  navigation_indicator:window.AvoidArea;
};

function getEmptyRect():window.Rect {
  return {
    left:0,
    top:0,
    width:0,
    height:0
  }
}

function getEmptyAreas():YWAvoidAreas {
  return {
    system: getEmptyRect(),
  }
}
function getDefaultAvoidPadding(tWindow:window.Window):YWAvoidAreas {
  return {

    system: tWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM),
    cutout: tWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_CUTOUT),
    system_gesture: tWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM_GESTURE),
    keyboard: tWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD),
    navigation_indicator: tWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
  }
}



function getEmptySize():window.Size {
  return {
    width:0,
    height:0
  }
}

export function getAvoidPadding(avoidAreas:YWAvoidAreas):Padding {

  let bottom = 0
  if (avoidAreas.navigation_indicator.bottomRect.height > avoidAreas.keyboard.bottomRect.height) {
   //todo
    bottom = avoidAreas.navigation_indicator.bottomRect.height
  }

  return {
    top:`${avoidAreas.navigation_indicator.topRect.top}px`,
    bottom:`${bottom}px`
  }
}

export async function initListerWindow(windowObj: window.Window) {

  // let avs = windowObj.getWindowAvoidArea()
  let area = windowObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
  windowObj.setWindowLayoutFullScreen(true)

  // let size = windowObj
  AppStorage.set("window","1")

  windowObj.on("windowSizeChange", (value)=>{
    AppStorage.set("window",value)

  })
  // if (area.topRect.height > 0) {
  //   // 2.设置导航栏、状态栏不显示。
  //   windowObj.setWindowSystemBarEnable([], (err) => {
  //
  //   });
  // }

}