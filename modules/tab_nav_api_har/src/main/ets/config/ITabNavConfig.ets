import { YWNavIDType, YWRouterNavParams } from "@learn/nav_router_har"

export interface ITabNavConfig {
  hideNavBar?: boolean
  navPath: string
  navBuilder: WrappedBuilder<[YWNavIDType,YWRouterNavParams]>
}