
import { router } from '@kit.ArkUI';
import { YWBaseNavBar } from '@learn/baseui_har';
import { YWConstants } from '@learn/constants_har';
import { YWNavPath, ywNavRouter, YWRouterNavParams } from '@learn/nav_router_har';
import Emitter from '@ohos.events.emitter';
import { HotelConstants } from '../../common/HotelConstants';
import { ReviewListDataSource } from './model/ReviewListDataSource';
import { ReviewModel } from './model/ReviewModel';
import { ReviewViewModel } from './viewmodel/ReviewViewModel';


@Builder
export function reviewListBuilder(name: string, params: YWRouterNavParams) {
  NavDestination() {
    ReviewListPage()
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
struct ReviewListPage {

  private reviewListViewModel: ReviewViewModel = new ReviewViewModel()
  @Local reviewList: ReviewModel[] = []
  @Local listDataSource: ReviewListDataSource<ReviewModel> = new ReviewListDataSource<ReviewModel>()
  @Local labs:string[] = ['服务周到 2','环境卫生 2','设施设备 2','综合体验 2']
  isLoading: boolean = false
  isMore: boolean = false
  @Local reviewCount: number = 0

  aboutToAppear(): void {

    this.loadMoreList(false)

    Emitter.on({ eventId: HotelConstants.kReviewAddSuccessEmit }, (event) => {
      this.loadMoreList(false)
    });
  }

  aboutToDisappear(): void {
    Emitter.off(HotelConstants.kReviewAddSuccessEmit);

  }

  loadMoreList(isLoad: boolean) {
    console.log('=============== orderList')

    this.reviewListViewModel.getReviewList()
      .then(value => {

        console.log('========== room return')
        this.reviewList = this.reviewList.concat(value)

        value.flatMap((item) => {
          this.listDataSource.pushData(item)
        })

        this.isLoading = false
        this.isMore = false

        if (value && value.length >= YWConstants.kPageSize20) {
          this.isMore = true

        }
      })
  }

  goReviewEvent(){
    ywNavRouter.openRoute(this.getUniqueId())
      .onTargetUrl(YWNavPath.vc_hotel_review_edit)
      .onRouteMode()
      .go()
  }

  @Builder itemView(item:ReviewModel) {
    ListItem() {
      Column(){
        Row(){
          Row(){
            Image($r('app.media.user_avatar'))
              .width(70)
              .height(70)
              .borderRadius(35)
              .objectFit(ImageFit.Fill)
              .clip(true)
            Column(){
              Text(item.commentMakerName)
              Rating({rating:item.score, indicator:false})
                .stars(5)
                .stepSize(1)
                .width(80)
            }
            .height(60)
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({left:8})
          }
          .alignItems(VerticalAlign.Center)

          Column(){
            Text(item.commentTime)
              .fontColor($r('app.color.col_999999'))
              .fontSize(13)
              .textAlign(TextAlign.End)
            Text(item.hotelName)
              .fontColor($r('app.color.col_999999'))
              .fontSize(13)
              .textAlign(TextAlign.End)
          }
          .height(60)
          .alignItems(HorizontalAlign.End)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .width('100%')

        Divider()
          .backgroundColor($r('app.color.col_EEEEEE'))
          .height(1)
          .margin({top:12})

        Text(item.comment)
          .fontSize(14)
          .fontColor($r('app.color.col_666666'))
          .maxLines(3)
          .margin({top:12})
      }
      .alignItems(HorizontalAlign.Start)
      .padding({left:12, right:12, top:12, bottom:12})
      .width('100%')

    }
    .width('100%')
    .padding(8)
    .borderRadius(8)
    .backgroundColor(Color.White)
    .onClick(()=>{
    })
  }

  build() {
    Row() {
      Column(){
        YWBaseNavBar({title:'反馈', defaultGoBack:()=>{
          ywNavRouter.openRoute(this.getUniqueId()).back()
        }})
        Column(){
          Flex({justifyContent: FlexAlign.Start,wrap: FlexWrap.Wrap,alignContent: FlexAlign.SpaceEvenly}){
            ForEach(this.labs,(labContent:string)=>{
              Text(labContent)
                .flexBasis('auto')
                .fontSize(12)
                .height(30)
                .padding({left:4,right:4})
                .backgroundColor($r('app.color.bg_gray_base'))
                .borderWidth(0.5)
                .borderRadius(3)
                .margin({right:12,top:4})
                .opacity(0.5)
            })
          }
          .width('100%')
          .margin({top:8,bottom:24})
        }
        .constraintSize({minHeight:54})
        .padding({left:12,right:12})
        .backgroundColor(Color.White)

        List({ space: 10 }) {
          LazyForEach(this.listDataSource, (item: ReviewModel, index) => {
            this.itemView(item)


          }, (item: string) => item)
        }
        .cachedCount(5)
        .flexShrink(1)
        .margin({left:12,right:12,top:12,bottom:12})
        .borderRadius(8)

        .width('100%')
        .backgroundColor($r('app.color.bg_gray_base'))
        .onReachEnd(() => {

          console.log('=============== orderList end')

          if (!this.isLoading && this.isMore) {
            this.isLoading = true
            this.reviewListViewModel.pageNo++
            this.loadMoreList(true)
          }
        })
        // .backgroundColor(Constants.COLOR_BLUE)
        .scrollBar(BarState.Auto)
        // //自动填充空白
        // Blank().backgroundColor(Color.Red)


        Row(){
          Button('去评论')
            .buttonStyle(ButtonStyleMode.TEXTUAL)
            .width('100%')
            .backgroundColor($r('app.color.col_FFCC33'))
            .fontColor(Color.White)
            .onClick(()=>this.goReviewEvent())
        }
        .backgroundColor($r('app.color.col_FFFFFF'))
        .padding({left: '16vp', right:'16vp', top:'8vp', bottom:'8vp'})
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.bg_gray_base'))
      .justifyContent(FlexAlign.SpaceBetween)
      .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.BOTTOM])
    }
    .height('100%')
  }
}