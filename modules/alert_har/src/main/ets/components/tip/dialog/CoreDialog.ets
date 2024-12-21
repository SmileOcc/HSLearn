import { BottomBtnComp } from './BottomBtnComp'
import { CenterTextComp } from './CenterTextComp'
import { TopTitleComp } from './TopTitleComp'
import { CenterWebComp } from './CenterWebComp'

@Component
export struct CoreDialog {
  @State lineStyleTop: AttributeModifier<LineAttribute> = {};
  @State lineStyleBottom: AttributeModifier<LineAttribute> = {};
  @State outBoxAttr: AttributeModifier<ColumnAttribute> = {};

  build() {
    Column() {
      //标题
      TopTitleComp()
      //分割线
      Line().lineStyle().attributeModifier(this.lineStyleTop)
      //内容
      CenterWebComp()
      CenterTextComp()
      //分割线
      Line().lineStyle().attributeModifier(this.lineStyleBottom)
      //按钮
      BottomBtnComp()
    }
    .margin(40)
    .borderRadius(12)
    .backgroundColor(Color.White)
    .attributeModifier(this.outBoxAttr)
  }
}

@Extend(Line)
function lineStyle() {
  .backgroundColor('#E6E6E6')
  .width('100%')
  .height(px2vp(2))
}