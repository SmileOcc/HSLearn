import { OSRouteConfig, osRouteModel, osRouteWay } from './OsRouteConfig'
import { OsRouterListener } from './OsRouterListener'
import { osRouterManager } from './OsRouterManager'

export class OsRoute {
  private routConfig:OSRouteConfig = new OSRouteConfig()

  constructor(url:string) {
    this.routConfig.targetUrl = url
    this.routConfig.targetHostUrl = url
  }

  onUIContext(context:UIContext):OsRoute {
    this.routConfig.uiContext = context
    return this
  }

  onWithWay(way:osRouteWay):OsRoute {
    this.routConfig.routeWay = way
    return this
  }

  onWithMode(mode:osRouteModel):OsRoute {
    this.routConfig.routeMode = mode
    return this
  }

  onWithParams(key:string, params:Object):OsRoute {
    this.routConfig.targetParams.set(key,params)
    return this
  }

  // onWithListener(lister:OsRouterListener):OsRoute {
  //   this.routConfig.targetListeners.add(lister)
  //   return this
  // }

  go() {

    osRouterManager.start(this.routConfig)
  }
  back() {
    osRouterManager.back(this.routConfig)
  }

}