@Entry
@Component
export struct RectIndicator {
  @Prop marginLeft: number = 0 //indicator距离进度距离左边间距，默认是 0
  indicatorHeight: number = 20 //indicator的高度
  indicatorWidth: number = 200 //indicator的背景宽度
  indicatorProgressWidth: number = 160 //indicator 的进度宽度

  build() {
    Stack() {
      //绘制矩形背景
      Rect({ width: this.indicatorWidth, height: this.indicatorHeight })
        .radius(this.indicatorHeight / 2)
        .fill($r('app.color.theme_light'))
        .stroke(Color.Transparent)

      //绘制矩形进度
      Rect({ width: this.indicatorProgressWidth, height: this.indicatorHeight })
        .radius(this.indicatorHeight / 2)
        .fill($r('app.color.theme_default'))
        .margin({ left: this.marginLeft })
        .stroke(Color.Transparent)
    }.alignContent(Alignment.Start)
  }
}