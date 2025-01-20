import { ywNavManager, YWNavManager } from "./YWNavManager"
import { YWNavRouterInfoConfig } from "./YWNavRouteInfoConfig"
import { YWNavIDType, YWNavParams, YWLocalNavType } from "./YWNavType"

type act = ()=>void

export class YWNavConfig {
  routeNav:YWNavIDType
  superNav:YWNavIDType |undefined
  path:string
  params:YWNavParams
  navPathStack:NavPathStack

  constructor(
    nav: YWNavIDType,
    superNav: YWNavIDType | undefined,
    pathInit: string,
    paramsInit: YWNavParams) {

    this.routeNav = nav
    this.superNav = superNav
    this.path = pathInit
    this.params = paramsInit

    this.navPathStack = new NavPathStack()
  }

  //upser
  verIsTopNav(action:()=>void,session?:object, animation?:boolean):boolean {

    if (this.superNav) {
      let supNavConfig = ywNavManager.getNavConfigWithType(this.superNav)
      if (supNavConfig) {

        let returnAction = this.isMoveToReturnAction(supNavConfig.navPathStack,this.path, this.params,animation)

        if (returnAction) {
          action()

          if (!supNavConfig.verIsTopNav(returnAction,session,animation)) {//TODO

            let tAction = this.isMoveToReturnAction(supNavConfig.navPathStack,this.path,this.params,animation)
            if (tAction) {
              tAction()
            }
          }
          return true
        }

      } else {
        let superNavConfig = ywNavManager.getNavConfigWithType(this.superNav)
        return superNavConfig?.verIsTopNav(action,session,animation) ?? false
      }

    }
    return false
  }


  isMoveToReturnAction(superNav:NavPathStack, pageName:string, params:YWNavParams,  animation?:boolean): act | undefined{

    let index = superNav.getIndexByName(pageName)
    let size = superNav.size()
    if (index.length) {
      if (index[index.length - 1] !== size - 1) {
        return () => { superNav.moveIndexToTop(index[index.length - 1],animation)}
      }
    } else {
      return () => { ywNavManager.pushNavStandardWithParams(superNav,pageName,params) }
    }

    return undefined
  }
}

