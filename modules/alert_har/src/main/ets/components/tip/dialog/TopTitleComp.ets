import { TopTitleParm } from '../config/TopTitleParm'

/*
 * @Desc: 弹框标题的显示组件
 */
@Preview
@Component
export struct TopTitleComp {
  @Consume titleParm: TopTitleParm | undefined

  build() {
    if (this.titleParm !== undefined) {
      Text(this.titleParm.title)
        .fontSize(14)
        .padding({ top: 20, bottom: 15 })
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Center)
        .fontColor('#666666')
        .width('100%')
        .attributeModifier(this.titleParm.attrModifier)
    }
  }
}