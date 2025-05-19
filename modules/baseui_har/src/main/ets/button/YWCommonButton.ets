/*
 * @Desc: 统一样式的按钮样式
 */

import { hsGlobalThis } from '@learn/common_har';
import { YWResColor,YWResFloat } from '@learn/res_har';

@Component
export struct YWCommonButton {
  @Prop text: string | Resource = '';
  click?: () => void;
  isLight: boolean = true;
  @Prop isEnable: boolean = true;

  build() {
    Button({ type: ButtonType.Capsule, stateEffect: this.isEnable }) {
      Text(this.text)
        .fontColor(this.isLight ? Color.White : YWResColor.main())
        .fontWeight(FontWeight.Medium)
        .fontSize(YWResFloat.fontDesc())
        .focusable(true)
        .focusOnTouch(true)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .padding({ left: 8, right: 8 })
    }
    .fontWeight(FontWeight.Medium)
    .backgroundColor(this.isLight ? YWResColor.themeLight() : YWResColor.themeUnselect())
    .opacity(this.isEnable ? 1 : 0.5)
    .focusable(true)
    .focusOnTouch(true)
    .enabled(this.isEnable)
    .constraintSize({ minHeight: 40, maxWidth: 448 })
    .height(40)
    .width('100%')
    .onClick(hsGlobalThis.blockQuickClick(() => {
      if (this.click !== undefined) {
        this.click()
      }
    }))
  }
}