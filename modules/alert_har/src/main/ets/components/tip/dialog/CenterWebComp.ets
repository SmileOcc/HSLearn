import { CenterWebParm } from '../config/CenterWebParm'

/*
 * @Desc:中间网页显示的组件
 */
@Component
export struct CenterWebComp {
  @Consume webParm: CenterWebParm | undefined

  build() {
    if (this.webParm !== undefined) {
      Web({ src: this.webParm.url, controller: this.webParm.controller })
        .padding(15)
        .width('100%')
        .constraintSize({ maxHeight: '80%' })
        .attributeModifier(this.webParm.attrModifier)
    }
  }
}