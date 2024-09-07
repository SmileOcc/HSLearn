import { Constants } from '../../../../../../../modules/common_har/src/main/ets/common/Constants';
import { NavigationBar } from '../../../common/NavigationBar';
import { CategoryModel, CategorySecondModel } from '../model/CategoryModel';
import { CategoryViewModel } from '../model/CategoryViewModel';

@Entry
@Component
export struct CategoryPage {
  @State message: string = 'Hello World cate';
  @State categoryList: Array<CategoryModel> = []
  private scroll: Scroller = new Scroller()
  private secondScroll = new Scroller()
  @State currentCategory: number = 0

  aboutToAppear() {
    this.categoryList = CategoryViewModel.getData()
    console.log('===', JSON.stringify(this.categoryList))
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
        .fontColor(Constants.COLOR_333333)
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
    Column() {
      NavigationBar({ title: '分类' }) //自定义一个视图即可
      Row() {
        List({ scroller: this.scroll }) {
          ForEach(this.categoryList, (item: CategoryModel, index: number) => {
            ListItem() {
              Text(item.title)
                .width('100vp')
                .height('60vp')
                .textAlign(TextAlign.Center)
                .backgroundColor(this.currentCategory === index ? Constants.COLOR_PAGE_BGC : Color.White)
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
      .height('92%')
      .margin({ top: 12, bottom: 12 })
      .backgroundColor(Constants.COLOR_PAGE_BGC)
    }
    .height('100%')
    .padding({ bottom: 12 })
    .backgroundColor(Constants.COLOR_PAGE_BGC)
  }
}