import { List } from '@kit.ArkTS'
import { OsRouterListener } from './OsRouterListener'

export type osRouteModel = "Standard" | "Single"
export type osRouteWay = "Push" | "Replace"

export class OSRouteConfig {

  targetUrl:string = ""
  targetHostUrl:string = ""
  targetParams:Map<string,Object> = new Map()

  uiContext?:UIContext

  currentPageUrl:string = ""
  currentPageHostUrl:string = ""
  currentPageParams:Map<string,Object> = new Map()
  currentPageLinsteners:List<OsRouterListener> = new List()

  routeMode:osRouteModel = "Standard"
  routeWay:osRouteWay = "Push"
}