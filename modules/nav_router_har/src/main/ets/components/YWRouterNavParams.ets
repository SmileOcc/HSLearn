import { YWRouterLifecycleImp, YWRouterLifeCycleProxy } from "./YWRouterLifecycleProxy";

export class YWRouterNavParams {

  pageLifecycle?: YWRouterLifecycleImp

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