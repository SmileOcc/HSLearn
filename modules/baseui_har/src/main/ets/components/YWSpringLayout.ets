/*
 * @Desc: 滑动出现弹性的页面布局效果
 */
@Component
export struct YWSpringLayout {
  @BuilderParam layout: () => void;

  build() {
    Scroll() {
      Stack() {
        this.layout()
      }
      .width('100%')
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .align(Alignment.TopStart)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }
}
