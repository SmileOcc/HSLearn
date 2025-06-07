import { YWBaseNavBar } from '@learn/baseui_har'
import { YWConstants } from '@learn/constants_har'
import { ywNavRouter, YWRouterNavParams } from '@learn/nav_router_har'
import { HotelConstants } from '../../common/HotelConstants'
import { DelicacyGroupListDataSource } from './model/DelicacyGroupListDataSource'
import { DelicacyGroupListItemModel, PackageItem } from './model/DelicacyGroupListItemModel'
import { DelicacyGroupListViewModel } from './viewmodel/DelicacyGroupListViewModel'

@Builder
export function delicacyGroupBuilder(name: string, params: YWRouterNavParams) {
  NavDestination() {
    DelicacyGroupListPage()
  }
  .hideTitleBar(true)
  .onWillDisappear(() => {
  })
  .onShown(() => {
  })
  .onHidden(() => {
  })
}

@Entry
@ComponentV2
struct DelicacyGroupListPage {
  private delicacyGroupListViewModel: DelicacyGroupListViewModel = new DelicacyGroupListViewModel()
  @Local delicacyGroupList: DelicacyGroupListItemModel[] = []
  private delicacyGroupListDataSource: DelicacyGroupListDataSource = new DelicacyGroupListDataSource()


  isLoading: boolean = false
  isMore: boolean = false
  testLoadCount: number = 0

  aboutToAppear(): void {
    this.loadMoreList()
  }

  loadMoreList() {
    console.log('===============load delicacyGroupList')
    this.delicacyGroupListViewModel.getDelicacyGroupList()
      .then(value => {
        console.log('========== delicacyGroupList return')
        // this.delicacyGroupList = this.delicacyGroupList.concat(value)
        value.flatMap((item) => {
          this.delicacyGroupListDataSource.pushData(item)
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

  // jumpBanquetList(model:BanquetHotelListItemModel) {
  //   router.pushUrl({url:'pages/home/ctrl/BanquetListPage',params:model})
  // }

  // @Builder itemEnd(index: number) {
  //   // 构建尾端滑出组件
  // }

  @Builder
  delicacyGroupListCell(item: DelicacyGroupListItemModel) {
    ListItem() {
      Column() {
        Row(){
          Image(HotelConstants.IMG_PREFIX_URL+ item.shopInfo.image)
            .alt($r('app.media.placeholder'))
            .width(45)
            .height(45)
            .borderRadius(8)
            .margin({right:6})

          Column() {
            Row(){
              Text(item.shopInfo.shopName)
                .fontColor($r('app.color.col_666666'))
                .fontSize(16)
                .fontWeight(700)
                .maxLines(1)
            }
            .margin({ bottom: 5 })

            Row(){
              Text(item.shopInfo.address)
                .fontColor(Color.Grey)
                .fontSize(12)
                .maxLines(1)

              // Blank().width(88)

              Text('月销' + item.packageInfo.shopMonthlySell + '+')
                .fontColor(Color.Grey)
                .fontSize(12)
                .maxLines(1)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .flexShrink(1)
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .margin({bottom:11})


        //下面的是:左滑动的
        Row() {
          List({ space: 12 }) {
            ForEach(item.packageInfo.packages, (packageItem: PackageItem) => {
              ListItem() {
                Column() {
                  Stack(){
                    Image(HotelConstants.IMG_PREFIX_URL + packageItem.images)
                      .width(130)
                      .height(93)
                      .borderRadius(8)
                    // .margin(10)
                    Text('月销' + packageItem.monthlySell + '+')
                      .fontSize(10)
                      .fontColor(Color.White)
                      .backgroundColor($r('app.color.col_666666'))
                  }.alignContent(Alignment.BottomStart)

                  Text(packageItem.packageName)
                    .fontSize(13)
                    .fontWeight(500)
                    .margin({bottom:4,top:3})
                  Row(){
                    Text('￥' + packageItem.discountedPrice)
                      .fontColor(Color.Red)
                      .fontSize(11).margin({right:8})
                    Text() {
                      Span('￥' + packageItem.price).fontSize(11).fontColor(Color.Grey)
                        .decoration({ type: TextDecorationType.LineThrough, color: Color.Grey })
                    }
                  }.margin({bottom:15})
                }
                .width('37%')
                .alignItems(HorizontalAlign.Start)
              }
              .swipeAction
              // (
              //   {
              //   end: {
              //     // index为该ListItem在List中的索引值。
              //     builder: () => { this.itemEnd(item.packageInfo.packages.length-1) },
              //   }
              // }
              // ) // 设置侧滑属性

            }, (packageItem: PackageItem) => JSON.stringify(packageItem))
          }
          .listDirection(Axis.Horizontal)
          // .cachedCount(3)

        }
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }

    .width('100%')

  }
  // .layoutWeight(3)

  @Builder
  listView() {
    List({ space: 18 }) {
      LazyForEach(this.delicacyGroupListDataSource, (item: DelicacyGroupListItemModel, index) => {
        this.delicacyGroupListCell(item);
      }, (item: string) => item)
      // }, ((item: DelicacyGroupListItemModel, index: number) => index) )
    }
    // .cachedCount(3)
    .position({ x: 0, y: 200 })
    .padding(5)
    .margin({left:4})
    .width('97%')
    .height('80%')
    .backgroundColor($r('app.color.bg_gray_base'))
    .onReachEnd(() => {
      console.log('=============== delicacyGroupList end')
      if (!this.isLoading && this.isMore) {
        this.isLoading = true
        this.delicacyGroupListViewModel.pageNo++
        this.loadMoreList()
      }
    })
  }

  build() {
    Column(){
      YWBaseNavBar({title:"餐厅", defaultGoBack:()=>{
        ywNavRouter.openRoute(this.getUniqueId()).back()
      }})
      Image($r('app.media.delicacy_group_list_banner'))
        .width('100%')
        .height('16%')
        .margin({top:6,bottom:6})
      this.listView()
    }
    .backgroundColor($r('app.color.bg_gray_base'))
    .width('100%')
  }

}