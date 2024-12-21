import { router } from '@kit.ArkUI';
import { TechSupportComponent } from '../view/TechSupportComponent';
import { AppInfoComponent } from '../view/AppInfoComponent';
import { LogoAndVersionComponent } from '../view/LogoAndVersionComponent';
import { CommonConstants } from '../constants/CommonConstants';
import AboutViewModel from '../viewmodel/AboutViewModel';

/**
 * This template implements the about function and contains three components.
 * The top is the LogoAndVersion component, the middle shows the relevant information of the application, and the
 * bottom is the privacy agreement and copyright statement.
 * Developers can enrich the application information and improve the relevant link information.
 */
@Entry
@Component
struct AboutPage {
  @State currentBreakPoint: string = CommonYWConstants.BREAK_POINT_SM;

  build() {
    Column() {
      this.Title()

      Scroll() {
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
              sm: CommonYWConstants.OFFSET_SM,
              md: CommonYWConstants.OFFSET_MD,
              lg: CommonYWConstants.OFFSET_LG
            }
          }) {
            Column() {
              Row() {
                LogoAndVersionComponent()
              }
              .layoutWeight(this.currentBreakPoint === CommonYWConstants.BREAK_POINT_LG ?
                CommonYWConstants.ROW_LG_WEIGHT : CommonYWConstants.ROW_WEIGHT)

              Flex({
                direction: FlexDirection.Column,
                justifyContent: FlexAlign.SpaceBetween
              }) {
                AppInfoComponent({
                  appInfoData: AboutViewModel.getAppInfo()
                })

                TechSupportComponent()
              }
              .layoutWeight(this.currentBreakPoint === CommonYWConstants.BREAK_POINT_LG ?
                CommonYWConstants.FLEX_LG_WEIGHT : CommonYWConstants.FLEX_WEIGHT)
            }
          }
        }
        .onBreakpointChange((point: string) => {
          this.currentBreakPoint = point;
        })
        .margin({
          left: $r('app.float.grid_row_margin_left'),
          right: $r('app.float.grid_row_margin_right')
        })
        .height(CommonYWConstants.SCROLL_HEIGHT_PERCENT)
        .constraintSize({ minHeight: $r('app.float.scroll_min_height') })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(CommonYWConstants.SCROLL_WEIGHT)
    }
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

      Text($r('app.string.title_name'))
        .fontSize($r('app.float.title_text_font_size'))
        .fontColor($r('app.color.title'))
        .fontWeight(CommonYWConstants.FONT_WEIGHT)
    }
    .width(CommonYWConstants.FULL_WIDTH_PERCENT)
    .height($r('app.float.title_height'))
  }
}