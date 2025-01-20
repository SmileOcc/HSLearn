import { YWNavParamsKey } from "./YWNavType"

export class YWRouterWithContext {
  private readonly uniqueId:number = -1
  private readonly uiContext?:UIContext

  private navDestInfo?: NavDestinationInfo
  private navInfo?: NavigationInfo
  private navStack?: NavPathStack
  private url?: string
  private params?: Map<string,object>
  private session?: object

  constructor(uniqueId:number, uiContext?:UIContext) {
    this.uniqueId = uniqueId
    this.uiContext = uiContext ?? MainWindowUIContext
  }

  getNavInfo(): NavigationInfo | undefined {
    if (this.navInfo) {
      return this.navInfo
    }
    if (this.uniqueId == -1 || !this.uiContext) {
      //输出提示
      return undefined
    }

    let navInfo = this.uiContext.getNavigationInfoByUniqueId(this.uniqueId)
    if (navInfo) {
      this.navInfo = navInfo
    } else {
      //输出提示
    }
    return undefined
  }

  getNavDestInfo(): NavDestinationInfo | undefined {
    if (this.navDestInfo) {
      return this.navDestInfo
    }

    if (this.uniqueId == -1 || !this.uiContext) {
      //输出提示
      return undefined
    }

    let navInfo = this.uiContext.getPageInfoByUniqueId(this.uniqueId).navDestinationInfo
    if (navInfo) {
      this.navDestInfo = navInfo
    } else {
      //输出提示
    }
    return undefined
  }

  getNavStackInfo(): NavPathStack | undefined {
    if (this.navStack) {
      return this.navStack
    }

    if (this.uniqueId == -1 || !this.uiContext) {
      //输出提示
      return undefined
    }
    let navStack = this.getNavInfo()?.pathStack
    if (navStack) {
      this.navStack = navStack
    } else {

    }
    return undefined
  }

  getUrl():string|undefined {
    if (this.url) {
      return this.url
    }
    let currentUrl = this.getNavDestInfo()?.name as string

    return currentUrl
  }

  getParms():Map<string,object> {
    if (this.params) {
      return this.params
    }
    let parm = this.getNavDestInfo()?.param as Map<string,object>
    return parm ?? new Map()
  }

  getSession<T>(context:UIContext): T | undefined{
    if (this.session) {
      return this.session as T
    }
    let currentSession: T | undefined = undefined
    try {
      currentSession = this.getParms().get(YWNavParamsKey.SESSION) as T | undefined
    } catch (e) {
    }
    return currentSession
  }


  getNavId(): string | undefined {
    let cid = this.getNavInfo()?.navigationId
    return cid
  }

}

let MainWindowUIContext: UIContext | undefined = undefined

export function injectMainContext(uiContext?: UIContext) {
  MainWindowUIContext = uiContext
}