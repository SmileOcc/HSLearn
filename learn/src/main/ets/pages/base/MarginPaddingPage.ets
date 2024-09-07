
@Entry
@Component
struct MarginPaddingPage {
  @State message: string = 'Margin:在子类使用时，最好不要设置对应方向的宽度，\n, 因为子组件的位置为：Margin的方向偏移 + 组件对应的大小，\n会超出父类的大小';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
        Column(){
          Text('测试Margin 123456测试Margin 123456测试Margin 123456测试Margin 123456测试Margin 123456测试Margin 123456')
            .width('100%')
            .height(30)
            .backgroundColor(Color.Green)
          Blank().height(2)
          Text('右边超出了-- 测试Margin测试Margin 123456测试Margin 123456测试Margin 123456测试Margin 123456测试Margin 123456测试Margin 123456测试Margin 123456')
            .width('100%')
            .height(30)
            .backgroundColor(Color.Green)
            .margin({left:30,right:30})
          Blank().height(2)
          Text('正常测试Margin测试Margin 123456测试Margin 123456测试Margin 123456测试Margin 123456测试Margin 123456测试Margin 123456测试Margin 123456')
            // .width('100%')
            .height(30)
            .backgroundColor(Color.Green)
            .margin({left:30,right:30})

        }
          .width('100%')
          .height(120)
          .backgroundColor(Color.Grey)
      }
      .width('100%')
    }
    .height('100%')
  }
}