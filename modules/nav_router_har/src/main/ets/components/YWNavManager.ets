import { hsLog } from "@learn/logger_har/src/main/ets/core/YWLogger"
import { ywInterManager } from "./intercept/YWInterManager"
import { YWNavConfig } from "./YWNavConfig"
import { YWNavPath } from "./YWNavPath"
import { YWNavResult, YWNavRouterInfoConfig } from "./YWNavRouteInfoConfig"
import { CustomerNavAnimation, YWNavCustomIDType, YWNavIDType, YWNavParams,
  YWNavParamsKey,
  YWLocalNavType} from "./YWNavType"

//路由管理(推荐，有点复杂）：方式一 注册管理格模块
const TAG = "YWNavManager"
export class YWNavManager {
  private static readonly routerNavConfigMap:Map<YWNavIDType,YWNavConfig> = new Map()
  private static readonly customNavConfigMap:Map<YWNavCustomIDType,YWNavConfig> = new Map()

  private static readonly routePathWithRouteType:Map<string,YWNavIDType> = new Map()
  private static readonly routeNameBuilderTable:Map<YWNavIDType,WrappedBuilder<[string,YWNavParams]>> = new Map()
  // private static readonly routeNameBuilderTable:Map<YWNavIDType,WrappedBuilder<[YWNavParams]>> = new Map()

  private static readonly animationNavMap:Map<YWNavIDType,CustomerNavAnimation> = new Map()

  constructor() {
    //1
    this.registerLocalNav(YWLocalNavType.NAV_ROOT,undefined,"xxx",new Map())

    //2
    this.registerLocalNav(YWLocalNavType.NAV_ROOT_MAIN_NAV, YWLocalNavType.NAV_ROOT, YWNavPath.root_main_nav,new Map())
    this.registerLocalNav(YWLocalNavType.NAV_ROOT_LOGIN_NAV, YWLocalNavType.NAV_ROOT, YWNavPath.root_login,new Map())
    this.registerLocalNav(YWLocalNavType.NAV_ROOT_LEARN_SETTING, YWLocalNavType.NAV_ROOT, YWNavPath.root_setting,new Map())

    //TODO
    // this.registerLocalNav(YWLocalNavType.NAV_LION_MAIN_NAV, YWLocalNavType.NAV_ROOT, YWNavPath.root_lion_nav, new Map())

    //3
    this.registerLocalNav(YWLocalNavType.NAV_ROOT_MAIN_TAB, YWLocalNavType.NAV_ROOT_MAIN_NAV, YWNavPath.main_tab_nav, new Map())


    //4


    this.registerLocalNav(YWLocalNavType.NAV_MAIN_HOME, YWLocalNavType.NAV_ROOT_MAIN_TAB, YWNavPath.main_tab_home, new Map())
    this.registerLocalNav(YWLocalNavType.NAV_MAIN_CATEGORY, YWLocalNavType.NAV_ROOT_MAIN_TAB, YWNavPath.main_tab_category, new Map())
    this.registerLocalNav(YWLocalNavType.NAV_MAIN_CAR, YWLocalNavType.NAV_ROOT_MAIN_TAB, YWNavPath.main_tab_car, new Map())
    this.registerLocalNav(YWLocalNavType.NAV_MAIN_MINE, YWLocalNavType.NAV_ROOT_MAIN_TAB, YWNavPath.main_tab_mine, new Map())

    //lion
    this.registerLocalNav(YWLocalNavType.NAV_LION_MAIN_NAV, YWLocalNavType.NAV_ROOT_MAIN_TAB, YWNavPath.root_lion_nav, new Map())
    this.registerLocalNav(YWLocalNavType.NAV_LION_MAIN_TAB_NAV,undefined,YWNavPath.root_lion_tab_nav, new Map())

    //demo
    this.registerLocalNav(YWLocalNavType.NAV_DEMO_MAIN_NAV, YWLocalNavType.NAV_ROOT_MAIN_TAB, YWNavPath.root_demo_tab_nav, new Map())

    // this.registerLocalNav(YWLocalNavType.NAV_LION_HOME_NAV, YWLocalNavType.NAV_COMMON_TAB, YWNavPath.lion_tab_home, new Map())
    // this.registerLocalNav(YWLocalNavType.NAV_LION_NEWS_NAV, YWLocalNavType.NAV_COMMON_TAB, YWNavPath.lion_tab_news, new Map())
    // this.registerLocalNav(YWLocalNavType.NAV_LION_ME_NAV, YWLocalNavType.NAV_COMMON_TAB, YWNavPath.lion_tab_me, new Map())


  }

  registerLocalNav(
    nav:YWLocalNavType,
    superNav:YWLocalNavType | undefined,
    path:YWNavPath | string,
    params:YWNavParams) {

    const config = new YWNavConfig(nav,superNav,path,params)
    YWNavManager.routerNavConfigMap.set(nav,config)
    if (superNav) {
      YWNavManager.routePathWithRouteType.set(path,superNav)
    }
  }

  registerCustomNav(
    nav:YWNavCustomIDType,
    superNav:YWLocalNavType | undefined,
    path:YWNavPath | string,
    params:YWNavParams) {

    if (YWNavManager.customNavConfigMap.has(nav)) {

      return
    }

    const config = new YWNavConfig(nav,superNav,path,params)
    YWNavManager.customNavConfigMap.set(nav,config)
    if (superNav) {
      YWNavManager.routePathWithRouteType.set(path,superNav)
    }
  }

  unregisterCustomNav(nav:YWNavCustomIDType) {
    YWNavManager.customNavConfigMap.delete(nav)
  }

  addCustomAnimation(nav:YWNavIDType, animation:CustomerNavAnimation) {
    YWNavManager.animationNavMap.set(nav,animation)
  }
  getBuilderWithPageID(nav:YWNavIDType):(path:string)=>WrappedBuilder<[string,YWNavParams]> | undefined {
    return (path: string) => {
      return YWNavManager.routeNameBuilderTable.get(path)
    }
  }

  private isLocalNavType(type:YWNavIDType):boolean {
    return Object.values<YWLocalNavType>(YWLocalNavType).includes(type as YWLocalNavType)
  }

  getNavStack(type:YWNavIDType):NavPathStack|undefined {
    let navConfig = this.getNavConfigWithType(type)
    if (navConfig) {
      return navConfig.navPathStack
    }
    return undefined

  }


  getNavConfigWithPath(path: string): YWNavConfig | undefined {
    let config = YWNavManager.routePathWithRouteType.get(path)
    if (config) {
      return  this.getNavConfigWithType(config as YWNavIDType)
    }
    return undefined
  }

  getNavConfigWithType(navType:YWNavIDType):YWNavConfig | undefined {
    if (!this.isLocalNavType(navType)) {
      let customConfig = YWNavManager.customNavConfigMap.get(navType)
      if (customConfig) {
        return customConfig
      } else {
        return undefined
      }
    }

    let navConfig = YWNavManager.routerNavConfigMap.get(navType)
    return navConfig
  }


  getTargetRouteNavConfig(config:YWNavRouterInfoConfig):YWNavConfig | undefined {

    let currentNavWay = config.routeNavWay
    if (currentNavWay == "CurrentNav") {
      if (config.uniqueId === -1) {
        currentNavWay = "DefaultNav"
      } else if (config.getRouterContext()?.getNavId() === undefined || config.getRouterContext()?.getNavId() === "") {
        currentNavWay = "DefaultNav"
      }
    }

    if (currentNavWay == "CurrentNav")  {
      return this.getNavConfigWithType(config.getRouterContext().getNavId() as YWNavIDType)
    } else  if(currentNavWay == "DefaultNav") {
      return this.getNavConfigWithPath(config.targetUrl ?? "")
    } else {
      return this.getNavConfigWithType(currentNavWay)
    }
  }

  boundName(nav:YWNavIDType, path:string, builder:WrappedBuilder<[string,YWNavParams]>) {
  // boundName(nav:YWNavIDType, path:string, builder:WrappedBuilder<[YWNavParams]>) {
    YWNavManager.routePathWithRouteType.set(path,nav)
    // YWNavManager.routeNameBuilderTable.set(nav,builder)
    YWNavManager.routeNameBuilderTable.set(path,builder)


  }

  back(ezConfig:YWNavRouterInfoConfig) {
    ywInterManager.transformBack(ywInterManager.transformGeneral(ezConfig),(ezConfig)=>{//TODO
      ezConfig.getRouterContext()?.getNavStackInfo()?.pop(ezConfig.targetParams,ezConfig.openAnimate)
    })
  }

  go(config:YWNavRouterInfoConfig) {
    if (config.uniqueId == -1 || config.targetUrl === undefined) {
      return
    }

    let ezConfig = ywInterManager.transformGeneral(config)
    let jumpInter = ywInterManager.findTransformJump(config)

    //是否拦截处理
    if (jumpInter != undefined) {
      jumpInter.jump(ezConfig).then(()=>{
        this.handResult(config,YWNavResult.SUCCEED)
      }).catch(()=> {
        this.handResult(config,YWNavResult.FAILED)
      })
    } else {
      //继续执行
      let result = this.realGo(config)
      this.handResult(config,result)
    }
  }

  realGo(config:YWNavRouterInfoConfig):YWNavResult {

    //获取目标路由，是否可以跳转
    let navConfig = this.getTargetRouteNavConfig(config)
    if (!navConfig || !YWNavManager.routeNameBuilderTable.has(config.targetUrl)) {
      return YWNavResult.UNKNOWN
    }

    if (config.clearStack) {
      navConfig.navPathStack.clear()
    }

    let eventBlock = ()=> {
      if (navConfig) {
        config.openAnimate = false
        this.pushNavWithMode(config,navConfig)

      }
    }

    if (!navConfig?.verIsTopNav(eventBlock,config.customSession,config.openAnimate)) {

      try {
        this.pushNavWithMode(config,navConfig)
        YWNavResult.SUCCEED
      } catch (e) {
        YWNavResult.FAILED
      }
    }

    return YWNavResult.SUCCEED
  }

  pushNavWithMode(config:YWNavRouterInfoConfig, navConfig:YWNavConfig) {
    if (config.routeModel === "Standard") {
      this.pushNavStandardWith(config,navConfig)
    } else if (config.routeModel === "MoveToTop") {
      this.pushNavWithMoveToTop(config,navConfig)
    }
  }

  pushNavStandardWith(config:YWNavRouterInfoConfig, navConfig:YWNavConfig) {

    let params = config.targetParams as YWNavParams
    let listenerPop = config.popListener as (params:YWNavParams)=>void

    if (config.targetUrlKey) {
      params.set(YWNavParamsKey.NAV_ULR_KEY,config.targetUrlKey)
    }
    if (config.customSession) {
      params.set(YWNavParamsKey.SESSION,config.customSession)
    }

    if (listenerPop) {
      navConfig.navPathStack.pushPathByName(config.targetUrl,params,(popInfo)=> {
        listenerPop(popInfo.result as YWNavParams)
        //页面出栈时获取返回信息
        hsLog.i(TAG,'Pop page name is: ' + popInfo.info.name + ', result: ' + JSON.stringify(popInfo.result))

      },config.openAnimate)

    } else  {
      navConfig.navPathStack
      navConfig.navPathStack.pushPathByName(config.targetUrl,params,config.openAnimate)
    }
  }

  pushNavStandardWithParams(
    navStack:NavPathStack,
    targetUrl:string,
    params:YWNavParams,
    targetUniqueKey?:string,
    session?:Object,
    openAnimate?:boolean,
    popListener?:(params:YWNavParams)=>void) {


    if (targetUniqueKey) {
      params.set(YWNavParamsKey.NAV_ULR_KEY,targetUniqueKey)
    }
    if (session) {
      params.set(YWNavParamsKey.SESSION,session)
    }

    if (popListener) {
      navStack.pushPathByName(targetUrl, params,(popInfo)=> {
        popListener(popInfo.result as YWNavParams)
        //页面出栈时获取返回信息
        hsLog.i(TAG,'Pop page name is: ' + popInfo.info.name + ', result: ' + JSON.stringify(popInfo.result))

      },openAnimate)

    } else  {
      navStack.pushPathByName(targetUrl,params,openAnimate)
    }
  }

  pushNavWithMoveToTop(config:YWNavRouterInfoConfig, navConfig:YWNavConfig){

    let indexStacks = navConfig.navPathStack.getIndexByName(config.targetUrl)

    const findIndex = (pagesList:Array<number>):number=> {

      //TODO
      if (config.targetUrlKey) {
        let reverseList = pagesList.reverse()
        for (let i=0; i< reverseList.length; i++) {

          let params = navConfig.navPathStack.getParamByIndex(i) as YWNavParams
          if (params) {
            let urlKey = params.get(YWNavParamsKey.NAV_ULR_KEY) as string ?? "-1000"
            if (config.targetUrlKey === urlKey) {
              return i
            }
          }
        }

      } else {
        return pagesList.length - 1
      }
      return -1
    }

    const resultIndex = findIndex(indexStacks)
    if (resultIndex == -1) {
      this.pushNavStandardWith(config,navConfig)
    } else {
      navConfig.navPathStack.moveIndexToTop(resultIndex,config.openAnimate)
    }
  }

  handResult(config:YWNavRouterInfoConfig, result:YWNavResult) {
    if (config.handleResult) {
      config.handleResult(result)
    }
  }

}

export const ywNavManager = new YWNavManager()