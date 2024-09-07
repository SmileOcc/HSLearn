
import { generateBarcode, scanCore } from '@kit.ScanKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { image } from '@kit.ImageKit';
import { router, window } from '@kit.ArkUI';
import { Constants } from '../../../../../../modules/common_har/src/main/ets/common/Constants';
import { FunctionCard } from './view/FunctionCard';
import { QuickFunctionCardSquare } from './view/QuickFunctionCardSquare';
import { QuickFunctionCardCircle } from './view/QuickFunctionCardCircle';
import { QuickFunctionItem, PayHubViewModel } from './viewmodel/PayHubViewModel';
import { FortunePicksViewModel } from './viewmodel/FortunePicksViewModel';
import { ServiceCardViewModel } from './viewmodel/ServiceCardViewModel';
import { ReceiveMoneyServiceCardItem, ReceiveMoneyCardViewModel } from './viewmodel/ReceiveMoneyCardViewModel';
import { QuickFunctionsViewModel } from './viewmodel/QuickFunctionsViewModel';
import { ScanQRCodeDialog } from './view/ScanQRCodeDialog';
import { BreakPointType, BreakpointTypeEnum } from '../../../../../../modules/common_har/src/main/ets/common/BreakPointSystem';
import { windowStage_ } from '../../entryability/EntryAbility';

@Entry
@Component
export struct PaymentHomePage {
  @StorageProp('currentBreakpoint') @Watch("onBreakpointChange") curBp: string = BreakpointTypeEnum.MD;
  @State @Watch("onDialogStatusChange") isDialogOpen: boolean = false;
  @State quickFunctions: Array<QuickFunctionItem> = new QuickFunctionsViewModel().getQuickFunctions();
  @State functions: Array<QuickFunctionItem> = new PayHubViewModel().getFunctionsByBreakpoints(this.curBp);
  @State sampleImages: Array<Resource> = new ServiceCardViewModel().getImagesByBreakpoints(this.curBp);
  @State fortunePicks: Array<Resource> = new FortunePicksViewModel().getFortunePicks();
  private city: string = Constants.CITY_NAME;
  private scroller: Scroller = new Scroller();
  private commonSpaceObj = new BreakPointType<Length>({
    sm: $r('app.float.space_16'),
    md: $r('app.float.space_25'),
    lg: $r('app.float.space_32')
  });


  onDialogStatusChange() {
    if (this.isDialogOpen) {
      this.dialogController.open();
    } else {
      this.dialogController.close();
    }
  }

  onBreakpointChange() {
    if (this.curBp !== Constants.BREAKPOINTS[0] && router.getState().name === 'ReceivePaymentPage') {
      router.back();
      setTimeout(() => {
        this.isDialogOpen = true;
      }, 1500)
    }
    if (this.isDialogOpen && this.curBp === Constants.BREAKPOINTS[0]) {
      this.isDialogOpen = false;
      router.pushUrl({
        url: "pages/paymentHomePage/ReceivePaymentPage"
      })
    }
  }

  private scanQRCode = () => {
    if (this.curBp === 'sm') {
      router.pushUrl({
        url: "pages/paymentHomePage/ScanQRCodePage"
      })
      return;
    }
    this.scanDialogController.open();
  };

  private receivePayment = () => {
    if (this.curBp === 'sm') {
      router.pushUrl({
        url: "pages/paymentHomePage/ReceivePaymentPage"
      });
      return;
    }
    if (!this.isDialogOpen) {
      this.isDialogOpen = true;
    }
  };

  private onCancel = () => {
    if (this.isDialogOpen) {
      this.isDialogOpen = false;
    }
  }

  private dialogController: CustomDialogController = new CustomDialogController({
    builder: ReceivePayment({ isDialogOpen: this.isDialogOpen }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    cornerRadius: Constants.CORNER_RADIUS,
    isModal: true,
    cancel: this.onCancel
  });

  private scanDialogController: CustomDialogController = new CustomDialogController({
    builder: ScanQRCodeDialog({ receivePayment: this.receivePayment }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    cornerRadius: Constants.CORNER_RADIUS,
    isModal: true,
  });

  // 实现方案有三种，分别是：
  // setWindowLayoutFullScreen方法实现沉浸式
  // 设置背景色统一实现沉浸式
  // expandSafeArea属性实现沉浸式
  aboutToAppear(): void {

    //页面中设置setWindowLayoutFullScreen
    window.getLastWindow(getContext())
      .then(win => {
        win.setWindowLayoutFullScreen(true)
      })

    this.quickFunctions[0].setClickCallback(this.scanQRCode);
    this.quickFunctions[1].setClickCallback(this.receivePayment);
  }

  //导航栏颜色
  // onPageShow(): void {
  //   windowStage_.getMainWindowSync().setWindowBackgroundColor("#3372EF")
  // }
  // onPageHide(): void {
  //   windowStage_.getMainWindowSync().setWindowBackgroundColor("#ffffff")
  //
  // }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image($r("app.media.header_background"))
        .height($r("app.float.background_image_height"))
        .width(Constants.FULL_WIDTH)
        .objectFit(ImageFit.Fill)
      Scroll(this.scroller) {
        Column() {
          Row() {
            Row() {
              Image($r("app.media.ic_public_gps"))
                .width($r("app.float.icon_size"))
                .height($r("app.float.icon_size"))
                .fillColor(Color.White)
                .margin({ right: Constants.CONTENT_SPACE[0] })
              Text(this.city)
                .fontColor(Color.White)
                .fontSize($r("app.float.bigger_font_size"))
                .fontFamily($r("app.string.normal_font_family"))
                .fontWeight(Constants.FONT_WEIGHT[0])
            }

            Blank()

            Row() {
              Search({ placeholder: $r("app.string.search_box_placeholder") })
                .enableKeyboardOnFocus(false)
                .placeholderColor(Color.White)
                .placeholderFont({
                  family: $r("app.string.normal_font_family"),
                  size: $r("app.float.middle_font_size"),
                  weight: Constants.FONT_WEIGHT[0]
                })
                .borderColor($r('app.color.five_percent_white'))
                .searchIcon({color: Color.White})
                .fontColor(Color.White)
                .width(this.curBp === Constants.BREAKPOINTS[0] ?
                $r("app.float.search_box_width_in_small_device") :
                $r("app.float.search_box_width_in_big_device"))
                .margin({
                  right: this.curBp === Constants.BREAKPOINTS[0] ?
                  Constants.CONTENT_SPACE[5] :
                  Constants.CONTENT_SPACE[7],
                })

              Image($r("app.media.ic_public_more"))
                .width($r("app.float.icon_size"))
                .height($r("app.float.icon_size"))

            }

          }
          .width(Constants.FULL_WIDTH)
          .height($r("app.float.header_height"))
          .margin({ bottom: Constants.CONTENT_SPACE[6] })
          .padding({
            left: this.commonSpaceObj.getValue(this.curBp),
            right: this.commonSpaceObj.getValue(this.curBp)
          })

          //四个快速入口
          GridRow({
            gutter: {
              x: {
                sm: $r('app.float.quick_function_row_gutter_sm'),
                md: $r("app.float.quick_function_space_in_md_device"),
                lg: $r("app.float.quick_function_space_in_lg_device")
              }
            }
          }) {
            ForEach(this.quickFunctions, (item: QuickFunctionItem) => {
              GridCol({ span: Constants.GRID_COL_SPAN[0] }) {
                if (this.curBp === Constants.BREAKPOINTS[0]) {
                  QuickFunctionCardCircle({ quickFunctionItem: item })
                } else {
                  QuickFunctionCardSquare({ quickFunctionItem: item })
                }
              }

              .onClick(() => {
                if (item.getClickCallback()) {
                  item.getClickCallback()();
                }
              })
            }, (item: QuickFunctionItem) => item.getText())
          }
          .width(Constants.FULL_WIDTH)
          .height(new BreakPointType<Length>({
            sm: $r("app.float.quick_function_card_height_sm"),
            md: $r("app.float.quick_function_card_height_md"),
            lg: $r("app.float.quick_function_card_height_lg")
          }).getValue(this.curBp))
          .margin({ bottom: $r('app.float.quick_function_margin_bottom') })
          .padding({
            left: new BreakPointType<Length>({
              sm: $r('app.float.space_16'),
              md: $r('app.float.space_45'),
              lg: $r('app.float.space_62')
            }).getValue(this.curBp),
            right: new BreakPointType<Length>({
              sm: $r('app.float.space_16'),
              md: $r('app.float.space_45'),
              lg: $r('app.float.space_62')
            }).getValue(this.curBp)
          })

          //其他菜单功能块
          Column() {
            GridRow({
              columns: {
                sm: Constants.GRID_ROW_COLUMNS[0],
                md: Constants.GRID_ROW_COLUMNS[1],
                lg: Constants.GRID_ROW_COLUMNS[2]
              },
              gutter: {
                x: {
                  sm: $r('app.float.function_card_item_x_space_sm'),
                  md: $r('app.float.function_card_item_x_space_md'),
                  lg: $r('app.float.function_card_item_x_space_lg')
                },
                y: {
                  sm: $r('app.float.function_card_item_y_space_sm'),
                  md: $r('app.float.function_card_item_y_space_md'),
                  lg: $r('app.float.function_card_item_y_space_lg')
                }
              }
            }) {
              ForEach(this.functions, (item: QuickFunctionItem) => {
                GridCol() {
                  FunctionCard({ data: item })
                }
              }, (item: QuickFunctionItem, index: number) => index + JSON.stringify(item))
            }
            .width(Constants.FULL_WIDTH)
            .backgroundColor(Color.White)
            .borderRadius($r("app.float.bigger_border_radius"))
            .onBreakpointChange((breakpoints: string) => {
              this.functions = new PayHubViewModel().getFunctionsByBreakpoints(breakpoints);
              // close dialog.
              if (this.isDialogOpen) {
                this.isDialogOpen = false;
              }
            })
            .backgroundImageSize(ImageSize.Cover)
            .padding({
              top: new BreakPointType<Length>({
                sm: $r('app.float.space_16'),
                md: $r('app.float.space_16'),
                lg: $r('app.float.space_24')
              }).getValue(this.curBp),
              bottom: new BreakPointType<Length>({
                sm: $r('app.float.space_16'),
                md: $r('app.float.space_16'),
                lg: $r('app.float.space_24')
              }).getValue(this.curBp),
              left: new BreakPointType<Length>({
                sm: 0,
                md: 0,
                lg: $r('app.float.space_32')
              }).getValue(this.curBp),
              right: new BreakPointType<Length>({
                sm: 0,
                md: 0,
                lg: $r('app.float.space_32')
              }).getValue(this.curBp)
            })

            GridRow({
              gutter: { x: { sm: Constants.CONTENT_SPACE[4] } }
            }) {
              ForEach(this.sampleImages, (item: Resource) => {
                GridCol({
                  span: {
                    sm: Constants.GRID_COL_SPAN[2],
                    md: Constants.GRID_COL_SPAN[1],
                    lg: Constants.GRID_COL_SPAN[0]
                  }
                }) {
                  Image(item)
                    .width(Constants.FULL_WIDTH)
                }
              }, (item: Resource, index: number) => index + JSON.stringify(item))
            }
            .width(Constants.FULL_WIDTH)
            .margin({
              top: new BreakPointType<Length>({
                sm: $r('app.float.space_16'),
                md: $r('app.float.space_12'),
                lg: $r('app.float.space_16')
              }).getValue(this.curBp)
            })
            .onBreakpointChange((breakpoints: string) => {
              this.sampleImages = new ServiceCardViewModel().getImagesByBreakpoints(breakpoints);
            })

            Text($r("app.string.fortune_pick"))
              .width(Constants.FULL_WIDTH)
              .height($r("app.float.fortune_pick_height"))
              .fontFamily($r("app.string.medium_font_family"))
              .fontSize($r("app.float.middle_font_size"))
              .fontColor($r("app.color.fortune_pick_font_color"))
              .textAlign(TextAlign.Start)
              .lineHeight($r("app.float.fortune_pick_height"))
              .fontWeight(Constants.FONT_WEIGHT[1])
              .margin({ top: $r("app.float.fortune_pick_margin"), bottom: $r("app.float.fortune_pick_margin") })

            GridRow({

              //不设置md的，使用了sm的了
              // gutter: { x: { sm: Constants.CONTENT_SPACE[4],md:Constants.CONTENT_SPACE[11]}, y: { sm: Constants.CONTENT_SPACE[4] } }
              gutter: { x: { sm: Constants.CONTENT_SPACE[4]}, y: { sm: Constants.CONTENT_SPACE[4] } }

            }) {
              ForEach(this.fortunePicks, (item: Resource) => {
                GridCol({
                  span: {
                    sm: Constants.GRID_COL_SPAN[2],
                    md: Constants.GRID_COL_SPAN[1],
                    lg: Constants.GRID_COL_SPAN[0]
                  }
                }) {
                  Image(item)
                    .width(Constants.FULL_WIDTH)
                }
              }, (item: Resource, index: number) => index + JSON.stringify(item))

            }
            .width(Constants.FULL_WIDTH)
          }
          .width(Constants.FULL_WIDTH)
          .borderRadius($r("app.float.bigger_border_radius"))
          .backgroundColor(this.curBp === Constants.BREAKPOINTS[2] ? Color.Transparent : Color.White)
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Center)
          .padding({
            left: this.commonSpaceObj.getValue(this.curBp),
            right: this.commonSpaceObj.getValue(this.curBp)
          })
        }
        .width(Constants.FULL_WIDTH)
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .scrollBarColor(Color.Gray)
      .scrollBarWidth(Constants.SCROLL_BAR_WIDTH)
      .edgeEffect(EdgeEffect.Fade)
      .padding({top:36,bottom:24})
    }
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

  }
}

@CustomDialog
struct ReceivePayment {
  controller?: CustomDialogController;
  @State pixelMap: image.PixelMap | undefined = undefined;
  @State receiveMoneyServiceCard: ReceiveMoneyServiceCardItem[] =
    new ReceiveMoneyCardViewModel().getReceiveMoneyServiceCards();
  @Link isDialogOpen: boolean;
  private timer: number | null = null;

  aboutToAppear(): void {
    this.updateQRCode();
    this.timer = setInterval(() => {
      this.updateQRCode();
    }, 30 * 1000)
  }

  private updateQRCode(): void {
    let content: string = (new Date()).valueOf().toString();
    let options: generateBarcode.CreateOptions = {
      scanType: scanCore.ScanType.QR_CODE,
      height: Constants.QRCODE_SIZE,
      width: Constants.QRCODE_SIZE
    };
    generateBarcode.createBarcode(content, options, (error: BusinessError, pixelMap: image.PixelMap) => {
      if (error) {
        hilog.error(0x0001, '[generateBarcode]', 'Callback error: %{public}s', JSON.stringify(error));
        return;
      }
      this.pixelMap = pixelMap;
    })
  }

  aboutToDisappear(): void {
    this.pixelMap = undefined;
    this.timer = null;
  }

  build() {
    Column() {
      Row() {
        Text($r("app.string.personal_receive_money"))
          .fontFamily($r("app.string.bold_font_family"))
          .fontSize($r("app.float.biggest_font_size"))
          .fontColor(Color.Black)
          .fontWeight(Constants.FONT_WEIGHT_700)

        Image($r("app.media.ic_close"))
          .width($r("app.float.icon_close_size"))
          .height($r("app.float.icon_close_size"))
          .onClick(() => {
            this.isDialogOpen = false;
          })
      }
      .width(Constants.FULL_WIDTH)
      .height($r('app.float.title_line_height'))
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)

      Text($r("app.string.slogan"))
        .fontFamily($r("app.string.normal_font_family"))
        .fontSize($r("app.float.smaller_font_size"))
        .fontColor(Color.Black)
        .textAlign(TextAlign.Center)
        .fontWeight(Constants.FONT_WEIGHT[0])

      Text($r("app.string.user_name"))
        .fontFamily("HarmonyHeiTi-Medium")
        .fontSize($r("app.float.middle_font_size"))
        .fontColor(Color.Black)
        .textAlign(TextAlign.Center)
        .fontWeight(Constants.FONT_WEIGHT[1])

      Stack({ alignContent: Alignment.Center }) {
        Row() {
          Image(this.pixelMap)
            .width(Constants.FULL_WIDTH)
            .height(Constants.FULL_HEIGHT)
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)

        Image($r('app.media.avatar'))
          .width($r('app.float.avatar_size'))
          .height($r('app.float.avatar_size'))

      }
      .width($r("app.float.receive_money_container_size"))
      .height($r("app.float.receive_money_container_size"))
      .margin({
        top: $r("app.float.receive_money_container_margin_top"),
        bottom: $r("app.float.receive_money_container_margin_bottom")
      })

      Row() {
        Text($r("app.string.set_amount"))
          .fontFamily($r("app.string.normal_font_family"))
          .fontSize($r("app.float.smaller_font_size"))
          .fontColor(Color.Black)
          .textAlign(TextAlign.Center)
          .fontWeight(Constants.FONT_WEIGHT[1])
          .width($r("app.float.receive_money_card_bottom_text_width"))
          .height($r("app.float.set_amount_height"))
          .textAlign(TextAlign.Center)
        Divider()
          .vertical(true)
          .color($r("app.color.divider_color"))
          .height($r("app.float.divider_height"))
        Text($r("app.string.save_image"))
          .fontFamily($r("app.string.normal_font_family"))
          .fontSize($r("app.float.smaller_font_size"))
          .fontColor(Color.Black)
          .textAlign(TextAlign.Center)
          .fontWeight(Constants.FONT_WEIGHT[1])
          .width($r("app.float.receive_money_card_bottom_text_width"))
          .height($r("app.float.save_image_height"))
          .textAlign(TextAlign.Center)
      }

      Column() {
        ForEach(this.receiveMoneyServiceCard, (item: ReceiveMoneyServiceCardItem) => {
          Row() {
            Image(item.getImage())
              .width($r("app.float.receive_money_service_card_image_width"))
              .height($r("app.float.receive_money_service_card_image_height"))
              .margin({ right: Constants.CONTENT_SPACE[6] })
              .objectFit(ImageFit.Contain)

            Row() {
              Text(item.getText())
                .fontFamily($r("app.string.medium_font_family"))
                .fontSize($r("app.float.middle_font_size"))
                .fontColor(Color.Black)
                .textAlign(TextAlign.Start)
                .lineHeight($r("app.float.receive_money_service_card_text_line_height"))
                .fontWeight(Constants.FONT_WEIGHT[1])

              Row() {
                if (item.getBrief()) {
                  Text(item.getBrief())
                    .opacity(Constants.OPACITY)
                    .fontFamily($r("app.string.normal_font_family"))
                    .fontSize($r("app.float.smaller_font_size"))
                    .fontColor(Color.Black)
                    .textAlign(TextAlign.End)
                    .lineHeight($r("app.float.brief_line_height"))
                    .fontWeight(Constants.FONT_WEIGHT[0])
                    .margin({ right: $r("app.float.brief_margin_right") })
                }
                Image($r("app.media.right_arrow"))
                  .width($r("app.float.right_arrow_width"))
                  .height($r("app.float.right_arrow_height"))
              }
            }
            .layoutWeight(Constants.LAYOUT_WEIGHT)
            .height(Constants.FULL_HEIGHT)
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .border({
              width: { bottom: $r("app.float.divider_border_width") },
              color: { bottom: $r("app.color.border_divider_color") },
            })
          }
          .width(Constants.FULL_WIDTH)
          .height($r("app.float.receive_money_bottom_card_height"))
        })
      }
      .width(Constants.FULL_WIDTH)
      .margin({ top: $r("app.float.receive_money_bottom_card_margin_top") })
    }
    .width($r("app.float.receive_money_card_width"))
    .height($r("app.float.receive_money_card_height"))
    .padding({
      top: $r('app.float.dialog_padding_top'),
      left: $r('app.float.dialog_padding_normal'),
      right: $r('app.float.dialog_padding_normal'),
      bottom: $r('app.float.dialog_padding_normal')
    })
    .backgroundColor(Color.White)
    .opacity(Constants.PERCENT_90_OPACITY)
    .backdropBlur(Constants.BACK_DROP_BLUR_60)
    .borderRadius($r('app.float.br24'))
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(HorizontalAlign.Center)
  }
}