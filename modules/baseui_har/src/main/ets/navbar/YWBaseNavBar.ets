import { YWConstants } from "@learn/constants_har"
import { YWResColor } from "@learn/res_har"


@Component
export struct YWBaseNavBar {

  @State title: string | undefined = undefined

  @State navBarColor?: string = undefined

  @State isExpandSafeArea: boolean = false

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


  //外部传入这个，方法内部能使用self,因为这个已经是navbar了
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
    if (this.isExpandSafeArea) {
      Stack({alignContent: Alignment.BottomStart}){
        Row(){
          this.leftLayout()
          this.centerLayout()
          this.rightLayout?.()
        }
        .height(this.navHeight)
        .alignItems(VerticalAlign.Center)
        .padding({left:16, right: 16})
      }
      .backgroundColor(this.navBarColor ?? Color.White)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    } else  {
      Row(){
        this.leftLayout()
        this.centerLayout()
        this.rightLayout?.()
      }
      .backgroundColor(this.navBarColor ?? Color.White)
      .height(this.navHeight)
      .alignItems(VerticalAlign.Center)
      .padding({left:16, right: 16})
    }
  }

}