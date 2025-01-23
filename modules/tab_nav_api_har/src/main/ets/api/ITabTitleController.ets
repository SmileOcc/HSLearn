import { ITabNavConfig } from "../config/ITabNavConfig"

export interface ITabTitleController {
  //TODO
  componentBuilder?:WrappedBuilder<[]>
  navConfig:ITabNavConfig

  updateTitleInfo(tabNavInfo:object):void
}