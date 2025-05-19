import { ITabNavTitleConfig, NavAvatarInfo, NavBackInfo, NavMenuInfo, NavTitleInfo } from "@learn/tab_nav_api_har";

export class MineNavTitleImp implements ITabNavTitleConfig {
  hideNavBar?: boolean
  title?:string
  backInfo?: NavBackInfo
  userAvatarInfo?:NavAvatarInfo
  titleInfo?: NavTitleInfo
  subTitleInfo?: NavTitleInfo
  rightMenuInfos?: NavMenuInfo

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