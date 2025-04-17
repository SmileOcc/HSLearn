import { YWNavIDType, YWRouterNavParams } from "@learn/nav_router_har"

export interface ITabNavConfig {
  navPath: string
  navBuilder: WrappedBuilder<[YWNavIDType,YWRouterNavParams]>
}