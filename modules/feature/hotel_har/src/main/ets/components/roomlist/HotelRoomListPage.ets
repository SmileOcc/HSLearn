import { Position, router } from '@kit.ArkUI';
import { YWBaseNavBar } from '@learn/baseui_har';
import { YWConstants } from '@learn/constants_har';
import { YWNavPath, ywNavRouter, YWRouterNavParams } from '@learn/nav_router_har';
import { RoomListItemModel } from '../hotellist/model/HotelListItemModel';
import { RoomListDataSource } from './model/RoomListDataSource';
import { HotelRoomListViewModel } from './viewmodel/HotelRoomListViewModel';

@Builder
export function hotelRoomListBuilder(name: string, params: YWRouterNavParams) {
  NavDestination() {
    HotelRoomListPage()
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

@Entry
@ComponentV2
struct HotelRoomListPage {
  @Local roomList: RoomListItemModel[] = []
  private roomListViewModel: HotelRoomListViewModel = new HotelRoomListViewModel()
  private roomListDataSource: RoomListDataSource = new RoomListDataSource()
  isLoading: boolean = false
  isMore: boolean = false
  @Local roomCount: number = 1
  testLoadCount: number = 0


  //测试
  labss:string[] = ['fdafd12','333','3333','3335','3336','3337','11333','22333','33333','44333','55333','66333']

  aboutToAppear(): void {

    this.loadMoreList(false)
  }

  loadMoreList(isLoad: boolean) {
    console.log('=============== orderList')

    //测试数据
    if (this.isLoading == false) {
      this.testLoadCount = 0
    }
    this.roomListViewModel.getRoomList()
      .then(value => {

        console.log('========== room return')
        this.roomList = this.roomList.concat(value)

        value.flatMap((item) => {
          this.roomListDataSource.pushData(item)
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

  jumpRoomDetail(model:RoomListItemModel) {
    ywNavRouter.openRoute(this.getUniqueId())
      .onTargetUrl(YWNavPath.vc_hotel_room_detail)
      .onItemInfo(model)
      .go()
  }

  @Builder
  navBar() {
    YWBaseNavBar({title:"房间列表", defaultGoBack:()=>{
      ywNavRouter.openRoute(this.getUniqueId()).back()
    }})
  }

  @Builder
  headCountView() {
    Row() {
      Text('房间数量')
        .fontSize(16)
        .fontColor($r('app.color.col_666666'))

      Row() {
        Button() {
          if (this.roomCount > 1) {
            Image($r('app.media.delete_mark'))
          } else  {
            Image($r('app.media.delete_gray_mark'))
          }
        }
        .onClick(()=>{
          if (this.roomCount > 1) {
            this.roomCount--
          }
        })
        .buttonStyle(ButtonStyleMode.TEXTUAL)
        .margin({ right: 4 })
        .width(30)
        .height(30)
        .borderColor(Color.Gray)
        .borderRadius(15)
        .borderWidth(0.5)

        TextInput({text:`${this.roomCount}`})
          .type(InputType.Number)
          .textAlign(TextAlign.Center)
          .height(35)
          .constraintSize({minWidth:35})
          .backgroundColor($r('app.color.col_FDF135'))
          .onChange((value: string) => {
            console.info(value);
            this.roomCount = Number.parseFloat(value)
          })
          .onFocus(() => {
            console.info('获取焦点');
          })
          .onSubmit((EnterKeyType) => {
            console.info(EnterKeyType + '输入法回车键的类型值')
          })
        Button() {
          Image($r('app.media.add_mark'))
            .fillColor($r('app.color.col_FFCC33'))
        }
        .onClick(()=>{
          this.roomCount++
        })
        .margin({ left: 4 })
        .buttonStyle(ButtonStyleMode.TEXTUAL)
        .borderColor(Color.Black)
        .borderRadius(15)
        .borderWidth(0.5)
        .width(30)
        .height(30)
      }
      .height('44')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.End)
    }
    .height(44)
    .width('100%')
    .padding({ left: 12, right: 12 })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(Color.White)
  }

  @Builder
  gridLabelView(labs: string[]) {
    // GridRow({ columns: 4,direction: GridRowDirection.Row }) {
    //   ForEach(labs, (item: string, index) => {
    //     GridCol() {
    //       Row() {
    //         Text(item)
    //       }.height(20)
    //     }
    //     .backgroundColor(Constants.RandomColor())
    //   })
    // }
    // .width('100%')

    Flex({justifyContent: FlexAlign.Start,wrap: FlexWrap.Wrap,alignContent: FlexAlign.SpaceEvenly}){
      // ForEach(this.labss,(labContent:string)=>{
      ForEach(labs,(labContent:string)=>{

        Text(labContent)
          .flexBasis('auto')
          .fontSize(12)
          .height(20)
          .padding({left:3,right:3})
          .backgroundColor($r('app.color.col_FDF135'))
          .borderWidth(0.5)
          .borderColor($r('app.color.col_666666'))
          .borderRadius(3)
          .margin({right:4,top:4})
          .opacity(0.5)
      })
    }
    .width('100%')

  }

  @Builder
  roomListCell(item: RoomListItemModel) {
    ListItem() {
      Row() {
        Row() {
          Image(item.imageUrl)
            .alt($r('app.media.placeholder'))
            .width(80)
            .height(80)
            .borderRadius(8)

          Column() {
            Text(item.roomName)
              .fontColor($r('app.color.col_333333'))
              .fontSize(16)
              .fontWeight(700)
              .maxLines(2)
            if (item.labelList && item.labelList.length > 0) {
              this.gridLabelView(item.labelList)
            }
          }
          .padding({left:8})
          .width('68%')
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
        }
        // .height('100%')
        .layoutWeight(7)
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        //.padding({left:8,right:8})

        Column(){
          Image($r('app.media.arrow_right_new'))
            .size({width:12,height:12})
          Text(`￥${item.price}起`)
            .fontColor($r('app.color.col_FFCC33'))
            .fontSize(14)
            .textAlign(TextAlign.End)
            .margin({top:8})
        }
        // .height('100%')
        .layoutWeight(3)
        .alignItems(HorizontalAlign.End)
        .justifyContent(FlexAlign.End)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding({top:'8vp'})
    .constraintSize({minHeight:96,maxHeight:150})
    .borderRadius(8)
    .backgroundColor($r('app.color.col_FFFFFF'))
    .onClick(()=>{
      this.jumpRoomDetail(item)
    })
  }

  @Builder
  listView() {
    List({ space: 10 }) {
      LazyForEach(this.roomListDataSource, (item: RoomListItemModel, index) => {
        this.roomListCell(item)
      }, (item: string) => item)
    }
    .cachedCount(5)
    .padding(12)
    .width('100%')
    .layoutWeight(1)
    .backgroundColor($r('app.color.bg_gray_base'))
    .onReachEnd(() => {

      console.log('=============== orderList end')

      if (!this.isLoading && this.isMore) {
        this.isLoading = true
        this.roomListViewModel.pageNo++
        this.loadMoreList(true)
      }
    })
  }

  build() {
    Column() {
      this.navBar()
      this.headCountView()
      this.listView()

    }
    // .alignContent(Alignment.TopStart)
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_base'))
  }
}