import { YWConstants } from "@learn/constants_har";

@ComponentV2
export struct MineMenuView {
  build() {
    Column(){

    }
    .width('100%')
    .height('90vp')
    .borderRadius('32vp')
    .backgroundColor(YWConstants.RandomColor())
  }
}