/*
 * @Desc: 阅读隐私协议
 */
import { KLogger, YWAppUtils } from '@learn/common_har';
import { loginComponentManager } from '@kit.AccountKit';
import { curves } from '@kit.ArkUI';
import { YWResColor } from '@learn/res_har';

const TAG = 'YWPrivacyCheckbox';

@Component
export struct YWPrivacyCheckbox {
  // 协议内容
  @Prop texts: loginComponentManager.PrivacyText[] = [];
  // 是否勾选协议
  @Link isCheckboxSelected: boolean;
  //通过外面改变unselectAnimalCount的值来触发未选中的动画
  @Prop @Watch('checkAgreeAnimate') unselectAnimalCount: number = 0;
  //如果实现了这个的话就不会自动跳转 tag
  onCustomItemClick?: (item: loginComponentManager.PrivacyText) => void;
  //动画
  @State translateX: number = 0;

  build() {
    Row() {
      Row() {
        Checkbox({ name: 'privacyCheckbox', group: 'privacyCheckboxGroup' })
          .width(24)
          .height(24)
          .focusable(true)
          .focusOnTouch(true)
          .selectedColor(YWResColor.themeLight())
          .margin({ top: 0 })
          .select(this.isCheckboxSelected)
          .translate({ x: this.translateX })
          .onChange((value: boolean) => {
            if (value) {
              this.isCheckboxSelected = true;
            } else {
              this.isCheckboxSelected = false;
            }
            KLogger.info(TAG, `agreementChecked: ${value}`);
          })
      }

      Row() {
        Text() {
          ForEach(this.texts, (item: loginComponentManager.PrivacyText, index: number) => {
            if (item?.type == loginComponentManager.TextType.PLAIN_TEXT && item?.text) {
              Span(item?.text)
                .fontColor(YWResColor.desc())
                .fontWeight(FontWeight.Regular)
                .fontSize($r('sys.float.ohos_id_text_size_body3'))
            } else if (item?.type == loginComponentManager.TextType.RICH_TEXT && item?.text) {
              Span(item?.text)
                .fontColor(YWResColor.themeLight())
                .fontWeight(FontWeight.Medium)
                .fontSize($r('sys.float.ohos_id_text_size_body3'))
                .focusable(true)
                .focusOnTouch(true)
                .onClick(() => {
                  KLogger.info(TAG, `click privacy text tag: ${item.tag}`);
                  if (this.onCustomItemClick !== undefined) {
                    this.onCustomItemClick(item);
                  } else if (item.tag) { // 应用需要根据item.tag实现协议页面的跳转逻辑。
                    YWAppUtils.jumpUrl(item.tag)
                  }
                })
            }
          })
        }
      }
      .layoutWeight(1)
      .margin({ left: 12 })
      .constraintSize({ minHeight: 24 })
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.Start)
  }

  checkAgreeAnimate() {
    if (this.isCheckboxSelected) {
      return;
    }
    animateTo({ curve: curves.springMotion(1, 0.2) }, () => {
      if (!this.isCheckboxSelected) {
        this.startAnimation();
      }
    })
  }

  startAnimation() {
    // TODO: 知识点：通过animateTo显示动画指定由于闭包代码导致的状态变化插入过渡动效
    animateTo({
      duration: 1000,
      // 弹簧曲线：初始速度100，质量1，刚度80，阻尼10
      curve: curves.springCurve(100, 1, 80, 30),
      // 播放2次
      iterations: 1,
    },
      () => {
        // 抖动动偏移量
        this.translateX = -10;
      })
    this.translateX = 0;
  }
}