/*
 * @Desc: 每一次弹窗需要的参数，提示框的参数。
 */
export interface TipParm {
  /**
   * 显示的内容，根据isWebType来显示web还是text。如果为 ''或undefined则去HintStyle里面的。
   */
  content: string
  /**
   * 标题，默认："温馨提示"
   */
  title?: string
  /**
   * 只有true时，不显示标题
   */
  noTitle?: boolean
  /**
   * 取消按钮的信息，默认："取消"
   */
  noMsg?: string
  /**
   * 确定按钮的信息，默认："确定"
   */
  okMsg?: string
  /**
   * 是否需要显示取消按钮，默认：true
   */
  showNo?: boolean
  /**
   * 是否是web类型，默认：false
   */
  isWebType?: boolean
  /**
   * web控制器，isWebType为true时有效。
   */
  controller?: WebviewController;

  /**
   * 点击系统返回键可以取消吗，默认 true。
   */
  pressBackCancel?: boolean

  /**
   * 点击外面区域是否可以取消，默认 true。
   */
  outsideCancel?: boolean
  /**
   * 点击"取消"的回调
   */
  onNo?: () => void
  /**
   * 点击"确定"的回调
   */
  onOk?: () => void
  /**
   * 位置，默认居中。
   */
  alignment?: Alignment
}