@Entry
@Component
struct AutoFlexShrinkPage {
  @State message: string = 'Hello World';

  // 绑定的宽度-默认 600
  @State containerWidth: number = 200

  readonly list: NavItem [] = [
    { id: 1, icon: $r('app.media.tab_new'), title: '淘金币' },
    { id: 2, icon: $r('app.media.tab_new'), title: '摇现金' },
    { id: 3, icon: $r('app.media.startIcon'), title: '闲鱼' },
    { id: 4, icon: $r('app.media.avatar'), title: '中通快递' },
  ]
  @State rate: number = 600

  // 底部滑块，可以通过拖拽滑块改变容器尺寸。
  @Builder
  sliderBuilder() {
    Slider({
      value: $$this.containerWidth, // 绑定的值
      min: 200, // 最小值
      max: 400, // 最大值
      style: SliderStyle.OutSet // 滑块在滑轨上
    })
      .blockColor(Color.White)
      .width('60%')
      .position({ x: '20%', y: '80%' })
  }

  @Builder testFlexShrink() {//拉伸能力
    Stack({ alignContent: Alignment.TopStart }) {
      // 标记现在的宽度
      Text('宽度:' + this.containerWidth)
        .zIndex(2)
        .translate({ x: 20, y: 20 })
        .fontColor(Color.Orange)

      // 核心区域
      Column() {
        Column() {
          Row() {
            // 布局能l力 1：拉伸能力：
            // 容器组件尺寸发生改变时，将变化的部分分配给容器内的【指定区域】
            //

            // 涉及属性：
            // flexShrink:压缩比例，默认值：Column，Row 时（0），Flex 时（1）
            // flexGrow:拉伸比例，默认值 0

            // 需求：
            // 1. 空间不足时：分配给左右，1：1
            // 2. 空间富余时：分配给中间

            // 左
            Row() {
              Text('左')
                .fontSize(20)
                .fontColor(Color.White)
            }
            .justifyContent(FlexAlign.Center)
            .width(30)
            .height(100)
            .backgroundColor('#c2baa6')
            .flexShrink(1)

            // 中
            Row() {
              Text('中')
                .fontSize(30)
                .fontColor(Color.White)
            }
            .width(100)
            .height(200)
            .backgroundColor('#68a67d')
            .justifyContent(FlexAlign.Center)
            .flexGrow(1)
            //.flexShrink(1) //可同时使用压缩、拉伸能力


            // 右
            Row() {
              Text('右')
                .fontSize(20)
                .fontColor(Color.White)
            }
            .justifyContent(FlexAlign.Center)
            .width(30)
            .height(100)
            .backgroundColor('#c2baa6')
            .flexShrink(1)
          }
          .width(this.containerWidth)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .border({ width: 2, color: Color.Orange })
          .backgroundColor(Color.Black)
        }
        // 底部滑块
        this.sliderBuilder()
      }
      .width('80%')
      .height('30%')
      .backgroundColor('#F1F3F5')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
  }

  @Builder
  // 底部滑块，可以通过拖拽滑块改变容器尺寸
  @Builder
  sliderBuilder2() {
    Slider({
      value: $$this.rate,
      min: 200,
      max: 600,
      style: SliderStyle.OutSet
    })
      .blockColor(Color.White)
      .width('60%')

    .position({ x: '20%', y: '80%' })
  }

  @Builder
  testJustify() {//均分能力
    Stack({ alignContent: Alignment.TopStart }) {
      // 标记现在的宽度
      Text('宽度:' + this.rate.toFixed(0))
        .zIndex(2)
        .translate({ x: 20, y: 20 })
        .fontColor(Color.Orange)

      Column() {
        Column() {
          // 布局能力 2：均分能力
          // 指容器组件尺寸发生变化时，增加或减小的空间均匀分配给容器组件内所有【空白区域】。
          // 常用于内容数量固定、均分显示的场景，比如工具栏、底部菜单栏、导航栏等

          // 涉及属性:
          // Row、Column、Flex 组件的 justifyContent 属性
          // justifyContent设置为 FlexAlign.SpaceEvenly即可
          Row() {
            ForEach(this.list, (item: NavItem) => {
              Column() {
                Image(item.icon)
                  .width(48)
                  .height(48)
                  .margin({ top: 8 })
                Text(item.title)
                  .width(64)
                  .height(30)
                  .lineHeight(15)
                  .fontSize(12)
                  .textAlign(TextAlign.Center)
                  .margin({ top: 8 })
                  .padding({ bottom: 15 })
              }
              .width(80)
              .height(102)
              .backgroundColor('#8FBF9F')
              .borderRadius(10)
            })
          }
          .width('100%')

          .justifyContent(FlexAlign.SpaceEvenly) // 均分

        }
        .width(this.rate) // 绑定滑块改变的尺寸
        .padding({ top: 16 })
        .backgroundColor('#FFFFFF')
        .borderRadius(16)

        this.sliderBuilder2()
      }
      .width('100%')
      .height('30%')
      .backgroundColor('#F1F3F5')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
  }


  // 占比能力
  @Builder
  testRateView(){
    Stack({ alignContent: Alignment.TopStart }) {
      // 显示目前容器的宽度
      Text('宽度:' + this.rate.toFixed(0))
        .zIndex(2)
        .translate({ x: 20, y: 20 })
        .fontColor(Color.Orange)

      Column() {
        // 布局能力 3：占比能力
        // 子组件的宽高按照预设的比例，随父容器组件发生变化

        // 实现方式：
        // 1. 子组件的【宽高】设置为父组件宽高的【百分比】
        // 2. 通过 layoutWeight 属性设置主轴方向【布局权重】（比例）

        // 容器 主轴横向
        Row() {
          // 上一首
          Column() {
            Image($r("app.media.icon_ring"))
              .width(50)
              .height(50)
              .border({ width: 2 })
              .borderRadius(30)
              .padding(10)

          }
          .height(96)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .layoutWeight(5) // 设置子组件在父容器主轴方向的布局权重

          // 播放&暂停
          Column() {
            Image($r("app.media.tomato"))
              .width(50)
              .height(50)
              .border({ width: 2 })
              .borderRadius(30)
              .padding(10)
          }
          .height(96)
          .backgroundColor('#66F1CCB8')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .layoutWeight(5) // 设置子组件在父容器主轴方向的布局权重

          // 下一首
          Column() {
            Image($r("app.media.precious_metals"))
              .width(50)
              .height(50)
              .border({ width: 2 })
              .borderRadius(30)
              .padding(10)
          }
          .height(96)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .layoutWeight(5) // 设置子组件在父容器主轴方向的布局权重

        }
        .width(this.rate) // 绑定宽度给 容器
        .height(96)
        .borderRadius(16)
        .backgroundColor('#FFFFFF')

        // 调整宽度的滑块
        this.sliderBuilder2()
      }
      .width('100%')
      .height('30%')
      .backgroundColor('#F1F3F5')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }

  }

  //缩放能力

  @State sliderWidth: number = 400
  @State sliderHeight: number = 400

  // 底部滑块，可以通过拖拽滑块改变容器尺寸
  @Builder
  slider3() {

    Slider({
      value: $$this.sliderHeight,
      min: 100,
      max: 400,
      style: SliderStyle.OutSet
    })
      .blockColor(Color.White)
      .width('60%')
      .height(50)

    .position({ x: '20%', y: '80%' })

    Slider({
      value: $$this.sliderWidth,
      min: 100,
      max: 400,
      style: SliderStyle.OutSet
    })
      .blockColor(Color.White)
      .width('60%')
      .height(50)

    .position({ x: '20%', y: '87%' })
  }


  @Builder
  testScaleView() {
    Stack({ alignContent: Alignment.TopStart }) {
      Text('宽度:' + this.sliderWidth.toFixed(0) + ' 高度:' + this.sliderHeight.toFixed(0))
        .zIndex(2)
        .translate({ x: 20, y: 20 })
        .fontColor(Color.Orange)
      Column() {
        // 动态修改该容器的宽高
        Column() {
          Column() {
            Image($r("app.media.avatar"))
              .width('30%')
              .height('30%')
          }
          // 布局能力 4：缩放能力
          // 子组件的宽高按照预设的比例，随容器组件发生变化，且变化过程中子组件的【宽高比】不变。

          // 实现方式：
          // 给子组件设置 aspectRatio即可 设置的值是 宽度/高度
          // .aspectRatio(1 / 4) // 固定 宽 高比 1等同于 1:1
          // .aspectRatio(1 / 2) // 固定 宽 高比 1等同于 1:1
          .aspectRatio(1) // 宽高比为1:1
            .border({ width: 2, color: "#66F1CCB8" }) // 边框，仅用于展示效果
        }
        .backgroundColor("#FFFFFF")
        .height(this.sliderHeight)
        .width(this.sliderWidth)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)

        this.slider3()
      }
      .width('50%')
      .height('50%')
      .backgroundColor(Color.Blue)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
  }

  // 延伸能力
  // 数组
  readonly appList: NavItem [] = [
    { id: 1, icon: $r('app.media.tab_new_select'), title: '淘金币' },
    { id: 2, icon: $r('app.media.tab_new_select'), title: '摇现金' },
    { id: 3, icon: $r('app.media.tab_new_select'), title: '闲鱼' },
    { id: 4, icon: $r('app.media.tab_new_select'), title: '中通快递' },
    { id: 5, icon: $r('app.media.app_icon'), title: '芭芭农场' },
    { id: 6, icon: $r('app.media.app_icon'), title: '淘宝珍库' },
    { id: 7, icon: $r('app.media.app_icon'), title: '阿里拍卖' },
    { id: 8, icon: $r('app.media.app_icon'), title: '阿里药房' },
  ]


  @Builder
  testFlexWrap() {
    Stack({ alignContent: Alignment.TopStart }) {
      Text('宽度:' + (this.rate * 100).toFixed(0) + '%')
        .zIndex(2)
        .translate({ x: 20, y: 20 })
        .fontColor(Color.Orange)
      Flex({ justifyContent: FlexAlign.Center, direction: FlexDirection.Column }) {
        Column() {
          // 布局能力 7：折行能力
          // 容器组件尺寸发生变化，当布局方向尺寸不足以显示完整内容时自动换行

          // 实现方式：
          // Flex组件将 wrp 设置为FlexWrap.Wrap即可

          // 通过Flex组件warp参数实现自适应折行
          Flex({
            direction: FlexDirection.Row,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Center,
            wrap: FlexWrap.Wrap // 是否换行：  FlexWrap.Wrap 开启换行
          }) {
            ForEach(this.appList, (item: NavItem) => {
              Column() {
                Image(item.icon)
                  .width(80)
                  .height(80)
                Text(item.title)
              }
              .margin(10)

            })
          }
          .backgroundColor('#FFFFFF')
          .padding(20)
          .width(this.rate * 100 + '%')
          .borderRadius(16)

        }
        .width('100%')

        Slider({
          value: this.rate * 100,
          min: 10,
          max: 100,
          style: SliderStyle.OutSet
        })
          .blockColor(Color.White)
          .width('60%')
          .position({ x: '20%', y: '87%' })
          .onChange((value: number) => {
            this.rate = value / 100
          })

      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Red)
    }

  }

  @Builder
  testRate22() {

    Stack({ alignContent: Alignment.TopStart }) {
      // 展示宽度
      Text('宽度:' + this.rate.toFixed(0))
        .zIndex(2)
        .translate({ x: 20, y: 20 })
        .fontColor(Color.Orange)

      Column() {
        Row({ space: 10 }) {
          // 布局能力 5：延伸能力
          // 容器组件内的子组件，按照其在列表中的先后顺序，随容器组件尺寸变化【显示或隐藏】

          // 实现方式：
          // 1.List 组件
          // 2.Scroll 配合 Row 或者 Column
          // 核心：调整父容器的尺寸，让页面中显示的组件数量发生改变

          // 通过Scroll 组件实现隐藏能力
          Scroll() {
            Row({ space: 10 }) {
              ForEach(this.appList, (item: NavItem, index: number) => {
                Column() {
                  Image(item.icon)
                    .width(48)
                    .height(48)
                    .margin({ top: 8 })
                  Text(item.title)
                    .width(64)
                    .height(30)
                    .lineHeight(15)
                    .fontSize(12)
                    .textAlign(TextAlign.Center)
                    .margin({ top: 8 })
                    .padding({ bottom: 15 })
                }
                .width(80)
                .height(102)
              })
            }
          }
          .scrollable(ScrollDirection.Horizontal) // 设置横向滚动
          .padding({ top: 16, left: 10 })
          .height(118)
          .borderRadius(16)
          .backgroundColor(Color.White)
        }
        .width(this.rate)

        Slider({
          value: $$this.rate,
          min: 100,
          max: 730,
          style: SliderStyle.OutSet
        })
          .blockColor(Color.White)
          .width('60%')
          .height(50)

        .position({ x: '20%', y: '80%' })

      }
      .width('100%')
      .height('50%')
      .backgroundColor('#F1F3F5')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }

  }

  // 隐藏能力
  @State rateHidde: number = 48

  @Builder
  testHideView() {
    Stack({ alignContent: Alignment.TopStart }) {
      Text('宽度:' + this.rateHidde.toFixed(0))
        .zIndex(2)
        .translate({ x: 20, y: 20 })
        .fontColor(Color.Orange)

      Column() {
        // 布局能力 6：隐藏能力
        // 容器组件内的子组件，按照其预设的显示优先级，随容器组件尺寸变化显示或隐藏
        // if else 条件渲染 适合管理多个组件{多个组件}
        // displayPriority属性 适合设置若干个优先级不同的单个组件

        // 实现方式：
        // displayPriority属性：设置布局优先级来控制显隐
        // 当主轴方向剩余尺寸不足以满足全部元素时，按照布局优先级，从[小到大]依次隐藏

        Row({ space: 10 }) {
          Image($r("app.media.travel"))
            .width(48)
            .height(48)
            .displayPriority(1) // 布局优先级

          Image($r("app.media.tips"))
            .width(48)
            .height(48)
            .displayPriority(2) // 布局优先级

          Image($r("app.media.speed_gain"))
            .width(48)
            .height(48)
            .displayPriority(3) // 布局优先级

          Image($r("app.media.sample_image02"))
            .width(48)
            .height(48)
            .objectFit(ImageFit.Contain)
            .displayPriority(2) // 布局优先级

          Image($r("app.media.tab_new_select"))
            .width(48)
            .height(48)
            .objectFit(ImageFit.Contain)
            .displayPriority(1) // 布局优先级
        }
        .width(this.rateHidde)
        .height(96)
        .borderRadius(16)
        .backgroundColor('#FFFFFF')
        .justifyContent(FlexAlign.Center)
        .padding(10)

        Slider({
          value: $$this.rateHidde,
          min: 80,
          max: 400,
          style: SliderStyle.OutSet
        })
          .blockColor(Color.White)
          .width('60%')
          .height(50)

        .position({ x: '20%', y: '80%' })

      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Red)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
  }

  // 折行能力
  @State rateWrap: number = 0.7
  @Builder
  testLine() {
    Stack({ alignContent: Alignment.TopStart }) {
      Text('宽度:' + (this.rateWrap * 100).toFixed(0) + '%')
        .zIndex(2)
        .translate({ x: 20, y: 20 })
        .fontColor(Color.Orange)
      Flex({ justifyContent: FlexAlign.Center, direction: FlexDirection.Column }) {
        Column() {
          // 布局能力 7：折行能力
          // 容器组件尺寸发生变化，当布局方向尺寸不足以显示完整内容时自动换行

          // 实现方式：
          // Flex组件将 wrp 设置为FlexWrap.Wrap即可

          // 通过Flex组件warp参数实现自适应折行
          Flex({
            direction: FlexDirection.Row,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Center,
            wrap: FlexWrap.Wrap // 是否换行：  FlexWrap.Wrap 开启换行
          }) {
            ForEach(this.appList, (item: NavItem) => {
              Column() {
                Image(item.icon)
                  .width(80)
                  .height(80)
                Text(item.title)
              }
              .margin(10)

            })
          }
          .backgroundColor('#FFFFFF')
          .padding(20)
          .width(this.rateWrap * 100 + '%')
          .borderRadius(16)

        }
        .width('100%')

        Slider({
          value: $$this.rateWrap,
          min: 0.1,
          max: 1.0,
          style: SliderStyle.OutSet
        })
          .blockColor(Color.White)
          .width('60%')
          .height(50)

        .position({ x: '20%', y: '80%' })

      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Red)
    }

  }

  private scrollView: Scroller = new Scroller()

  build() {
    // RelativeContainer() {
    Scroll(this.scrollView){

      Column(){
        this.testFlexShrink()
        this.testJustify()
        this.testRateView()
        this.testScaleView()
        this.testRate22()
        this.testHideView()
        this.testLine()
      }
      // .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Start)
    }
    .height('100%')
    .width('100%')

    // }
    // .height('100%')
    // .width('100%')
  }
}

export interface NavItem {
  id: number
  icon: ResourceStr
  title: string
}