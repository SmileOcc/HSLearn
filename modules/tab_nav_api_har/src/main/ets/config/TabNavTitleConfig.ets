import { ITabNavTitleConfig } from "./ITabNavTitleConfig"

@Observed
export class TabNavTitleConfig implements ITabNavTitleConfig {
  hideNavBar?: boolean
  title?:string
  backInfo: NavBackInfo = new NavBackInfo()
  userAvatarInfo:NavAvatarInfo = new NavAvatarInfo(false,undefined)
  titleInfo: NavTitleInfo = new NavTitleInfo("")
  subTitleInfo: NavTitleInfo = new NavTitleInfo("")
  rightMenuInfos: NavMenuInfo = new NavMenuInfo()
}

@Observed
export class NavBackInfo {
  isShow?: boolean
  icon?:ResourceStr
  onClick?:()=>void
}

@Observed
export class NavAvatarInfo {
  isShow?: boolean
  icon?:ResourceStr
  onClick?:()=>void

  constructor(isShow:boolean, icon?:ResourceStr, click?:()=>void) {
    this.isShow = isShow;
    this.icon = icon
    this.onClick = click
  }
}

@Observed
export class NavTitleInfo {
  title?: string
  onClick?:()=>void
  constructor(title:string, click?:()=>void) {
    this.title = title;
    this.onClick = click
  }
}

@Observed
export class NavMenuInfo {

  wrapItemBuilder?:WrappedBuilder<[object]>[]
  wrapCustomBuilder?:WrappedBuilder<[object]>
}