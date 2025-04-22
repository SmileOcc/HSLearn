
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

  titleColor():ResourceColor

  itemImage():ResourceStr
}