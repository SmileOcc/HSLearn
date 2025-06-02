import { ywNavRouter, YWRouterNavParams } from "@learn/nav_router_har"
import { ReviewType } from "./model/ReviewModel"
import { ReviewAddViewModel } from "./viewmodel/ReviewAddViewModel"
import { promptAction } from "@kit.ArkUI"
import { HotelConstants } from "../../common/HotelConstants"
import Emitter from '@ohos.events.emitter';
import { YWBaseNavBar } from "@learn/baseui_har"
import { hsLog } from "@learn/logger_har"
import { KeyboardAvoidMode } from '@kit.ArkUI';

@Builder
export function hotelReviewEditBuilder(name: string, params: YWRouterNavParams) {
  NavDestination() {
    HotelReviewEditPage()
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
struct HotelReviewEditPage {
  private reviewAddViewModel:ReviewAddViewModel = new ReviewAddViewModel()
  @Local labs: string[] = ['服务周到', '环境卫生', '设施设备', '综合体验']
  @Local labsType: ReviewType[] = [
    {title:'商务出差',isSelect:false},
    {title:'朋友出游',isSelect:false},
    {title:'情侣出游',isSelect:false},
    {title:'家庭亲子',isSelect:false},
    {title:'代人预定',isSelect:false},
    {title:'其他',isSelect:false}]
  @Local canConfirm:boolean = false
  inputTextStr:string = ''


  confirmEvent() {
    let inputTest = this.inputTextStr
    let content = inputTest
    this.reviewAddViewModel.confirmReview({
      "id": 100,
      "commentMakerName": "1***2",
      "comment": content,
      "score": 3,
      "commentTime": "2024-02-26 11:55:31",
      "hotelName": "舜和国际酒店（济南店）"
    }).then((value)=>{

      Emitter.emit(
        { eventId: HotelConstants.kReviewAddSuccessEmit, priority: Emitter.EventPriority.IMMEDIATE },
        { data: { 'success':true } }
      );

      promptAction.showDialog({title:'发表成功',message:``,alignment:DialogAlignment.Center})

      //发送通知 刷新，返回

    }).catch((error:string) =>{

    })
  }

  aboutToAppear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
  }

  aboutToDisappear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
  }

  @Builder
  labRateView(title: string, scale: number) {
    Row() {
      Text(title)
      Rating({ rating: 3, indicator: false })
        .stars(5)
        .stepSize(1)
        .width(200)
        .margin({ left: 30 })
    }
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .height(50)
  }

  build() {
    Column() {
      YWBaseNavBar({title:'发表评论', defaultGoBack:()=>{
        ywNavRouter.openRoute(this.getUniqueId()).back()
      }})
      Row() {
        Text('您愿意将我们推荐给朋友吗？')
      }
      .height(30)
      .width('100%')
      .backgroundColor(Color.Orange)
      .justifyContent(FlexAlign.Center)
      .opacity(0.3)

      Scroll() {
        Column() {

          Row() {
            Text('请选择门店')
              .margin({ right: 8 })
            Image($r('app.media.arrow_right_new'))
              .size({ width: 24, height: 24 })
          }
          .width('100%')
          .height(40)
          .justifyContent(FlexAlign.End)

          Divider().height(4).margin({ bottom: 12 })

          Rating({ rating: 5, indicator: false })
            .stepSize(1)

          Divider().height(4).margin({ top: 12, bottom: 12 })

          ForEach(this.labs, (value: string, index) => {
            this.labRateView(value, index)
          })

          Row() {
            Text('出游类型')
            Blank().width(30)
            Column() {
              Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
                ForEach(this.labsType, (item: ReviewType,index) => {
                  Text(item.title)
                    .flexBasis('auto')
                    .fontSize(12)
                    .height(30)
                    .padding({ left: 4, right: 4 })
                    .backgroundColor(item.isSelect?Color.Green: $r('app.color.col_C4C4C4'))
                    .borderWidth(0.5)
                    .borderRadius(3)
                    .margin({ right: 8, bottom: 12 })
                    .opacity(0.5)
                    .onClick(()=>{
                      item.isSelect = !item.isSelect

                      this.labsType.splice(index,1,item)
                      hsLog.i(item.isSelect+'')
                    })
                })
              }
              .width('100%')
              // .backgroundColor(Color.Yellow)
              // .flexShrink(1)
              // .padding({left:30,right:12})
              .clip(true)
            }
            .flexShrink(1)

            Blank().width(12)
          }
          .width('100%')
          .margin({ top: 12 })
          .alignItems(VerticalAlign.Top)

          Divider().height(4).margin({ top: 12, bottom: 12 })

          TextArea({ placeholder: '请留下您的宝贵意见吧~' })
            .backgroundColor($r('app.color.bg_gray_base'))
            .height(150)
            .onChange((value:string)=>{
              this.inputTextStr = value
              this.canConfirm = value.length>0 ? true: false
            })

          Blank().height(18)
          Text('其他用户将无法看到您的昵称')
          Blank().height(8)


        }
        .justifyContent(FlexAlign.Start)
        .padding(12)
        .width('100%')
      }
      .scrollable(ScrollDirection.Vertical)
      .width('100%')
      .layoutWeight(1)
      .flexShrink(1)

      // Button('提交')
      //   .buttonStyle(ButtonStyleMode.TEXTUAL)
      //   .width('100%')
      //   .height('8%')
      //   .backgroundColor(this.canConfirm?Color.Red:Color.Gray)
      //   .enabled(this.canConfirm)
      //   .fontColor(Color.White)
      //   .onClick(() => this.confirmEvent())

      Row(){
        Button('提交')
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .width('100%')
          .backgroundColor(this.canConfirm?$r('app.color.col_FFCC33'):Color.Gray)
          .fontColor(Color.White)
          .onClick(()=>this.confirmEvent())
      }
      .padding({left: '16vp', right:'16vp', top:'8vp', bottom:'8vp'})
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_gray_base'))

  }

}