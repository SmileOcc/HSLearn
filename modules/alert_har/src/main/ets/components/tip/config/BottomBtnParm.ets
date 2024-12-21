/*
 * @Desc: 底部两个按钮的控制组件的内容样式设置等
 * @OpenSource: https://github.com/xhunmon/ & https://gitee.com/qincji/
 */
export class BottomBtnParm {
  onNo?: () => void
  onOk?: () => void
  showNo: boolean = true
  noMsg: string = '取消'
  okMsg: string = '确定'
  attrNoModifier: AttributeModifier<TextAttribute> = {};
  attrOkModifier: AttributeModifier<TextAttribute> = {};
  attrLineModifier: AttributeModifier<LineAttribute> = {};
  attrRootModifier: AttributeModifier<FlexAttribute> = {};

  bOnNo(onNo: () => void) {
    this.onNo = onNo
    return this;
  }

  bOnOk(onOk: () => void) {
    this.onOk = onOk
    return this;
  }

  bShowNo(showNo: boolean) {
    this.showNo = showNo
    return this;
  }

  bOkMsg(okMsg: string) {
    this.okMsg = okMsg
    return this;
  }

  bNoMsg(noMsg: string) {
    this.noMsg = noMsg
    return this;
  }

  bAttrNoModifier(attrNoModifier: AttributeModifier<TextAttribute>) {
    this.attrNoModifier = attrNoModifier
    return this;
  }

  bAttrOkModifier(attrOkModifier: AttributeModifier<TextAttribute>) {
    this.attrOkModifier = attrOkModifier
    return this;
  }

  bAttrLineModifier(attrModifier: AttributeModifier<LineAttribute>) {
    this.attrLineModifier = attrModifier
    return this;
  }

  constructor(onNo?: () => void, onOk?: () => void) {
    this.onNo = onNo
    this.onOk = onOk
  }
}