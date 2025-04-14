import { YWLocalNavType } from "./YWNavType"
import { YWRouterNavParams } from "./YWRouterNavParams"
import { YWRouterWithContext } from "./YWRouterWithContext"

type RouteModel = "Standard" | "MoveToTop"
type RouteNavWay = "DefaultNav" | "CurrentNav" | YWLocalNavType

export class YWNavRouterInfoConfig {

  readonly uniqueId: number = -1
  routerWithContextCache?: YWRouterWithContext

  constructor(uniqueId:number) {
    this.uniqueId = uniqueId
  }

  targetUrl: string = ""
  targetUrlKey:string = ""
  targetParams: YWRouterNavParams = new YWRouterNavParams()

  isFromSession:boolean = true
  customSession?: Object | undefined

  routeNavWay: RouteNavWay = "DefaultNav"
  routeModel:RouteModel = "Standard"
  openAnimate:boolean = true
  clearStack:boolean = false

  uiContext?:UIContext

  popListener?:(params:YWRouterNavParams)=>void

  handleResult?:(result:YWNavResult)=>void

  getRouterContext(context?:UIContext):YWRouterWithContext{
    if (!this.routerWithContextCache) {
      let realContext = context ?? this.uiContext
      this.routerWithContextCache = new YWRouterWithContext(this.uniqueId,realContext)
    }
    return this.routerWithContextCache
  }
}

export enum YWNavResult {
  SUCCEED = "SUCCEED",
  FAILED = "FAILED",
  UNKNOWN = "UNKNOWN"
}