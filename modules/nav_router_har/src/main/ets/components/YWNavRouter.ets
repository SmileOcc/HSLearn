import { YWBaseIntercept } from "./intercept/YWBaseIntercept";
import { YWBaseJumpIntercept } from "./intercept/YWBaseJumpIntercept";
import { ywInterManager, YWInterManager } from "./intercept/YWInterManager";
import { ywNavManager, YWNavManager } from "./YWNavManager";
import { YWNavRouterInfo } from "./YWNavRouteInfo";
import { YWNavRouterInfoConfig } from "./YWNavRouteInfoConfig";
import { CustomerNavAnimation, YWNavCustomIDType, YWNavIDType, YWLocalNavType } from "./YWNavType";
import { YWRouterNavParams } from "./YWRouterNavParams";

export interface NavRouterBuilder {
  name:string,
  builder:WrappedBuilder<[string,YWRouterNavParams]>
}

export class YWNavRouter {

  boundRoutePath(name: string, navPath: ()=>Promise<Object>) {
    ywNavManager.boundPath(name, navPath)
  }

  boundRouteName(nav:YWNavIDType, builder:NavRouterBuilder[]) {
    builder.forEach((item)=>{
      ywNavManager.boundName(nav,item.name,item.builder)
    })
  }

  registerCustomRoute(nav:YWNavCustomIDType,superNav:YWLocalNavType,path:string,params:YWRouterNavParams)  {
    ywNavManager.registerCustomNav(nav,superNav,path,params)

  }

  unregisterCustomRoute(nav:YWNavCustomIDType) {
    ywNavManager.unregisterCustomNav(nav)
  }

  openRoute(pageId:number):YWNavRouterInfo {
    return new YWNavRouterInfo(new YWNavRouterInfoConfig(pageId))
  }

  addIntercept(inter:YWBaseIntercept) {
    ywInterManager.addGeneral(inter)
  }

  addJumpIntercept(inter:YWBaseJumpIntercept) {
    ywInterManager.addJump(inter)
  }

  addJumpAnim(nav:YWNavIDType, animation:CustomerNavAnimation) {
    ywNavManager.addCustomAnimation(nav,animation)
  }

}

export const ywNavRouter = new YWNavRouter()