import { YWConstants } from "@learn/constants_har"
import { OrderListDataSource } from "../model/OrderListDataSource"
import { OrderListItemModel } from "../model/OrderListItemModel"
import { OrderListViewModel } from "../viewmodel/OrderListViewModel"

@Entry
@ComponentV2
export default struct OrderListView {
  @Param @Require status: string | undefined = undefined
  private orderListViewModel: OrderListViewModel = new OrderListViewModel()
  @Local orderList: OrderListItemModel[] = []
  private orderListDataSource: OrderListDataSource = new OrderListDataSource()
  isLoading: boolean = false
  isMore: boolean = false
  @Local roomCount: number = 0
  @Local textState: string = ""
  testLoadCount: number = 0

  aboutToAppear(): void {

    this.loadMoreList(false)
  }

  loadMoreList(isLoad: boolean) {
    console.log('=============== orderList')

    //测试数据
    if (this.isLoading == false) {
      this.testLoadCount = 0
    }
    this.orderListViewModel.getOrderList(this.status)
      .then(value => {

        console.log('========== order return')
        this.orderList = this.orderList.concat(value)

        value.flatMap((item) => {
          this.orderListDataSource.pushData(item)
        })
        this.isLoading = false
        this.isMore = false
        this.testLoadCount++
        if (value && value.length >= YWConstants.kPageSize10) {
          this.isMore = true
          if (this.testLoadCount > 3) {
            this.isMore = false
          }
        }
      })
  }

  jumpRoomDetail(model:OrderListItemModel) {
  }

  @Builder
  orderListCell(item: OrderListItemModel) {
    ListItem() {
      Row() {
        Row() {
          Column({space:5}) {
            Row(){
              Text(item.hotelName)
                .fontColor($r('app.color.col_333333'))
                .fontSize(20)
                .fontWeight(500)
                .maxLines(1)

              if (item.orderStatus=="0") {
                Text("待付款")
                  .fontColor($r('app.color.col_333333'))
                  .fontSize(16)
                  .fontWeight(300)
                  .maxLines(1)
                  .align(Alignment.End)
              }else if (item.orderStatus=='20'){
                Text("已完成")
                  .fontColor($r('app.color.col_333333'))
                  .fontSize(16)
                  .fontWeight(300)
                  .maxLines(1)
                  .align(Alignment.End)
              }else if (item.orderStatus=='13'){
                Text("待使用")
                  .fontColor($r('app.color.col_333333'))
                  .fontSize(16)
                  .fontWeight(300)
                  .maxLines(1)
                  .align(Alignment.End)
              }else if (item.orderStatus=='101'){
                Text("豪华套餐")
                  .fontColor($r('app.color.col_333333'))
                  .fontSize(16)
                  .fontWeight(300)
                  .maxLines(1)
                  .align(Alignment.End)
              }else {
                Text("已取消")
                  .fontColor($r('app.color.col_333333'))
                  .fontSize(16)
                  .fontWeight(300)
                  .maxLines(1)
                  .align(Alignment.End)
              }
              // Text(item.orderStatus)
              //   .fontColor(Constants.COLOR_333333)
              //   .fontSize(10)
              //   .fontWeight(300)
              //   .maxLines(1)
              //   .align(Alignment.End)
              //  this.textReplace(item.orderStatus)

            }.width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            Column(){
              Text(item.roomName)
                .fontColor($r('app.color.col_333333'))
                .fontSize(16)
                .fontWeight(700)
                .maxLines(1)
              Text(item.nights+"晚"+item.rmQty+"间")
                .fontColor($r('app.color.col_333333'))
                .fontSize(12)
                .fontWeight(700)
                .maxLines(1)
              Text(item.arrDate+"到"+item.depDate)
                .fontColor($r('app.color.col_333333'))
                .fontSize(12)
                .fontWeight(700)
                .maxLines(1)
            }.padding({left:30,top:20})
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Center)

          }
          .padding({left:40})
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
        }
        // .height('100%')
        .layoutWeight(7)
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)

      }
      // .height(80)
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding(8)
    .height(120)
    .borderRadius(8)
    .backgroundColor(Color.White)
    .onClick(()=>{
      this.jumpRoomDetail(item)
    })
  }

  @Builder
  listView() {

    List({ space: 10 }) {
      LazyForEach(this.orderListDataSource, (item: OrderListItemModel, index) => {
        this.orderListCell(item)
      }, (item: string) => item)
    }
    .cachedCount(5)
    .padding(12)
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_gray_base'))
    .onReachEnd(() => {

      console.log('=============== orderList end')

      if (!this.isLoading && this.isMore) {
        this.isLoading = true
        this.orderListViewModel.pageNo++
        this.loadMoreList(true)
      }
    })
  }
  @Builder
  textReplace(textState :string | undefined){

  }

  build() {
    Row(){
      this.listView()
      // Text(this.message)
    }.backgroundColor($r('app.color.bg_gray_base'))
    .width('100%')
    .width('100%')

  }


}