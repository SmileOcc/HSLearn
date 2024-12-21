/*
 * @Desc:
 */

export interface YWLoadingStyle {
  /**
   * 位置，默认居中。
   */
  alignment?: Alignment
  /**
   * 点击系统返回键可以取消吗，默认 true。
   */
  pressBackCancel?: boolean
  /**
   * 点击外面区域是否可以取消，默认 false。
   */
  outsideCancel?: boolean
  /**
   * 自定loading 动画布局
   */
  layout?: WrappedBuilder<[object]>;

  /**
   * 最外层UI的样式，设置背景深度等
   */
  outBoxAttr?: AttributeModifier<StackAttribute>
}