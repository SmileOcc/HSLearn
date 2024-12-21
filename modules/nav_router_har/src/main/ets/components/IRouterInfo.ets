
/*
 * @Desc: 每个路由页面的组成部分，为动态import，所以需要先import(moduleName)，然后再根据pageName来决定加载那个组件
 */
export interface IRouterInfo {
  moduleName: string //模块名称
  pageName: string //页面名称
  hasNavDest?: boolean //默认undefined， 而undefined和false表示该组件没有带 ：NavDestination。
}
