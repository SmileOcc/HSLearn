import { YWConstants } from "@learn/constants_har";
import { YWResImage } from "@learn/res_har/src/main/ets/res/YWResImage";

/**
 * 沉浸式状态栏和标题栏的设置
 */
@Component
export struct YWNavBar {
  @Prop title: string | Resource; //标题
  onKeyBack?: () => void; //监听返回事件，如果不设置则隐藏返回键
  @BuilderParam rightLayout?: () => void; //自定义的右边布局
  titleBarHeight: Length = $r('app.float.height_title_bar'); //标题栏高度
  titleSize: number | string | Resource = $r('app.float.font_title'); //标题字体大小
  titleAttrModifier: AttributeModifier<TextAttribute> = {}; //标题控件的样式
  bgColor: ResourceColor = $r('app.color.title_bar'); //状态栏和标题栏背景颜色
  @StorageProp(YWConstants.kStatusBarHeight) statusHeight: number = 0; //状态栏高度（单位：vp）

  build() {
    Stack() {
      RelativeContainer() {
        Text(this.title)
          .fontSize(this.titleSize)
          .width('50%')
          .height('100%')
          .fontColor($r('app.color.title'))
          .fontWeight(FontWeight.Medium)
          .ellipsisMode(EllipsisMode.END)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .textAlign(TextAlign.Center)
          .alignRules({
            middle: { anchor: "__container__", align: HorizontalAlign.Center },
          })
          .id("i1")
          .attributeModifier(this.titleAttrModifier)

        if (this.onKeyBack) {
          Image(YWResImage.arrowLeftIcon())
            .height('100%')
            .padding({ left: $r('app.float.margin_left_right'), top: 11, bottom: 11 , right: 11})
            .fillColor($r('app.color.title'))
            .objectFit(ImageFit.Contain)
            .alignRules({
              left: { anchor: "__container__", align: HorizontalAlign.Start },
            })
            .id("i2")
            .onClick(() => {
              this.onKeyBack?.()
            })
        }
        if (this.rightLayout) {
          Row() {
            this.rightLayout?.()
          }
          .height('100%')
          .justifyContent(FlexAlign.End)
          .alignRules({
            right: { anchor: "__container__", align: HorizontalAlign.End },
          })
          .id("i3")
        }
      }
      .width('100%')
      .height(this.titleBarHeight)
    }
    .width('100%')
    .height(this.statusHeight + 45)
    .padding({ top: this.statusHeight })
    .backgroundColor(Color.White)

  }
}