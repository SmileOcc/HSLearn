import { BottomBtnParm } from './BottomBtnParm'
import { CenterTextParm } from './CenterTextParm'
import { TopTitleParm } from './TopTitleParm'
import { CenterWebParm } from './CenterWebParm'

/*
 * @Desc: 全局初始化时的样式和配置。
 */
export interface TipStyle {
  /**
   * 点击外面区域是否可以取消，默认 true。
   */
  outsideCancel?: boolean
  /**
   * 点击系统返回键可以取消吗，默认 true。
   */
  pressBackCancel?: boolean
  /**
   * 位置
   */
  alignment?: Alignment
  /**
   * 标题的样式
   */
  titleParm?: TopTitleParm
  /**
   * text加载内容的样式
   */
  textParm?: CenterTextParm
  /**
   * web加载内容的样式
   */
  webParm?: CenterWebParm
  /**
   * 底部按钮的样式
   */
  btnParm?: BottomBtnParm
  /**
   * 最外层UI的样式，通过该属性设置对话框的背景颜色、圆角、距离屏幕的距离等。
   */
  outBoxAttr?: AttributeModifier<ColumnAttribute>
  /**
   * 标题下面的线条样式
   */
  lineStyleTop?: AttributeModifier<LineAttribute>
  /**
   * 内容下面的线条样式
   */
  lineStyleBottom?: AttributeModifier<LineAttribute>
}