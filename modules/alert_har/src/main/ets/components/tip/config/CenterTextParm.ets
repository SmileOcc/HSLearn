/*
 * @Desc: 中间text参数。
 */
export class CenterTextParm {
  content: string
  attrModifier: AttributeModifier<TextAttribute>;

  constructor(content: string, attrModifier: AttributeModifier<TextAttribute> = {}) {
    this.content = content;
    this.attrModifier = attrModifier;
  }
}
