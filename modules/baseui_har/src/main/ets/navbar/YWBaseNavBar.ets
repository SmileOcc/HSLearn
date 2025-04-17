import { YWConstants } from "@learn/constants_har"
import { YWResColor } from "@learn/res_har"


@Component
export struct YWBaseNavBar {

  @State title: string | undefined = undefined

  @Watch('windowPointChange')
  @StorageProp(YWConstants.kCurrentBreakpoint) currentBreakpoint: string = 'sm'

  @State navHeight: number = this.getNavBarHeight()
  titleAttrModifier: AttributeModifier<TextAttribute> = {}; //标题控件的样式

  windowPointChange() {
    this.navHeight = this.getNavBarHeight()
  }
  getNavBarHeight(): number {
    let currentPoint = AppStorage.get(YWConstants.kCurrentBreakpoint) as string
    if (currentPoint == 'sm') {
      return YWConstants.kMainNavSM
    }
    return YWConstants.kMainNavMD
  }


  @BuilderParam
  leftLayout:()=>void = this.defaultBack

  @BuilderParam
  centerLayout:()=>void = this.defaultCenterTitle

  @BuilderParam
  rightLayout?:()=>void

  defaultGoBack?:()=>void



  @Builder
  defaultBack() {
    Image($r('app.media.arrow_left'))
      .width(20)
      .height(20)
      .onClick(() => {
        this.defaultGoBack?.()
      })
  }

  @Builder
  defaultCenterTitle() {
    Text(this.title)
      .textAlign(TextAlign.Center)
      .fontColor(YWResColor.themeColor())
      .fontWeight(FontWeight.Medium)
      .ellipsisMode(EllipsisMode.END)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(1)
      .layoutWeight(1)
      .attributeModifier(this.titleAttrModifier)
  }

  build() {
    Row(){
      this.leftLayout()
      this.centerLayout()
      this.rightLayout?.()
    }
    .backgroundColor(Color.White)
    .height(this.navHeight)
    .alignItems(VerticalAlign.Center)
    .padding({left:16, right: 16})
  }

}