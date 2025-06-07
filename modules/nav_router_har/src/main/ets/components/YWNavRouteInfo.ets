import { YWNavManager, ywNavManager } from "./YWNavManager"
import { YWNavResult, YWNavRouterInfoConfig } from "./YWNavRouteInfoConfig"
import { YWNavMode, YWLocalNavType, YWNavParamsKey } from "./YWNavType"
import { YWRouterNavParams } from "./YWRouterNavParams"
import { emitter } from "@kit.BasicServicesKit"
import { BreakpointTypeEnumValue } from "@learn/common_har"

export class YWNavRouterInfo {
  private config:YWNavRouterInfoConfig

  constructor(config:YWNavRouterInfoConfig) {
    this.config = config
  }

  onTargetUrl(url:string): YWNavRouterInfo {
    this.config.targetUrl = url
    return this
  }

  onUrlKey(key:string):YWNavRouterInfo {
    this.config.targetUrlKey = key
    return this
  }

  onItemInfo(itemInfo: object | undefined): YWNavRouterInfo {
    this.config.targetParams.itemInfo = itemInfo
    return this
  }

  onParams(key:string, params:Object):YWNavRouterInfo {
    this.config.targetParams.params.set(key,params)
    return this
  }

  onClearStack(clear:boolean):YWNavRouterInfo {
    this.config.clearStack = clear
    return this
  }

  onCustomSession(session:object):YWNavRouterInfo {
    this.config.isFromSession = false
    this.config.customSession = session
    return this
  }

  onRouteMode():YWNavRouterInfo {
    this.config.routeModel = "Standard"
    return this
  }

  onRouteMoveToTop():YWNavRouterInfo {
    this.config.routeModel = "MoveToTop"
    return this
  }

  onNavWayDefault():YWNavRouterInfo {
    this.config.routeNavWay = "DefaultNav"
    return this
  }

  onNavWayCurrent():YWNavRouterInfo {
    this.config.routeNavWay = "CurrentNav"
    return this
  }

  onNavWayNav(nav:YWLocalNavType):YWNavRouterInfo {
    this.config.routeNavWay = nav
    return this
  }

  onOpenAnimate():YWNavRouterInfo {
    this.config.openAnimate = true
    return this
  }

  onContext(context?:UIContext):YWNavRouterInfo {
    this.config.uiContext = context

    return this
  }

  onOpenAnimation(animation:boolean):YWNavRouterInfo {
    this.config.openAnimate = animation
    return this
  }

  onUiContext(uiContext:UIContext):YWNavRouterInfo {
    this.config.uiContext = uiContext
    return this
  }


  onPopListener(block:(params:YWRouterNavParams)=>void):YWNavRouterInfo {
    this.config.popListener = block
    return this
  }

  onNavResult(block:(params:YWNavResult)=>void):YWNavRouterInfo {
    this.config.handleResult = block
    return this
  }

  getNavConfig():YWNavRouterInfoConfig {
    return this.config
  }

  go() {

    // 记录当前进入路由名称
    AppStorage.setOrCreate('enterRouteName', this.config.targetUrl);
    // 定义事件3
    let innerEvent: emitter.InnerEvent = {
      eventId: 3
    };
    let eventData: emitter.EventData = {
      data: {
        navMode: YWNavMode.ChildPageMode
      }
    };
    // 触发EntryView下navMode改变
    emitter.emit(innerEvent, eventData);

    // 获取当前窗口宽度
    let windowSize = AppStorage.get("kStorageWidth") as number ?? 0;

    // 友盟进入案例埋点
    let enterCaseData: emitter.EventData = {
      data: {
        uri: this.config.targetUrl
      }
    };
    emitter.emit('enterCase', enterCaseData);
    // 宽屏条件下跳转
    if (windowSize > BreakpointTypeEnumValue.LG) {
      //YWNavManager.clear();
      if (YWNavManager.timer) {
        clearTimeout(YWNavManager.timer);
      }
      // Navigation的mode属性修改会有一段响应时间，需延时跳转
      // YWNavManager.timer = setTimeout(() => {
        ywNavManager.go(this.config)
      // }, 20);
    } else {
      ywNavManager.go(this.config)
    }

  }

  back() {
    ywNavManager.back(this.config)
  }

}