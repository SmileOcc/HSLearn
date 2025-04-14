import { ywNavManager } from "./YWNavManager"
import { YWNavResult, YWNavRouterInfoConfig } from "./YWNavRouteInfoConfig"
import { YWLocalNavType, YWNavParamsKey } from "./YWNavType"
import { YWRouterNavParams } from "./YWRouterNavParams"

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

    ywNavManager.go(this.config)
  }

  back() {
    ywNavManager.back(this.config)
  }

}