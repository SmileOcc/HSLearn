import { YWRouterNavParams } from "@learn/nav_router_har"
import { ITabBottomBarConfig } from "../config/ITabBottomBarConfig"
import { ITabNavConfig } from "../config/ITabNavConfig"
import { ITabNavTitleConfig } from "../config/ITabNavTitleConfig"
import { ITabAction } from "./ITabAction"

export interface ITabPageConfig {
  getTabKey():string

  getTabNavConfig():ITabNavConfig

  getTabBottomBarConfig():ITabBottomBarConfig

  getTabAction():ITabAction

  getNavTitleConfig(): ITabNavTitleConfig

  getTabNavParams(): YWRouterNavParams
}