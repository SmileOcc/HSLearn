
export class HSSearchHistoryModel {
  cid?: string
  name: string
  // 路由信息，自动生成路由时，在自定义装饰器中AppRouter中配置的参数，使用新版本自动路由时需要添加此参数，用于动态路由的跳转。使用规则：模块名/需要加载的自定义组件名，如addressexchange/AddressExchangeView
  appUri: string
  // 路由传参数据
  param: string

  helperUrl?: string
  constructor(cid: string, name: string, appUri: string, param?: string, helperUrl?: string) {
    this.cid = cid
    this.name = name
    this.appUri = appUri;
    this.param = param === undefined ? '' : param;
    this.helperUrl = helperUrl
  }
}