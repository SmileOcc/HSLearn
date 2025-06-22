import { Constants } from "../../contants/Constants";

@ComponentV2
export struct Banner {
  @Param increaseBannerHeight: number = 0;
  // 创建swiper组件控制器
  private swiperController: SwiperController = new SwiperController();
  // swiper显示数据
  private swiperData: Resource[] = [
    $r("app.media.status_bar_animation_page1"),
    $r("app.media.status_bar_animation_page2"),
    $r("app.media.status_bar_animation_page3")
  ];

  build() {
    Column() {
      Swiper(this.swiperController) {
        ForEach(this.swiperData, (item: Resource) => {
          Image(item)
            .width(Constants.FULL_PERCENT)
            .height(Constants.FULL_PERCENT)
        })
      }
      .width(Constants.FULL_PERCENT)
      // TODO: 知识点：当列表回滚到顶部继续下拉负值时，Banner放大效果。
      .height(`calc(${Constants.BANNER_HEIGHT_PERCENT} - ${this.increaseBannerHeight}vp)`)
      .loop(true)
      .autoPlay(true)
      .indicator(false)
    }
  }
}