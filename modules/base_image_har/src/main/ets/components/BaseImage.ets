import { ImageKnifeComponentV2, ImageKnifeOption, ImageKnifeOptionV2 } from "@ohos/imageknife"

@ComponentV2
export struct BaseImage {
  @Param @Require imageOption:ImageKnifeOptionV2
  build() {
    ImageKnifeComponentV2({
      imageKnifeOption: this.imageOption
    })
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

  }
}
