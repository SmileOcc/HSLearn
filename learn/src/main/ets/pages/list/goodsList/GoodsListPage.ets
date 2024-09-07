import { GoodsModel, MockGoodList } from '../model/GoodsModel';

@Entry
@Component
struct GoodsListPage {
  @State message: string = 'Hello World';
  //进行列表的滚动控制
  listScroller: Scroller = new Scroller();

  imageWidth = 80
  goodsList = MockGoodList()
  @Builder goodsItemCell(item:GoodsModel) {
    Row({space:3}) {
      Image('https://lmg.jj20.com/up/allimg/1114/0406210Z024/2104060Z024-5-1200.jpg')
        .width(this.imageWidth)
        .height(80)
        .padding(0)
        .borderRadius(5)
        .objectFit(ImageFit.Fill)
        .backgroundColor(Color.Green)

      Column() {
        Text(item.name + "")
          .fontWeight(FontWeight.Bold)
          .fontSize(18)
          .baselineOffset(0)
          .height(40)
          .width(200)

        Text('¥'+item.price)
          .fontSize(14)
          .textAlign(TextAlign.Start)
          .fontColor("#FF0000")
          .height(30)
          .width(200)
        if (item.discount != undefined && item.discount != 0) {
          Text('原价 ¥'+item.price)
            .fontSize(14)
            .textAlign(TextAlign.Start)
            .fontColor("#000000")
            .height(30)
            .width(200)
            .margin({right:10})
            .decoration({type:TextDecorationType.LineThrough})//设置中划线
        }
      }
      .margin({left:20})
      .justifyContent(FlexAlign.Start)

    }.height(110)
    .width('90%')
    .backgroundColor('#FFFFFF')
    .borderRadius(20)

  }

  @Builder itemEnd(index: number) {
    // 侧滑后尾端出现的组件
    Button({ type: ButtonType.Circle }) {
      // Image($r('app.string.delete'))
      //   .width(20)
      //   .height(20)
      Text($r('app.string.delete'))
        .fontSize(14)
        .fontColor(Color.White)
        .backgroundColor(Color.Red)
        .width(120)
        .height(80)
        .textAlign(TextAlign.Center)
    }.onClick(() => {
      // this.messages为列表数据源，可根据实际场景构造。点击后从数据源删除指定数据项。
      this.goodsList.splice(index, 1);
    })

  }

  build() {

    List({space:12,scroller:this.listScroller}) {
      ForEach(this.goodsList, (item:GoodsModel, index) => {
        ListItem() {
          this.goodsItemCell(item)
        }
        .swipeAction({ end: this.itemEnd.bind(this, index) }) // 设置侧滑属性
      })
    }
    .padding({left:16,right:16,top:12,bottom:12})
    .divider({
      strokeWidth: 1,
      startMargin: 10,
      endMargin: 10,
      color: '#ffe9f0f0'
    })
  }
}