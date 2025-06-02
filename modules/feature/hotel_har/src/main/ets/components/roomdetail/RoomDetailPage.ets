import { YWDateUtils } from '@learn/common_har';
import { OrderItemInfo, RoomListItemModel } from '../hotellist/model/HotelListItemModel'
import { DateAlertView } from './view/DateAlertView';
import { RoomDetailViewModel } from './viewmodel/RoomDetailViewModel';
import { promptAction } from '@kit.ArkUI';
import { YWBaseNavBar } from '@learn/baseui_har';
import { ywNavRouter, YWRouterNavParams } from '@learn/nav_router_har';
import { YWConstants } from '@learn/constants_har';


@Builder
export function hotelRoomDetailBuilder(name: string, params: YWRouterNavParams) {
  NavDestination() {
    RoomDetailPage({params: params})
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

class DetailDescInfo {
  title:string|undefined
  desc:string|undefined
}

@Entry
@ComponentV2
struct RoomDetailPage {

  @Param @Require @Once params: YWRouterNavParams

  @Local sourceModel:RoomListItemModel = new RoomListItemModel()

  @Local startDate:Date = new Date()
  @Local endDate:Date = new Date()
  selectDayIndex = 0

  private roomDetailViewModel: RoomDetailViewModel = new RoomDetailViewModel()
  @Local sourceDate:Date|undefined = new Date

  //监听sourceDate
  @Monitor('sourceDate')
  onStrChange(monitor: IMonitor){
    monitor.dirty.forEach((path:string)=>{
      console.log('修改前：',monitor.value(path)?.before)
      console.log('修改后：',monitor.value(path)?.now
      )
    })
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: DateAlertView({
      cancel: this.onCancel,
      confirm: this.onAccept,
      sourceDate: this.sourceDate,
      minStartDate: this.startDate
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })



  @Local toolList:Array<Record<string,ResourceStr>> = [
    {'img':$r("app.media.ic_mmember"),'title':'20m'},
    {'img':$r("app.media.ic_mmember"),'title':'2-5层'},
    {'img':$r("app.media.ic_mmember"),'title':'免费WiFi'},
    {'img':$r("app.media.ic_mmember"),'title':'有窗'},
    {'img':$r("app.media.ic_mmember"),'title':'2张1.2米床'},
    {'img':$r("app.media.ic_mmember"),'title':'含送机'}]


  @Local descList:DetailDescInfo[] = [
    {
      title:'便利设施',
      desc:'雨伞、书桌、熨衣设备、多种规格电源插座、110V电压插座、房内保险箱、空调、衣柜/衣橱、暖气、闹钟、针线包、220V电压插座、自动窗帘、电子秤、房间内高速上网、客房WIFI免费'
    },
    {
      title:'媒体科技',
      desc:'国内长途电话、国际长途电话、有线频道、液晶电视机、音响'
    },
    {
      title:'食品饮品',
      desc:'电热水壶、茶壶、瓶装水免费、迷你吧、小冰箱'
    }
  ]
  bgScrollView = new Scroller()

  sourceDateEvent() {
    if (this.selectDayIndex == 0 && this.sourceDate) {
      this.startDate = this.sourceDate
    } else if (this.selectDayIndex == 1 && this.sourceDate) {
      this.endDate = this.sourceDate
    }

  }


  selectStartDateEvent() {
    this.selectDayIndex = 0
    this.sourceDate = this.startDate
    this.dialogController.open()

  }
  selectEndDateEvent(){
    this.selectDayIndex = 1
    this.sourceDate = this.endDate
    this.dialogController.open()
  }

  onCancel() {
    console.info('Callback when the first button is clicked')
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
  }

  exitApp() {
    console.info('Click the callback in the blank area')
  }

  // 在自定义组件即将析构销毁时将dialogControlle置空
  aboutToDisappear() {
    // this.dialogController = null // 将dialogController置空
    this.dialogController.close()
  }

  aboutToAppear(): void {
    // let parsModel = router.getParams() as RoomListItemModel
    // if (parsModel) {
    //   //请求详情
    //   this.sourceModel = parsModel
    // }
    let itemInfo = this.params.itemInfo as RoomListItemModel
    if (itemInfo) {
      this.sourceModel = itemInfo
    }

    console.log(`======== title:${this.sourceModel.roomName}`)
  }


  confirmRoomEvent(){

    let roomName = '门牌号：' + Math.round(1000 * Math.random())
    let orderInfo:OrderItemInfo =     {
      id:11,
      orderStatus:'101',
      hotelName:'occ 酒店',
      roomName:roomName,
      arrDate:YWDateUtils.dateNumberYearMonthDay(this.startDate),
      depDate:YWDateUtils.dateNumberYearMonthDay(this.endDate),
      nights:2,
      rmQty:12,
      actualPaidPrice:'999'
    }

    this.roomDetailViewModel.confirmRoom(orderInfo)
      .then(value=>{
        promptAction.showDialog({title:'预订成功',message:`房间:${roomName}`,alignment:DialogAlignment.Center})
      })
      .catch((error:string) =>{

      })
  }


  @Builder topBannerView() {
    List({space:12}){
      ListItem(){
        Image(this.sourceModel.imageUrl)
      }
      .width('98%')
      ListItem(){
        Image(this.sourceModel.imageUrl)
      }
      .width('98%')

      ListItem(){
        Image(this.sourceModel.imageUrl)
      }
      .width('98%')
    }
    .scrollBar(BarState.Off)
    .listDirection(Axis.Horizontal)
    .width('100%')
    .aspectRatio(2.0/1.0)
    .backgroundColor(Color.White)
    .padding({left:16,right:16})
  }

  @Builder goodsInfoView() {
    Column(){
      Row(){
        Text(this.sourceModel.roomName ?? '房间')
          .fontColor($r('app.color.col_333333'))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text('不含早')
          .padding({left:8,top:4,right:8,bottom:4})
          .borderRadius(4)
          .borderColor($r('app.color.col_666666'))
          .borderWidth(1)
          .fontSize(14)
          .fontColor($r('app.color.col_666666'))
          .margin({left:24})
        Blank()
      }
      .width('100%')
      Row(){
        Text('价格可能浮动，建议尽快预订')
          .fontColor($r('app.color.col_FFCC33'))
          .fontSize(16)
        // .fontWeight(FontWeight.Bold)

        Blank()

        Text(this.sourceModel.price ?? '未知')
          .fontColor($r('app.color.col_FFCC33'))
          .fontSize(24)
        // .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .padding({top:8})
    }
    .alignItems(HorizontalAlign.Start)
    .padding({left:16,right:16,top:12,bottom:12})
    .backgroundColor(Color.White)

  }

  @Builder timeInfoView(){
    Column(){
      Row(){
        Row(){
          Row(){
            Text(YWDateUtils.dateMonthDay(this.startDate))
            Text(`周${YWDateUtils.dayNumberToUpNumber(this.startDate.getDay())}`)
              .margin({left:8})
              .fontColor($r('app.color.col_999999'))
              .fontSize(13)
          }
          .onClick(()=>{
            this.selectStartDateEvent()
          })
          .width(100)

          Divider().width(15).height(1).backgroundColor(Color.Gray)
          Row(){
            Text(YWDateUtils.dateMonthDay(this.endDate))
            Text(`周${YWDateUtils.dayNumberToUpNumber(this.endDate.getDay())}`)
              .margin({left:8})
              .fontColor($r('app.color.col_999999'))
              .fontSize(13)
          }
          .onClick(()=>{
            this.selectEndDateEvent()
          })
        }
        .layoutWeight(8)
        .justifyContent(FlexAlign.SpaceBetween)
        Text('共1晚')
          .layoutWeight(2)
          .textAlign(TextAlign.End)
          .fontWeight(FontWeight.Bold)
      }
      .alignItems(VerticalAlign.Center)
      .height(44)
      .margin({bottom:12})

      Divider().height(1).backgroundColor($r('app.color.col_60CD8E'))

      Row() {
        Text('房间数量')
          .fontSize(16)
          .fontColor($r('app.color.col_666666'))

        Row() {
          Button() {
            Image($r('app.media.delete_gray_mark'))
          }
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .margin({ right: 4 })
          .width(30)
          .height(30)
          .borderColor(Color.Gray)
          .borderRadius(15)
          .borderWidth(0.5)

          TextInput({text:'1', placeholder:'1'})
            .type(InputType.Number)
            .textAlign(TextAlign.Center)
            .height(35)
            .constraintSize({minWidth:35})
            .backgroundColor($r('app.color.col_FF9318'))
            .onChange((value: string) => {
              console.info(value);
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
      .margin({top:12})
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor(Color.White)
    }
    .padding({left:16,right:16})
    .margin({top:'12vp'})
    .width('100%')
    .backgroundColor(Color.White)
  }

  @Builder toolsView() {

    Flex({justifyContent: FlexAlign.Start,wrap: FlexWrap.Wrap,alignContent: FlexAlign.SpaceEvenly}){
      ForEach(this.toolList,(item:Record<string,ResourceStr>,index)=>{

        Column(){
          Image($r('app.media.ic_mmember'))
            .size({width:30,height:30})
          Text(item['title'])
        }
        .padding({top:'8vp'})
        .constraintSize({maxWidth:'25%', minWidth:80})
        // .flexBasis('auto')
        // .margin({top:12})
      })
    }
    .width('100%')
    .padding({left:'16vp', top:'4vp', bottom:'12vp', right:'16vp'})
    .margin({top:'12vp'})
    .backgroundColor(Color.White)

  }

  @Builder bottomDescView(){
    Column(){
      ForEach(this.descList,(item:DetailDescInfo)=> {

        Row(){
          Text(item.title)
            .layoutWeight(2.5)
            .fontSize(14)
            .fontColor($r('app.color.col_999999'))

          Text(item.desc)
            .fontSize(13)
            .fontColor($r('app.color.col_666666'))
            .layoutWeight(7.5)
        }
        .margin({top:12})
        .width('100%')
      })
    }
    .width('100%')
    .margin({top:'12vp'})
    .padding({left:16,right:16,top:12,bottom:24})
    .backgroundColor(Color.White)
  }

  build() {

    Column(){
      YWBaseNavBar({title: this.sourceModel.roomName ?? "", defaultGoBack:()=>{
        ywNavRouter.openRoute(this.getUniqueId()).back()
      }})
      Scroll(){
        Column(){
          this.topBannerView()

          this.goodsInfoView()

          this.timeInfoView()

          this.toolsView()
          this.bottomDescView()

        }
      }
      .padding({bottom:16})
      .width('100%')
      .backgroundColor($r('app.color.bg_gray_base'))
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Auto)
      // .edgeEffect(EdgeEffect.Spring)
      .onScrollStart(() => {
        //console.log("滚动==开始")
      })
      .onScroll((a, b) => {
        //console.log(`滚动===${a} : ${b}`)
      })
      .onScrollStop(() => {
        //console.log("滚动==结束")

      })
      .onScrollEdge((edg) => {
        //滚动到边缘事件回调
        console.log(edg.toString())
      })
      // .constraintSize({maxHeight:Constants.SCREEN_HEIGHT() * 0.84 - 13 - 34})
      .layoutWeight(1)
      Row(){
        Button('预订房间')
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .width('100%')
          .backgroundColor($r('app.color.col_FFCC33'))
          .fontColor(Color.White)
          .onClick(()=>this.confirmRoomEvent())
      }
      .backgroundColor($r('app.color.col_FFFFFF'))
      .padding({left: '16vp', right:'16vp', top:'8vp', bottom:'8vp'})

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_gray_base'))
    .justifyContent(FlexAlign.SpaceBetween)
    // .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.BOTTOM])
  }
}