/*
 * @Desc: 控制标题的样式和内容。
 */
export class TopTitleParm {
  title: string
  noTitle: boolean = false;
  attrModifier: AttributeModifier<TextAttribute>;

  constructor(title: string = '温馨提示', attrModifier: AttributeModifier<TextAttribute> = {}) {
    this.title = title
    this.attrModifier = attrModifier
  }

  setNoTitle() {
    this.noTitle = true;
    return this;
  }
}
