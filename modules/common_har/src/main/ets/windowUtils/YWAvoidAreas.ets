import { Size, window } from '@kit.ArkUI'
import { Rect } from '@ohos.UiTest';

export interface YWAvoidAreas {
  system:window.Rect
  cutout:window.Rect
  system_gesture:window.Rect
  keyboard:window.Rect
  navigation_indicator:window.Rect
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
    cutout: getEmptyRect(),
    system_gesture: getEmptyRect(),
    keyboard:getEmptyRect(),
    navigation_indicator: getEmptyRect()
  }
}
function getDefaultAvoidPadding(tWindow:window.Window):window.AvoidArea {
  return {
    visible: true,
    leftRect: getEmptyRect(),
    rightRect: getEmptyRect(),
    topRect: getEmptyRect(),
    bottomRect:getEmptyRect()
  }
}


export function getAvoidPadding(avoidAreas:YWAvoidAreas):Padding {

  let bottom = 0
  let top = 0
  // if (avoidAreas.navigation_indicator.height > avoidAreas.keyboard.bottomRect.height) {
  //  //todo
  //   bottom = avoidAreas.navigation_indicator.bottomRect.height
  // }

  return {
    top:`${top}px`,
    bottom:`${bottom}px`
  }
}

export async function initListerWindow(windowObj: window.Window) {

  // let avs = windowObj.getWindowAvoidArea()
  let area = windowObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
  windowObj.setWindowLayoutFullScreen(true)

  AppStorage.set("window",area)

  windowObj.on("windowSizeChange", (value)=>{

    let newArea = windowObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
    AppStorage.set("window",newArea)

  })

}