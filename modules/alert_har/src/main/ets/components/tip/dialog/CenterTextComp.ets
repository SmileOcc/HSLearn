import { CenterTextParm } from '../config/CenterTextParm'


/*
 * @Desc: 中间文本显示的组件
 */
@Component
export struct CenterTextComp {
  @Consume textParm: CenterTextParm | undefined

  build() {
    if (this.textParm !== undefined) {
      Scroll() {
        Text(this.textParm.content)
          .fontSize(18)
          .padding(15)
          .textAlign(TextAlign.Center)
          .fontColor('#2c2c2c')
          .attributeModifier(this.textParm.attrModifier)
      }
      .width('100%')
      .constraintSize({ maxHeight: '80%' })
    }
  }
}