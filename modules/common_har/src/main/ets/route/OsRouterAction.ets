import { OSRouteConfig } from './OsRouteConfig';
import { router } from '@kit.ArkUI';
import { osRouterManager } from './OsRouterManager';

export class OsRouterAction {

  jumpPush(config:OSRouteConfig) {
    let routeName = config.targetHostUrl
    let params = config.targetParams

    let routeWay = config.routeWay
    let routeModel = config.routeMode == "Standard" ? router.RouterMode.Standard : router.RouterMode.Single
    let uiContext = config.uiContext

    if (uiContext) {
      uiContext.getRouter().pushNamedRoute({
        name:routeName,
        params:params
      },routeModel).then(()=>{
        osRouterManager.onListenerSuccess(config)
      }).catch((err:Error)=> {
        osRouterManager.onListenerFail(config,err)
      })

    } else {
      router.pushNamedRoute({
        name:routeName,
        params:params
      },routeModel).then(()=>{
        osRouterManager.onListenerSuccess(config)
      }).catch((err:Error)=> {
        osRouterManager.onListenerFail(config,err)
      })
    }
  }

  jumpReplace(config:OSRouteConfig) {
    //todo 待完成 替换
  }

  back(config:OSRouteConfig) {
    let uiContext = config.uiContext
    if (uiContext) {
      uiContext.getRouter().back()
    } else {
      router.back()
    }
  }
}