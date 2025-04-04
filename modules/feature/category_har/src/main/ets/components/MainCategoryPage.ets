import { YWNavParams, ywNavManager, YWLocalNavType, ywNavRouter, YWNavPath } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"
import { YWConstants } from "@learn/constants_har"
import { CategoryModel, CategorySecondModel } from "../model/CategoryModel"
import { CategoryViewModel } from "../model/CategoryViewModel"

@Builder
export function mainCategoryBuilder(name:string, params:YWNavParams) {
  NavDestination(){
    MainCategoryPage()
  }
  .hideTitleBar(true)
}

const TAG = "MainCategoryPage"

@Component
export struct MainCategoryPage {
  @State message: string = 'Hello category';

  @State navigationMode: number = NavigationMode.Stack;

  categoryPageNav = ywNavManager.getNavStack(YWLocalNavType.NAV_MAIN_CATEGORY)

  @State categoryList: Array<CategoryModel> = []
  private scroll: Scroller = new Scroller()
  private secondScroll = new Scroller()
  @State currentCategory: number = 0

  aboutToAppear(): void {
    this.categoryList = CategoryViewModel.getData()
    const kkk = Number(AppStorage.get(YWConstants.kStatusBarHeight))
    hsLog.i(TAG, JSON.stringify(this.categoryList))
  }

  @Builder
  navPagesMap(name: string, param: YWNavParams) {
    ywNavManager.getBuilderWithPageID(YWLocalNavType.NAV_MAIN_CATEGORY)(name)?.builder(name,param)
  }

  @Builder
  classifyHeader(title: string) {
    Row() {
      Text(title)
        .textAlign(TextAlign.Start)
        .width('95%')
        .height('40vp')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(YWConstants.COLOR_333333)
        .backgroundColor(Color.White)
        .padding({ left: 8, right: 8 })

    }
  }

  @Builder
  CourseItem(item: CategorySecondModel, index: number) {
    Row() {
      Image(item.img)
        .alt($r('app.media.placeholder'))
        .height('90%')
        .aspectRatio(1)
        .borderRadius(8)
      Text(item.title)
        .padding({ left: 8 })

    }
    .backgroundColor(Color.White)
    .width('95%')
    .height('100vp')
    .padding({ left: 8, right: 8 })
  }

  scrollChangeAction(start: number, flg: Boolean) {
    if (this.currentCategory !== start) {
      this.currentCategory = start;
      if (!flg) {
        this.scroll.scrollToIndex(start);
      } else {
        this.secondScroll.scrollToIndex(start);
      }
    }
  }

  build() {
    Stack() {

      Column() {

        Row() {
          List({ scroller: this.scroll }) {
            ForEach(this.categoryList, (item: CategoryModel, index: number) => {
              ListItem() {
                Text(item.title)
                  .width('100vp')
                  .height('60vp')
                  .textAlign(TextAlign.Center)
                  .backgroundColor(this.currentCategory === index ? YWConstants.COLOR_PAGE_BGC : Color.White)
                  .onClick(() => {
                    this.scrollChangeAction(index, true)
                  })
              }
            })
          }
          .height('100%')
          .width('30%')
          .scrollBar(BarState.Off)

          List({ scroller: this.secondScroll }) {
            ForEach(this.categoryList, (item: CategoryModel, index: number) => {
              ListItemGroup({
                header: this.classifyHeader(item.title),
                space: 0
              }) {
                ForEach(item.list, (classifyItem: CategorySecondModel) => {
                  this.CourseItem(classifyItem, index)
                })
              }

            })
          }
          .sticky(StickyStyle.Header)
          .width('70%')
          .height('100%')
          .borderRadius(8)
          .onScrollIndex((start) => {
            this.scrollChangeAction(start, false)
          })

        }
        // .height('92%')
        .margin({ top: 12, bottom: 12 })
        .backgroundColor(YWConstants.COLOR_PAGE_BGC)
      }
      .height('100%')
      // .statusHeightStyle()
      .backgroundColor(YWConstants.COLOR_PAGE_BGC)
    }
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .alignContent(Alignment.BottomEnd)
    .backgroundColor(YWResColor.bgBase())
    .backgroundColor(Color.Pink)

    // .padding(getAvoidPadding(this.avoidAreas))

  }
}
