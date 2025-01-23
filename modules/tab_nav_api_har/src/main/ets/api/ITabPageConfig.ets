import { ITabBottomBarConfig } from "../config/ITabBottomBarConfig"
import { ITabNavConfig } from "../config/ITabNavConfig"
import { ITabAction } from "./ITabAction"

export interface ITabPageConfig {
  getTabKey():string

  getTabNavConfig():ITabNavConfig

  getTabBottomBarConfig():ITabBottomBarConfig

  getTabAction():ITabAction
}