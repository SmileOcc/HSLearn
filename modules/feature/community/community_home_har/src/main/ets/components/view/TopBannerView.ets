import { YWConstants } from "@learn/constants_har";
import { CommunityUIState } from "../viewmodel/CommunityViewModel"
import { SwiperData, SwiperItemViewType, SwiperView } from "./SwiperView";

@ComponentV2
export struct TopBannerView {
  @Param @Require uiState?: CommunityUIState = undefined

  build() {
    Column() {
      /**
       * 轮播图视图
       * @param swiperListView: 轮播图列表视图数据
       * @param currentIndex: 当前索引值
       * @param swiperAnimationDuration: 轮播图切换动画时间
       * @param swiperSwitchDuration: 轮播图切换间隔时间
       * @param isLoop: 轮播图是否自动循环播放
       * @param indicatorBuilder: 导航点自定义视图
       * @param swiperItemHandle: 点击轮播图处理逻辑
       */
      if (this.uiState) {
        SwiperView({
          swiperListView: this.uiState.swiperListView,
          defaultIndex: this.uiState.currentBannerIndex,
          swiperAnimationDuration: 300,
          swiperSwitchDuration: 2000,
          isLoop: true,
          hasIndicator: true,
          // indicatorBuilder: this.indicatorBuilder,
          swiperItemHandle: (swiperItemData: SwiperData) => {
            // TODO:点击swiper逻辑处理
            // 点击轮播图Item时，根据点击的模块信息，将页面放入路由栈
            // this.dynamicsRouterPush(swiperItemData);
          }
        })
      }

    }
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  @Builder
  indicatorBuilder(swiperListView: SwiperItemViewType[], currentIndex: number) {
    Row({ space: 10 }) {
      ForEach(swiperListView ?? [], (item: SwiperData, index: number) => {
        Ellipse(index !== currentIndex ?
          { width: 8, height: 8 } :
          { width: 10, height: 10 })
          .fill(index !== currentIndex ? Color.Black : Color.Red)
          .fillOpacity(0.6)
      })
    }
    // .margin({ top: 12 })
    // .width('100%')
    .zIndex(9999)
  }

  // @Builder
  // indicatorBuilder() {
  //   Row({ space: 10 }) {
  //     ForEach(this.uiState?.swiperListView ?? [], (item: SwiperData, index: number) => {
  //       Ellipse(index !== this.uiState?.currentBannerIndex ?
  //         { width: 8, height: 8 } :
  //         { width: 10, height: 10 })
  //         .fill(index !== this.uiState?.currentBannerIndex ? Color.Black : Color.Red)
  //         .fillOpacity(0.6)
  //     })
  //   }
  //   // .margin({ top: 12 })
  //   .width('100%')
  //   .height("50vp")
  //   .backgroundColor(YWConstants.RandomColor())
  // }
}

@Builder
export function SwiperItemView(swiperItemData: SwiperData) {
  Stack({ alignContent: Alignment.BottomStart }) {

    if (swiperItemData.imageSrc.toString().startsWith("app.")) {
      Image($r(`${swiperItemData.imageSrc}`))
        .objectFit(ImageFit.Cover)
        .width('100%')
        .height('100%')
        .borderRadius(8)
    } else {
      Image(swiperItemData.imageSrc)
        .objectFit(ImageFit.Cover)
        .width('100%')
        .height('100%')
        .borderRadius(8)
    }

    // 轮播图底部蒙层
    Stack() {
      Column() {
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
      .opacity(0.3)
      .borderRadius({
        topLeft: 0,
        topRight: 0,
        bottomLeft: 8,
        bottomRight: 8
      })

      Text(swiperItemData.name)
        .width('100%')
        .height('100%')
        .fontSize(13)
        .fontColor(Color.White)
        .textAlign(TextAlign.Start)
        .maxLines(2)
        .padding(8)
    }
    .height(44)
  }
}