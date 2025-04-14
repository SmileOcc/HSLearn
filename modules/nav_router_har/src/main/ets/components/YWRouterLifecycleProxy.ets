

export class YWRouterLifecycleImp implements YWRouterLifeCycleProxy {
  onShow?:()=>void
  onHide?:()=>void
  onDisappear?:()=>void

  pageOnShow() {
    this.onShow?.()
  }
  pageOnHide() {
    this.onHide?.()
  }
  pageOnDisappear() {
    this.onDisappear?.()
  }
  pageOnDestroy() {

  }

  setPageOnShow(black:()=>void) {
    this.onShow = black
  }

  setPageOnHide(black:()=>void) {
    this.onHide = black
  }
  setPageOnDisappear(black:()=>void) {
    this.onDisappear = black
  }
}

export interface YWRouterLifeCycleProxy {
  pageOnShow?():void
  pageOnHide?():void
  pageOnDisappear?():void
  pageOnDestroy?():void
}