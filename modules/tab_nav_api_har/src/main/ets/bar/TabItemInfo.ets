import { YWResColor, YWResImage } from "@learn/res_har"
import { ITabAction } from "../api/ITabAction"

export class TabItemInfo {
  cid?:string
  selectImage?:ResourceStr
  normalImage?:ResourceStr
  title:string = ""
  isSelected:boolean = false
  badgeNum:number = 0

  index:number = 0
  navType:string = ""
  navPath:string = ""

  tabActionProxy?: ITabAction

  titleColor():ResourceColor {
    return this.isSelected ? YWResColor.themeColor() : YWResColor.tabNormalColor()
  }

  itemImage():ResourceStr {
    return (this.isSelected ? this.selectImage : this.normalImage) ?? YWResImage.appIcon()
  }
}