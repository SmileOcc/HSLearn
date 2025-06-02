import { YWNavPath, ywNavRouter, YWRouterNavParams } from "@learn/nav_router_har"
import { YWBaseNavBar, YWNavBar } from '@learn/baseui_har';
import { HotelListItemModel } from "./model/HotelListItemModel";
import { HotelListDataSource } from "./model/HotelListDataSource";
import roomListViewModel from "./viewmodel/HotelRoomListViewModel";
import { YWConstants } from "@learn/constants_har";

@Builder
export function hotelListBuilder(name: string, params: YWRouterNavParams) {
  NavDestination() {
    HotelListPage()
  }
  .hideTitleBar(true)
  .onWillDisappear(() => {
    params.getPageLifecycle().pageOnDisappear?.()
  })
  .onShown(() => {
    params.getPageLifecycle().pageOnShow?.()
  })
  .onHidden(() => {
    params.getPageLifecycle().pageOnHide?.()
  })
}

@ComponentV2
struct HotelListPage {

  @Local hotelList: HotelListItemModel[] = []
  private hotelListDataSource: HotelListDataSource = new HotelListDataSource()
  isLoading: boolean = false
  isMore: boolean = false
  @Local roomCount: number = 0
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
    roomListViewModel.getHotelList()
      .then(value => {

        console.log('========== order return')
        this.hotelList = this.hotelList.concat(value)

        value.flatMap((item) => {
          this.hotelListDataSource.pushData(item)
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

  @Builder
  navBar() {
    YWBaseNavBar({title:"酒店列表", defaultGoBack:()=>{
      ywNavRouter.openRoute(this.getUniqueId()).back()
    }})
  }

  @Builder
  content() {
    Row() {
      Text(' 慕名会员权益 ')
        .fontSize(12)
        .borderRadius({ bottomLeft: 3, topLeft: 3 })
        .backgroundColor(YWConstants.RandomColor())
      Text(' 免费wifi-会员专享价 ')
        .fontSize(12)
        .borderRadius({ bottomRight: 3, topRight: 3 })
        .backgroundColor(YWConstants.RandomColor())
    }.borderRadius(3)
    .alignItems(VerticalAlign.Center)
    .backgroundColor(Color.White)
    .height(15)
  }

  @Builder
  gridLabelView(labs: string[]) {
    Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      ForEach(labs, (labContent: string) => {
        Text(labContent)
          .flexBasis('auto')
          .fontSize(12)
          .height(20)
          .padding({ left: 3, right: 3 })
          .backgroundColor(YWConstants.RandomColor())
          .borderWidth(0.5)
          .borderColor($r('app.color.col_666666'))
          .borderRadius(3)
          .margin({ right: 4, top: 4 })
          .opacity(0.5)
      })
    }
    .width('100%')
  }

  @Builder
  hotelListCell(item: HotelListItemModel) {
    ListItem() {
      Row() {
        Row() {
          Image(item.imageUrl)
            .alt($r('app.media.placeholder'))
            .width(95)
            .height(105)
            .borderRadius(8)

          Column({ space: 5 }) {
            Text(item.name)
              .fontColor(YWConstants.COLOR_333333)
              .fontSize(16)
              .fontWeight(700)
              .maxLines(1)

            Row() {
              Image($r('app.media.review')).width(15).width(15).margin({ right: 5 })
              Text(item.totalReviewsNum).fontColor(YWConstants.COLOR_333333).fontSize(10)
            }

            Text(item.address).fontColor(YWConstants.COLOR_333333).fontSize(14)
            this.content()
            Row() {
              if (item.labelList.length > 0) {
                this.gridLabelView(item.labelList)
              }
              Text(`￥${item.price}起`)
                .fontColor($r('app.color.col_EC5E4F'))
                .fontSize(14)
                .textAlign(TextAlign.End)
            }.justifyContent(FlexAlign.SpaceBetween)
            .width('85%')

          }
          .padding({ left: 8 })
          .width('68%')
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
        }
        // .height('100%')
        .layoutWeight(7)
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)

        //.padding({left:8,right:8})

        // Column(){
        //   Text(`￥${item.price}起`)
        //     .fontColor(Constants.COLOR_ffcc33)
        //     .fontSize(14)
        //     .textAlign(TextAlign.End)
        //     .margin({top:8})
        // }
        // .height('100%')
        // .layoutWeight(3)
        // .alignItems(HorizontalAlign.End)
        // .justifyContent(FlexAlign.End)
      }
      // .height(80)
      .width('100%')
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding(8)
    .borderRadius(8)
    .backgroundColor(Color.White)
    .onClick(() => {
      ywNavRouter.openRoute(this.getUniqueId())
        .onTargetUrl(YWNavPath.vc_hotel_room_list)
        .go()
    })
  }

  @Builder
  listView() {
    List({ space: 10 }) {
      LazyForEach(this.hotelListDataSource, (item: HotelListItemModel, index) => {
        this.hotelListCell(item)
      }, (item: string) => item)
    }
    .cachedCount(5)
    .position({ x: 0, y: 44 })
    .padding(12)
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_gray_base'))
    .onReachEnd(() => {

      console.log('=============== orderList end')

      if (!this.isLoading && this.isMore) {
        this.isLoading = true
        roomListViewModel.pageNo++
        this.loadMoreList(true)
      }
    })
  }


  build() {
    Column(){
      this.navBar()
      this.listView()
    }
    .width('100%')
    .width('100%')

  }

}