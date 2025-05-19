import { NavAvatarInfo, NavBackInfo, NavMenuInfo, NavTitleInfo } from "./TabNavTitleConfig"

export interface ITabNavParams {
  type?: string
  params?: Map<string,object>
}

export interface ITabNavTitleConfig {
  hideNavBar?: boolean
  title?:string
  backInfo?: NavBackInfo
  userAvatarInfo?:NavAvatarInfo
  titleInfo?: NavTitleInfo
  subTitleInfo?: NavTitleInfo
  rightMenuInfos?: NavMenuInfo
  customNavBuilder?:WrappedBuilder<[ITabNavParams]>
}