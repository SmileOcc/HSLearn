import { OSRouteConfig } from './OsRouteConfig'
import { OsRouterListener } from './OsRouterListener'
import { List } from '@kit.ArkTS'
import { RouterInvokePromise } from './OsRouter'
import { OsRouterAction } from './OsRouterAction'

export  class OsRouterManager {

  invokeMap:Map<string,RouterInvokePromise> = new Map()
  listeners:List<OsRouterListener> = new List()

  bandRouterName(routeName:string,invoke:RouterInvokePromise) {
    this.invokeMap.set(routeName,invoke)
  }

  start(config:OSRouteConfig) {

    //处理
    this.realStart(config)

  }

  back(config:OSRouteConfig) {

  }

  realStart(config:OSRouteConfig) {

    if (config.routeWay == "Push") {
      this.routePush(config)
    }

    if (config.routeWay == "Replace") {
      this.routeReplace(config)
    }
  }

  routePush(config:OSRouteConfig) {
    let routeName = config.targetHostUrl
    let invokeProm = this.currentInvoke(routeName)
    if (invokeProm) {
      invokeProm().then((value)=>{

        let osAction = new OsRouterAction()
        osAction.jumpPush(config)
      })
    }
  }

  routeReplace(config:OSRouteConfig) {
    let routeName = config.targetHostUrl
    let invokeProm = this.currentInvoke(routeName)
    if (invokeProm) {
      invokeProm().then(()=>{
        let osAction = new OsRouterAction()
        osAction.jumpReplace(config)
      })
    }
  }

  onRegisterLister(lister:OsRouterListener):void {
    if (!this.listeners.has(lister)) {
      this.listeners.add(lister)
    }
  }

  onUnRegisterLister(lister:OsRouterListener) {
    if (this.listeners.has(lister)) {
      this.listeners.remove(lister)
    }
  }



  onListenerSuccess(config:OSRouteConfig) {
    this.listeners.forEach((value)=> {
      value.routerListenerSuccess(config)
    })
  }

  onListenerFail(config:OSRouteConfig, error:Error) {
    this.listeners.forEach((value)=>{
      value.routerListenerFail(config,error)
    })
  }

  private currentInvoke(routeName:string):RouterInvokePromise | undefined {
    if (this.invokeMap.has(routeName)) {
      return this.invokeMap.get(routeName)
    }
    return undefined
  }


}

export const osRouterManager = new OsRouterManager()