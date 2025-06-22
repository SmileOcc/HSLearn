import { ywNavManager } from "./YWNavManager"


export class YWRouterLifecycleImp implements YWRouterLifeCycleProxy {
  onShow?:()=>void
  onHide?:()=>void
  onDisappear?:()=>void
  onWillDisappear?:()=>void
  onBackPressed?:()=>boolean

  pageOnShow() {
    this.onShow?.()
  }
  pageOnHide() {
    this.onHide?.()
  }
  pageOnDisappear() {
    // if (ywNavManager.getFullScreenRouters())
    this.onDisappear?.()
  }
  pageOnWillDisappear() {
    this.onWillDisappear?.()
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
  setOnWillDisappear(black:()=>void) {
    this.onWillDisappear = black
  }
  setOnBackPressed(black:()=>boolean) {
    this.onBackPressed = black
  }
}

export interface YWRouterLifeCycleProxy {
  pageOnShow?():void
  pageOnHide?():void
  pageOnDisappear?():void
  pageOnDestroy?():void
  pageOnWillDisappear?():void
  onBackPressed?():boolean
}