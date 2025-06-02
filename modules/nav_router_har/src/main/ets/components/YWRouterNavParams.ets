import { YWRouterLifecycleImp, YWRouterLifeCycleProxy } from "./YWRouterLifecycleProxy";

export type YWNavParams = Map<string, Object>

export class YWRouterNavParams {

  userSession?: Object | undefined
  userUniqueid?: string
  pageLifecycle?: YWRouterLifecycleImp
  params:YWNavParams = new Map()
  itemInfo?: object | undefined

  getPageLifecycleImp(): YWRouterLifecycleImp {
    if (!this.pageLifecycle) {
      this.pageLifecycle = new YWRouterLifecycleImp()
    }
    return this.pageLifecycle
  }

  getPageLifecycle(): YWRouterLifeCycleProxy {
    return this.getPageLifecycleImp()
  }


}