import {
  ITabNavParams,
  ITabNavTitleConfig, NavAvatarInfo, NavBackInfo, NavMenuInfo, NavTitleInfo } from "@learn/tab_nav_api_har";

export class HomeNavTitleImp implements ITabNavTitleConfig {
  hideNavBar?: boolean
  title?:string
  backInfo?: NavBackInfo
  userAvatarInfo?:NavAvatarInfo
  titleInfo?: NavTitleInfo
  subTitleInfo?: NavTitleInfo
  rightMenuInfos?: NavMenuInfo
  customNavBuilder?:WrappedBuilder<[ITabNavParams]>

  constructor(hideNavBar?:boolean,
    title?: string,
    backInfo?: NavBackInfo,
    userAvatarInfo?: NavAvatarInfo,
    titleInfo?: NavTitleInfo,
    subTitleInfo?:NavTitleInfo,
    rightMenuInfos?:NavMenuInfo) {

    this.hideNavBar = hideNavBar
    this.backInfo = backInfo
    this.title = title
    this.userAvatarInfo = userAvatarInfo
    this.titleInfo = titleInfo
    this.subTitleInfo = subTitleInfo
    this.rightMenuInfos = rightMenuInfos
  }

}