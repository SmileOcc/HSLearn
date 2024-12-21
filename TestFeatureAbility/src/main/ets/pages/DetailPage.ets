import { router } from '@kit.ArkUI';
import { DetailListComponent } from '../view/DetailListComponent';
import { CommonConstants } from '../constants/CommonConstants';
import { DataItem } from '../viewmodel/DataItem';
import AboutViewModel from '../viewmodel/AboutViewModel';

/**
 * Detail page. Click the item on about page to jump to the detail page.
 */
@Entry
@Component
struct DetailPage {
  private titleParam: Resource = $r('app.string.detail_default_title');
  private dataParam: Array<DataItem> = AboutViewModel.getDefaultDetailInfo();

  aboutToAppear() {
    if (router.getParams()) {
      let param = router.getParams() as Record<string, Object>;
      this.titleParam = param[CommonYWConstants.KEY_PARAM_TITLE] as Resource;
      this.dataParam = param[CommonYWConstants.KEY_PARAM_DATA] as Array<DataItem>;
    }
  }

  build() {
    Column() {
      this.Title()

      GridRow({
        columns: {
          sm: CommonYWConstants.GRID_ROW_SM,
          md: CommonYWConstants.GRID_ROW_MD,
          lg: CommonYWConstants.GRID_ROW_LG
        },
        gutter: { x: CommonYWConstants.GUTTER_X },
        breakpoints: { value: CommonYWConstants.BREAK_POINT }
      }) {
        GridCol({
          span: {
            sm: CommonYWConstants.SPAN_SM,
            md: CommonYWConstants.SPAN_MD,
            lg: CommonYWConstants.SPAN_LG
          },
          offset: {
            md: CommonYWConstants.OFFSET_MD,
            lg: CommonYWConstants.OFFSET_LG
          }
        }) {
          DetailListComponent({ detailList: this.dataParam })
        }
      }
      .margin({
        left: $r('app.float.grid_row_margin_left'),
        right: $r('app.float.grid_row_margin_right')
      })
    }
    .width(CommonYWConstants.DETAIL_COLUMN_WIDTH_PERCENT)
    .height(CommonYWConstants.DETAIL_COLUMN_HEIGHT_PERCENT)
    .backgroundColor($r('app.color.page_background'))
  }

   @Builder Title() {
    Row() {
      Image($r('app.media.ic_back'))
        .width($r('app.float.image_size'))
        .height($r('app.float.image_size'))
        .margin({
          left: $r('app.float.image_margin_left'),
          right: $r('app.float.image_margin_right')
        })
        .onClick(() => {
          router.back();
        })

      Text(this.titleParam)
        .fontColor($r('app.color.title'))
        .fontSize($r('app.float.title_text_font_size'))
    }
    .width(CommonYWConstants.FULL_WIDTH_PERCENT)
    .height($r('app.float.title_height'))
  }
}