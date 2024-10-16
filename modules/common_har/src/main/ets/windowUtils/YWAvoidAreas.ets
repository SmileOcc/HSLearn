import { Size, window } from '@kit.ArkUI'
import { Rect } from '@ohos.UiTest';
import { Constants } from '../common/Constants';


export interface YWAvoidAreas {
  system:window.AvoidArea
  cutout:window.AvoidArea
  system_gesture:window.AvoidArea
  keyboard:window.AvoidArea
  navigation_indicator:window.AvoidArea
};

function getEmptyRect():window.Rect {
  return {
    left:0,
    top:0,
    width:0,
    height:0
  }
}

function getEmptyAvoidArea():window.AvoidArea {
  return {
    visible: true,
    leftRect: getEmptyRect(),
    rightRect: getEmptyRect(),
    bottomRect: getEmptyRect(),
    topRect: getEmptyRect()
  }
}

export function getDefaultAvoidAreas():YWAvoidAreas {
  return {
    system: getEmptyAvoidArea(),
    cutout: getEmptyAvoidArea(),
    system_gesture: getEmptyAvoidArea(),
    keyboard:getEmptyAvoidArea(),
    navigation_indicator: getEmptyAvoidArea()
  }
}
function getAvoidAreas(tWindow:window.Window):YWAvoidAreas {
  return {
    system: tWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM),
    cutout: tWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_CUTOUT),
    system_gesture: tWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM_GESTURE),
    keyboard:tWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD),
    navigation_indicator: tWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)

  }
}


export function getAvoidPadding(avoidAreas:YWAvoidAreas):Padding {

  let bottom = 0
  let top = avoidAreas.system.topRect.top
  if (avoidAreas.navigation_indicator.bottomRect.height > avoidAreas.keyboard.bottomRect.height) {
    bottom = avoidAreas.navigation_indicator.bottomRect.height
  }

  return {
    top:`${top}px`,
    bottom:`${bottom}px`
  }
}

export async function initListerWindow(windowObj: window.Window) {


  // windowObj.setWindowLayoutFullScreen(true)
  let rect = windowObj.getWindowProperties().windowRect
  let size_w = rect.width
  let size_h = rect.height


  AppStorage.set(Constants.kStorageWidth,size_w)
  AppStorage.set(Constants.kStatusBarHeight,size_h)
  windowObj.on("windowSizeChange", (value)=>{

    let rect = windowObj.getWindowProperties().windowRect
    let size_w = rect.width
    let size_h = rect.height
    AppStorage.set(Constants.kStorageWidth,size_w)
    AppStorage.set(Constants.kStatusBarHeight,size_h)

  })

}

export async function initListerSafeWindow(windowObj: window.Window) {

  let area = getAvoidAreas(windowObj)
  // windowObj.setWindowLayoutFullScreen(true)

  AppStorage.set(Constants.kStorageAreas,area)
  windowObj.on("windowSizeChange", (value)=>{

    let newArea = getAvoidAreas(windowObj)
    AppStorage.set("window",newArea)

  })

}

