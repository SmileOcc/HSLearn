/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// import { CommonConstants, CommonConstants as Const } from '../common/constants/CommonConstants';
import ProductItem, { FlowItemCardType } from '../model/ProductItem';
import { waterFlowData } from '../model/HomeViewModel';
import { YWConstants } from '@learn/constants_har';

/**
 * Flow item component.
 * Usage: This component is used in FlowItem.
 */
@Component
export default struct FlowItemComponent {
  @State showMenu: boolean = false;
  @State flowHeight: Length = YWConstants.FLOW_HEIGHT;
  item: ProductItem = waterFlowData[0];

  aboutToAppear(): void {
    getContext(this).eventHub.on(YWConstants.EVENT_HIDE_ITEM_MENU, (): void => {
      this.hideMenu();
    })
  }

  hideMenu() {
    if (this.showMenu) {
      this.showMenu = false;
    }
  }

  build() {
    if (this.item?.show_type === FlowItemCardType.SWIPER) {
      this.SwiperCardBuilder(this.item)
    } else {
      Stack() {
        Column() {
          Image(this.item?.image_url)
            .aspectRatio(this.item?.img_ratio)
            .width(YWConstants.FULL_WIDTH)
            .objectFit(ImageFit.Contain)
            .backgroundColor($r('app.color.flow_image_bg_color'))
            .borderRadius({
              topLeft: $r('app.float.product_layout_radius'),
              topRight: $r('app.float.product_layout_radius')
            })
          Text(this.item?.name)
            .fontSize($r('app.float.small_font_size'))
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Normal)
            .maxLines(2)
            .alignSelf(ItemAlign.Start)
            .margin({
              top: $r('app.float.product_name_margin_top'),
              left: $r('app.float.product_layout_margin_left'),
              right: $r('app.float.product_layout_margin_right')
            })
          Text(this.item?.discount)
            .fontSize($r('app.float.smaller_font_size'))
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Normal)
            .opacity(YWConstants.SIXTY_OPACITY)
            .alignSelf(ItemAlign.Start)
            .margin({
              left: $r('app.float.product_layout_margin_left'),
              right: $r('app.float.product_layout_margin_right')
            })
          Text(this.item?.price)
            .fontSize($r('app.float.middle_font_size'))
            .fontColor($r('app.color.focus_color'))
            .fontWeight(FontWeight.Normal)
            .alignSelf(ItemAlign.Start)
            .lineHeight($r('app.float.piece_line_height'))
            .margin({
              top: $r('app.float.product_price_margin_top'),
              left: $r('app.float.product_layout_margin_left'),
              right: $r('app.float.product_layout_margin_right')
            })
          Row() {
            Stack() {
              if (this.item?.promotion) {
                Text(`${this.item?.promotion}`)
                  .height($r('app.float.promotion_text_height'))
                  .fontSize($r('app.float.promotion_font_size'))
                  .fontColor(Color.White)
                  .fontWeight(YWConstants.FONT_WEIGHT_FIVE)
                  .borderRadius($r('app.float.promotion_radius'))
                  .backgroundColor($r('app.color.focus_color'))
                  .padding({
                    left: $r('app.float.promotion_padding_left'),
                    right: $r('app.float.promotion_padding_right')
                  })
                  .margin({
                    top: $r('app.float.product_promotion_margin_top'),
                    left: $r('app.float.product_layout_margin_left')
                  })
              }
            }

            Stack() {
              if (this.item?.bonus_points) {
                Text(`${this.item?.bonus_points}`)
                  .height($r('app.float.promotion_text_height'))
                  .fontSize($r('app.float.promotion_font_size'))
                  .fontColor($r('app.color.focus_color'))
                  .fontWeight(YWConstants.FONT_WEIGHT_FIVE)
                  .borderRadius($r('app.float.promotion_radius'))
                  .borderWidth($r('app.float.bonus_points_radius_width'))
                  .borderColor($r('app.color.focus_color'))
                  .padding({
                    left: $r('app.float.bonus_points_padding_left'),
                    right: $r('app.float.bonus_points_padding_right')
                  })
                  .margin({
                    top: $r('app.float.product_bonus_margin_top'),
                    left: $r('app.float.product_bonus_margin_left'),
                    right: $r('app.float.product_layout_margin_right')
                  })
              }
            }
          }
          .width(YWConstants.FULL_WIDTH)
          .justifyContent(FlexAlign.Start)
        }
        .borderRadius($r('app.float.product_layout_radius'))
        .backgroundColor(Color.White)
        .padding({
          bottom: $r('app.float.product_layout_margin_bottom')
        })
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.flowHeight = newValue.height;
        })

        Stack() {
          if (this.showMenu) {
            this.longPressMenuBuilder()
          }
        }
      }
      .onTouch((event?: TouchEvent) => {
        if (event) {
          if (event.type === TouchType.Down) {
            if (!this.showMenu) {
              getContext(this).eventHub.emit(YWConstants.EVENT_HIDE_ITEM_MENU, null);
            }
          }
        }
      })
      .priorityGesture(
        GestureGroup(GestureMode.Exclusive,
          LongPressGesture({})
            .onAction(() => {
              this.showMenu = true;
            })
        )
      )
    }
  }

  @Builder
  longPressMenuBuilder() {
    Column() {
      Button($r('app.string.no_interested_button_text'))
        .width(YWConstants.EIGHTY_FONT_WIDTH)
        .height($r('app.float.flow_press_btn_height'))
        .backgroundColor(Color.White)
        .fontColor(Color.Black)
        .onClick(() => {
          getContext(this).eventHub.emit(YWConstants.EVENT_REMOVE_ITEM, this.item.id);
          this.hideMenu()
        })
      Button($r('app.string.low_quality_button_text'))
        .width(YWConstants.EIGHTY_FONT_WIDTH)
        .height($r('app.float.flow_press_btn_height'))
        .backgroundColor(Color.White)
        .fontColor(Color.Black)
      Button($r('app.string.seen_button_text'))
        .width(YWConstants.EIGHTY_FONT_WIDTH)
        .height($r('app.float.flow_press_btn_height'))
        .backgroundColor(Color.White)
        .fontColor(Color.Black)
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .borderRadius($r('app.float.product_layout_radius'))
    .backgroundColor($r('app.color.flow_press_foreground_color'))
    .width(YWConstants.FULL_WIDTH)
    .height(this.flowHeight)
    .onClick(() => {
      this.hideMenu();
    })
  }

  @Builder
  SwiperCardBuilder(item: ProductItem) {
    Swiper() {
      ForEach(item?.swiper_urls, (item: Resource) => {
        Image(item)
          .width(YWConstants.FULL_WIDTH)
          .aspectRatio(this.item?.img_ratio)
          .borderRadius($r('app.float.product_layout_radius'))
          .backgroundColor($r('app.color.flow_image_bg_color'))
      }, (item: Resource) => JSON.stringify(item))
    }
    .indicator(
      new DotIndicator()
        .selectedColor($r('app.color.indicator_select'))
    )
    .autoPlay(true)
    .itemSpace(0)
    .width(YWConstants.FULL_WIDTH)
    .displayCount(1)
  }
}