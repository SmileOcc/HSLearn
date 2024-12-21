import { BottomBtnParm } from '../config/BottomBtnParm'

/*
 * @Desc: 底部两个按钮的控制组件
 */
@Component
export struct BottomBtnComp {
  @Consume btnParm: BottomBtnParm | undefined;

  build() {
    if (this.btnParm !== undefined) {
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        if (this.btnParm.showNo) {
          Text(this.btnParm.noMsg)
            .fontColor('#BDBDBD')
            .onClick(() => {
              this.btnParm?.onNo?.()
            })
            .btnStyles()
            .attributeModifier(this.btnParm.attrNoModifier)

          Line()
            .backgroundColor('#EEEEEE')
            .width(0.5)
            .height(30)
            .margin(10)
            .attributeModifier(this.btnParm.attrLineModifier)
        }
        Text(this.btnParm.okMsg)
          .fontColor('#A3282D')//对话框默认大圆角，可去掉
          .onClick(() => {
            this.btnParm?.onOk?.()
          })
          .btnStyles()
          .attributeModifier(this.btnParm.attrOkModifier)

      }
      .backgroundColor('#00FFFFFF')
      .height(50)
      .attributeModifier(this.btnParm.attrRootModifier)
    }
  }
}

@Extend(Text)
function btnStyles() {
  .fontSize(15)
  .textAlign(TextAlign.Center)
  .height('100%')
  .layoutWeight(1)
}