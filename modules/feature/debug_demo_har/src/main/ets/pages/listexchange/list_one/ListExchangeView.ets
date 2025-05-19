import { ListExchange } from "./ListExchange";
import { ListExchangeCtrl } from "./model/ListExchangeCtrl";
import { ListInfo } from "./model/ListInfo";
import { MEMO_DATA } from "./model/MockData";

const ITEM_HEIGHT: number = 50; // 列表项高度


@Builder
export function TestListExchangeBuilder() {

  NavDestination() {
    ListExchangeViewComponent()
  }
  .hideTitleBar(true)
}

@Component
export struct ListExchangeViewComponent {
  // 初始化列表数据
  @State appInfoList11: ListInfo[] = MEMO_DATA;
  // 列表项元素交换类
  @State listExchangeCtrl: ListExchangeCtrl<ListInfo> = new ListExchangeCtrl();

  // 初始化列表数据
  @State appInfoList22: ListInfo[] = MEMO_DATA;
  // 列表项元素交换类
  @State listExchangeCtrl22: ListExchangeCtrl<ListInfo> = new ListExchangeCtrl();

  aboutToAppear(): void {
    this.listExchangeCtrl.initData(this.appInfoList11);
    this.listExchangeCtrl22.initData(this.appInfoList22);

  }



  build() {
    Column() {
      this.testBuilderOne()
      Text("========测试二========")
      this.testBuilderTwo()

    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.list_exchange_background_color'))
    .padding({ left: $r('app.string.ohos_id_card_padding_start'), right: $r('app.string.ohos_id_card_padding_start') })
  }

  @Builder
  testBuilderOne() {
    // 标题栏
    Row() {
      Text($r('app.string.list_exchange_deduction_sort'))
        .textAlign(TextAlign.Start)
      Blank()
      Text($r('app.string.list_exchange_custom_sort'))
    }
    .backgroundColor(Color.White)
    .border({
      radius: {
        topLeft: $r('app.string.ohos_id_corner_radius_default_l'),
        topRight: $r('app.string.ohos_id_corner_radius_default_l')
      }
    })
    .padding({
      left: $r('app.string.ohos_id_card_padding_start'),
      right: $r('app.string.ohos_id_card_padding_start')
    })
    .width('100%')
    .height($r('app.integer.list_exchange_title_height'))

    /**
     * 列表交换视图
     * appInfoList: 数据源
     * listExchangeCtrl: 列表项交换类
     * deductionView: 列表项视图
     */
    ListExchange({
      appInfoList: this.appInfoList11,
      listExchangeCtrl: this.listExchangeCtrl,
      deductionView: (listItemInfo: Object) => {
        this.deductionView(listItemInfo as ListInfo)
      }
    })
  }

  @Builder
  testBuilderTwo() {
    Column(){
      // 标题栏
      Row() {
        Text($r('app.string.list_exchange_deduction_sort'))
          .textAlign(TextAlign.Start)
        Blank()
        Text($r('app.string.list_exchange_custom_sort'))
      }
      .backgroundColor(Color.White)
      .border({
        radius: {
          topLeft: $r('app.string.ohos_id_corner_radius_default_l'),
          topRight: $r('app.string.ohos_id_corner_radius_default_l')
        }
      })
      .padding({
        left: $r('app.string.ohos_id_card_padding_start'),
        right: $r('app.string.ohos_id_card_padding_start')
      })
      .width('100%')
      .height($r('app.integer.list_exchange_title_height'))

      /**
       * 列表交换视图
       * appInfoList: 数据源
       * listExchangeCtrl: 列表项交换类
       * deductionView: 列表项视图
       */
      ListExchange({
        appInfoList: this.appInfoList22,
        listExchangeCtrl: this.listExchangeCtrl22,
        deductionView: (listItemInfo: Object) => {
          this.deductionView(listItemInfo as ListInfo)
        }
      })
    }
    .width('100%')
    .backgroundColor(Color.Green)

  }

  /**
   * ListItem自定义组件（开发者可以根据自己的需求设置列表项的UI）
   */
  @Builder
  deductionView(listItemInfo: ListInfo) {
    Row() {
      Image(listItemInfo.icon)
        .width($r('app.integer.list_exchange_icon_size'))
        .height($r('app.integer.list_exchange_icon_size'))
        .draggable(false) // TODO：知识点：保持默认值true时，图片有默认拖拽效果，会影响Grid子组件拖拽判断，所以修改为false
      Text(listItemInfo.name)
        .margin({ left: $r('app.string.ohos_id_elements_margin_vertical_l') })
        .maxLines(1)
        .layoutWeight(1) //不设置，内容太多会超出去
      Blank()
      Image($r("app.media.list_exchange_ic_public_drawer"))
        .width($r('app.integer.list_exchange_icon_size'))
        .height($r('app.integer.list_exchange_icon_size'))
        .objectFit(ImageFit.Cover)
        .draggable(false) // TODO：知识点：保持默认值true时，图片有默认拖拽效果，会影响Grid子组件拖拽判断，所以修改为false
    }
    .width('100%')
    .height(ITEM_HEIGHT)
    .backgroundColor(Color.White)
    .padding({
      left: $r('app.string.ohos_id_card_padding_start'),
      right: $r('app.string.ohos_id_card_padding_start')
    })
  }
}