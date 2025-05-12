import { ITabAction } from "../api/ITabAction"

export interface ITabBottomBarConfig {
  cid: string
  image?: ResourceStr
  selectImage?: ResourceStr
  title: ResourceStr
  selectColor?: ResourceColor
  normalColor?: ResourceColor
  badge?: number
  navType:string
  navPath:string
  isSelected:boolean

  tabActionProxy?: ITabAction

  titleColor():ResourceColor
  itemImage():ResourceStr
}