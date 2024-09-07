import { OSRouteConfig } from './OsRouteConfig'

export interface IOSRouterListener {

  routerListenerSuccess(config:OSRouteConfig):void

  routerListenerFail(config:OSRouteConfig,error:Error):void
}