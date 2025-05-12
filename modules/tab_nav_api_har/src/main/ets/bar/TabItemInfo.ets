import { YWResColor, YWResImage } from "@learn/res_har"
import { ITabAction } from "../api/ITabAction"
import { ITabBottomBarConfig } from "../config/ITabBottomBarConfig"

export class TabItemInfo implements ITabBottomBarConfig {
  image?: ResourceStr
  selectImage?:ResourceStr
  selectColor?: ResourceColor | undefined
  normalColor?: ResourceColor
  badge?: number | undefined

  cid:string = ""
  title:string = ""
  isSelected:boolean = false

  index:number = 0
  navType:string = ""
  navPath:string = ""

  tabActionProxy?: ITabAction

  titleColor():ResourceColor {
    return this.isSelected ? YWResColor.themeColor() : YWResColor.tabNormalColor()
  }

  itemImage():ResourceStr {
    return (this.isSelected ? this.selectImage : this.image) ?? YWResImage.appIcon()
  }

}