import { YWConstants } from "@learn/constants_har";

@ComponentV2
export struct MineUserInfoView {
  build() {
    Column(){
      Image($r('app.media.user_avatar'))
        .borderWidth('1vp')
        .borderRadius('24vp')
        .borderColor($r('app.color.col_FFFFFF'))

    }
    .width('100%')
    .height('200vp')
    .backgroundColor(YWConstants.RandomColor())

  }
}