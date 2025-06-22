import { hsLog } from "@learn/logger_har";

/**
 * 轮播项信息
 * @param imageSrc: 图片路径（必传参数）
 * @param name: 轮播图标题名称
 * @param appUri: 功能模块地址
 * @param param: 跳转参数
 */
export class SwiperData {
  imageSrc: ResourceStr;
  name: ResourceStr;
  appUri: string;
  param: string;

  constructor(imageSrc: ResourceStr, name?: ResourceStr, appUri?: string, param?: string) {
    this.imageSrc = imageSrc;
    this.name = name === undefined ? '' : name;
    this.appUri = appUri === undefined ? '' : appUri;
    this.param = param === undefined ? '' : param;
  }
}

/**
 * 轮播项视图类
 * @param data: 轮播项数据
 * @param contentBuilder: 轮播项视图组件
 */
export class SwiperItemViewType {
  data: SwiperData;
  contentBuilder: WrappedBuilder<[SwiperData]>;

  constructor(data: SwiperData, contentBuilder: WrappedBuilder<[SwiperData]>) {
    this.data = data;
    this.contentBuilder = contentBuilder;
  }
}

@ComponentV2
export struct SwiperView {
  // -------------------对外暴露变量-----------------------
  // 轮播模块列表
  @Param swiperListView: SwiperItemViewType[] = [];
  @Param defaultIndex: number = 0;
  @Monitor('defaultIndex')
  setDefaultIndex() {
    this.currentIndex = this.defaultIndex
  }
  @Local currentIndex: number = 0;

  // 轮播切换动画时间
  @Param swiperAnimationDuration: number = 300;
  // 轮播每5s切换一次
  @Param swiperSwitchDuration: number = 2000;
  // 是否循环播放
  @Param isLoop: boolean = true;
  // 导航点自定义视图
  // @BuilderParam indicatorBuilder?: (swiperListView: SwiperItemViewType[], currentIndex: number) => void;
  @Param hasIndicator?: boolean = false;

  // 点击swiper逻辑处理函数
  @Param swiperItemHandle: (swiperItemData: SwiperData) => void = (swiperItemData: SwiperData) => {};
  // --------------------私有属性----------------------------
  // 定时器句柄
  private swiperInterval: number = 0;
  // 数据中间值
  private halfCount: number = 0;
  // 初始化触摸Swiper的偏移量
  private offsetX: number = 0;

  private indicatorHeight = 12

  aboutToAppear(): void {
    this.halfCount = Math.floor(this.swiperListView.length / 2);
    this.currentIndex = this.halfCount;
    if (this.isLoop) {
      this.swiperInterval = setInterval(() => {
        this.startAnimation(true, this.swiperAnimationDuration);
      }, this.swiperSwitchDuration);
    } else {
      this.startAnimation(true, this.swiperAnimationDuration);
    }
  }

  aboutToDisappear(): void {
    if (this.swiperInterval && this.isLoop) {
      // 页面销毁时，清除定时器
      clearInterval(this.swiperInterval);
    }
  }

  /**
   * 获取图片系数
   * @param index：索引值
   * @returns
   */
  getImgCoefficients(index: number): number {
    const coefficient: number = this.currentIndex - index; // 计算图片左右位置
    const tempCoefficient: number = Math.abs(coefficient);
    if (tempCoefficient <= this.halfCount) {
      return coefficient;
    }
    let tempOffset: number = this.swiperListView.length - tempCoefficient; // 判断图片位于左右层级位置
    if (tempOffset <= this.halfCount) {
      if (coefficient > 0) {
        return -tempOffset;
      }
      return tempOffset;
    }
    return 0;
  }

  /**
   * 计算偏移量
   * @param index：索引值
   * @returns
   */
  getOffSetX(index: number): number {
    const offsetIndex: number = this.getImgCoefficients(index);
    const tempOffset: number = Math.abs(offsetIndex);
    let offsetX: number = 0;
    if (tempOffset === 1) {
      // 根据图片层级系数来决定左右偏移量
      offsetX = -35 * offsetIndex;
    }
    return offsetX;
  }

  // 性能：显式动画(https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-explicit-animation-V5)
  startAnimation(isLeft: boolean, duration: number): void {
    animateTo({
      duration: duration,
    }, () => {
      const tempIndex: number = isLeft ? this.currentIndex + 1 : this.currentIndex - 1 + this.swiperListView.length;
      this.currentIndex = tempIndex % this.swiperListView.length;
    })
  }

  build() {
    Column() {
      Blank().height('12vp')
      Stack({alignContent:Alignment.Center}) {
        // LazyForEach必须在容器组件内使用，仅有List、Grid、Swiper以及WaterFlow组件支持数据懒加载，其他组件仍然是一次性加载所有的数据。
        ForEach(this.swiperListView, (item: SwiperItemViewType, index: number) => {
          Column() {
            item.contentBuilder.builder(item.data)
          }
          .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .clip(true)
          .offset({
            x: this.getOffSetX(index),
            y: 0
          })
          .blur(index !== this.currentIndex ? 12 : 0)
          // TODO: 知识点:通过animateTo实现动画并且同时改变currentIndex数据中间值来判断组件zIndex实现切换动画
          .zIndex(this.halfCount + 1 - Math.abs(this.getImgCoefficients(index)))
          .width(310)
          // .height(index !== this.currentIndex ? 130 : 180)
          .height(index !== this.currentIndex ? `calc(100% - 80vp)` : `calc(100% - 24vp)`)
          .width('100%')
          .onClick(() => {
            // 点击轮播图Item时，根据点击的模块信息，将页面放入路由栈
            this.swiperItemHandle(item.data);
          })
        }, (item: SwiperItemViewType) => JSON.stringify(item))

      }
      .width('100%')
      .height(`calc(100% - 24vp)`)
      .gesture(
        PanGesture({ direction: PanDirection.Horizontal })
          .onActionStart((event: GestureEvent) => {
            if (this.isLoop) {
              clearInterval(this.swiperInterval);
            }
            this.offsetX = event.offsetX;
          })
          .onActionEnd((event: GestureEvent) => {
            hsLog.i(`onActionEnd start`);
            let isLeft: boolean = event.offsetX < this.offsetX;
            if (event.offsetX - this.offsetX >= 50 ||
              event.offsetX - this.offsetX <= -50) {
              this.startAnimation(isLeft, this.swiperAnimationDuration);
            }
            if (this.isLoop) {
              this.swiperInterval = setInterval(() => {
                this.startAnimation(true, this.swiperAnimationDuration);
              }, this.swiperSwitchDuration);
            }
          })


      )
      .alignContent(Alignment.Center)
      .padding({
        left: 12,
        right: 12,
      })
      if (this.hasIndicator) {
        // this.indicatorBuilder(this.swiperListView, this.currentIndex)
        this.testIndicatorBuilder()
      } else {
        Blank().height('12vp')
      }
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
  }

  @Builder
  testIndicatorBuilder() {
    Row(){
      Row({ space: 10 }) {
        ForEach(this.swiperListView ?? [], (item: SwiperData, index: number) => {
          Ellipse(index !== this.currentIndex ?
            { width: 8, height: 8 } :
            { width: 10, height: 10 })
            .fill(index !== this.currentIndex ? Color.Black : Color.Red)
            .fillOpacity(0.6)
        })
      }
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .zIndex(9999)
    .height(this.indicatorHeight)
    .position({bottom:6})
  }

  //这种无效，在方法参数里面
  // @Builder
  // testIndicatorBuilder(swiperListView: SwiperItemViewType[], currentIndex: number) {
  //   Row({ space: 10 }) {
  //     ForEach(swiperListView ?? [], (item: SwiperData, index: number) => {
  //       Ellipse(index !== currentIndex ?
  //         { width: 8, height: 8 } :
  //         { width: 10, height: 10 })
  //         .fill(index !== currentIndex ? Color.Black : Color.Red)
  //         .fillOpacity(0.6)
  //     })
  //   }
  //   // .margin({ top: 12 })
  //   // .width('100%')
  //   .zIndex(9999)
  // }


}