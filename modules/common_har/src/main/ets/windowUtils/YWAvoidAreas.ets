import { Size, window } from '@kit.ArkUI'
import { YWConstants } from '@learn/constants_har';
import { Rect } from '@ohos.UiTest';


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

  // 此处获取的单位为px，需转为vp
  // let bottomRectHeight = px2vp(bottom); // 获取到导航条区域的高度


  return {
    top:`${top}px`,
    bottom:`${bottom}px`
  }
}

export async function initListerWindow(windowObj: window.Window) {


  // windowObj.setWindowLayoutFullScreen(true)
  let rect = windowObj.getWindowProperties().windowRect
  let size_w = px2vp(rect.width)
  let size_h = px2vp(rect.height)


  AppStorage.setOrCreate(YWConstants.kStorageWidth,size_w)
  AppStorage.setOrCreate(YWConstants.kStorageHeight,size_h)
  windowObj.on("windowSizeChange", (value)=>{

    let rect = windowObj.getWindowProperties().windowRect
    let size_w = rect.width
    let size_h = rect.height
    AppStorage.setOrCreate(YWConstants.kStorageWidth,size_w)
    AppStorage.setOrCreate(YWConstants.kStorageHeight,size_h)

  })

}

export async function initListerSafeWindow(windowObj: window.Window) {

  let area = getAvoidAreas(windowObj)
  // windowObj.setWindowLayoutFullScreen(true)

  AppStorage.setOrCreate(YWConstants.kStorageAreas,area)

  // 获取设备的安全高度
  let safeArea = area.system

  //状态栏高度 返回时px
  let statusH = area.navigation_indicator.bottomRect.height

  let a = px2vp(statusH)

  // 顶部状态栏高度
  let statusBarHeight = px2vp(area.system.topRect.height) //这个的单位是px  将单位转换为VP,这个方法是px转vp

  // 底部安全高度
  let indicatorHeight = px2vp(area.navigation_indicator.bottomRect.height);

  //注意这是pv
  AppStorage.setOrCreate(YWConstants.kStatusBarHeight,statusBarHeight)
  AppStorage.setOrCreate(YWConstants.kSafeBottomHeight,indicatorHeight)

  windowObj.on("windowSizeChange", (value)=>{

    let newArea = getAvoidAreas(windowObj)
    AppStorage.setOrCreate(YWConstants.kStorageAreas,newArea)

  })

}

