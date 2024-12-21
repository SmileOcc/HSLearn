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

import { WaterFlowDataSource } from '../model/SectionsWaterFlowDataSource'
import { constant } from '@kit.ConnectivityKit'
import { YWConstants } from '@learn/constants_har';

@Preview
@Component
export struct StickyPage {
  @State arr: number[] = [1, 2, 3, 4, 5, 6];
  @State colors: number[] = [0xFFC0CB, 0xDA70D6, 0x6B8E23, 0x6A5ACD, 0x00FFFF, 0x00FF7F];
  @State scrollOffset: number = 0;
  @State minSize: number = 80;
  @State maxSize: number = 180;
  @State sections: WaterFlowSections = new WaterFlowSections();
  scroller: Scroller = new Scroller();
  dataCount: number = 100;
  dataSource: WaterFlowDataSource = new WaterFlowDataSource();
  private titles: string[] = ['全部', '健康', '小镇', '美食', '双人', '烟花'];
  private itemWidthArray: number[] = [];
  private itemHeightArray: number[] = [];
  oneColumnSection: SectionOptions = {
    itemsCount: 3,
    crossCount: 1,
    columnsGap: 5,
    rowsGap: 10,
    margin: {
      top: 8,
      left: 0,
      bottom: 8,
      right: 0
    },
    onGetItemMainSizeByIndex: (index: number) => {
      if (index == 1) {
        return 100;
      } else {
        return 200;
      }
    }
  };
  twoColumnSection: SectionOptions = {
    itemsCount: 2,
    crossCount: 2,
    onGetItemMainSizeByIndex: (index: number) => {
      return 250;
    }
  };

  getSize() {
    let ret = Math.floor(Math.random() * this.maxSize);
    return (ret > this.minSize ? ret : this.minSize);
  }

  setItemSizeArray() {
    for (let i = 0; i < 100; i++) {
      this.itemWidthArray.push(this.getSize());
      this.itemHeightArray.push(this.getSize());
    }
  }

  aboutToAppear() {
    this.setItemSizeArray()
    let sectionOptions: SectionOptions[] = [];
    let count = 0;
    let oneOrTwo = 0;
    while (count < this.dataCount) {
      if (oneOrTwo++ % 2 == 0) {
        sectionOptions.push(this.oneColumnSection);
        count += this.oneColumnSection.itemsCount;
      } else {
        sectionOptions.push(this.twoColumnSection)
        count += this.twoColumnSection.itemsCount
      }
    }
    this.sections.splice(-1, 0, sectionOptions)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      WaterFlow({ scroller: this.scroller, sections: this.sections }) {
        LazyForEach(this.dataSource, (item: number) => {
          FlowItem() {
            if (item != 1) {
              RelativeContainer() {
                Image($rawfile(`sections/${item % 4}.jpg`))
                  .objectFit(ImageFit.Cover)
                  .width(YWConstants.FULL_WIDTH)
                  .layoutWeight(1)
                  .borderRadius($r('app.float.sections_item_radius'))
                  .alignRules({
                    top: { anchor: "__container__", align: VerticalAlign.Top },
                    bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
                    left: { anchor: "__container__", align: HorizontalAlign.Start },
                    right: { anchor: "__container__", align: HorizontalAlign.End }
                  })
                  .id('image')

                Stack() {
                }
                .linearGradient({
                  angle: 0,
                  colors: [[$r('app.color.linearGradient_first_color'), 0.0],
                    [$r('app.color.linearGradient_last_color'), 1.0]]
                })
                .width(YWConstants.FULL_WIDTH)
                .height($r('app.float.sections_item_blur_height'))
                .borderRadius($r('app.float.sections_item_radius'))
                .hitTestBehavior(HitTestMode.None)
                .alignRules({
                  bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
                  left: { anchor: "__container__", align: HorizontalAlign.Start },
                  right: { anchor: "__container__", align: HorizontalAlign.End }
                })
                .id('mask')

                Text($r('app.string.want_to_eat'))
                  .fontSize($r('app.float.sections_item_text_size'))
                  .fontColor(Color.White)
                  .alignRules({
                    bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
                    middle: { anchor: "__container__", align: HorizontalAlign.Center }
                  })
                  .margin({ bottom: $r("app.float.sections_item_center_text_margin_bottom") })
                  .id('text')
              }
            }
          }
          .width(YWConstants.FULL_WIDTH)
          .height(this.itemHeightArray[item % 100])
          .backgroundColor(Color.White)
        }, (item: string) => item)
      }
      .columnsTemplate('1fr 1fr')
      .columnsGap($r('app.float.sections_margin'))
      .rowsGap($r('app.float.sections_margin'))
      .width(YWConstants.FULL_WIDTH)
      .height(YWConstants.FULL_HEIGHT)
      .layoutWeight(1)
      .onScrollIndex((first: number, last: number) => {
        if (last + 20 >= this.dataSource.totalCount()) {
          for (let i = 0; i < 100; i++) {
            this.dataSource.addLastItem();
          }
          let newSection: SectionOptions = {
            itemsCount: 100,
            crossCount: 2,
            onGetItemMainSizeByIndex: (index: number) => {
              return 100;
            }
          }
          this.sections.push(newSection);
        }
      })
      .onWillScroll((offset: number) => {
        this.scrollOffset = this.scroller.currentOffset().yOffset + offset;
      })

      Stack() {
        Column() {
          Scroll() {
            Row({ space: 0 }) {
              ForEach(this.titles, (item: string) => {
                Row() {
                  Text(item)
                    .constraintSize({ minWidth: $r('app.float.tab_height') })
                    .textAlign(TextAlign.Center)
                    .fontSize($r('app.float.tab_font_size'))
                    .fontColor(Color.Black)
                    .height(YWConstants.FULL_HEIGHT)
                    .backgroundColor($r('app.color.sections_tab_color_normal'))
                    .borderRadius($r('app.float.sections_tab_radius'))
                }
                .padding({
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: $r('app.float.tab_padding_right')
                })
                .justifyContent(FlexAlign.Center)
                .height($r('app.float.sections_sticky_tab_height'))
                .align(Alignment.Center)
              }, (item: string) => item.toString())
            }
          }
          .scrollBar(BarState.Off)
          .scrollable(ScrollDirection.Horizontal)
          .backgroundColor(Color.White)
          .padding({ top: $r('app.float.sections_margin') })

          Scroll() {
          }

          Row() {
            Select([{ value: $r('app.string.distance')},
              { value: $r('app.string.less_1km') },
              { value: $r('app.string.less_5km') },
              { value: $r('app.string.more_5km') }])
              .selected(1)
              .value($r('app.string.distance'))
              .font({
                size: $r('app.float.sections_sticky_select_text_size'),
                family: 'serif',
                style: FontStyle.Normal
              })
              .fontColor(Color.Black)
              .selectedOptionFont({
                size: $r('app.float.sections_sticky_select_text_size'),
                family: 'serif',
                style: FontStyle.Normal
              })
              .optionFont({
                size: $r('app.float.sections_sticky_select_text_size'),
                family: 'serif',
                style: FontStyle.Normal
              })
              .backgroundColor($r('app.color.sections_tab_color_normal'))
            Select([{ value: $r('app.string.classify') },
              { value: $r('app.string.food') },
              { value: $r('app.string.leisure') },
              { value: $r('app.string.entertainment') }])
              .selected(1)
              .value($r('app.string.classify'))
              .font({
                size: $r('app.float.sections_sticky_select_text_size'),
                family: 'serif',
                style: FontStyle.Normal
              })
              .fontColor(Color.Black)
              .selectedOptionFont({
                size: $r('app.float.sections_sticky_select_text_size'),
                family: 'serif',
                style: FontStyle.Normal
              })
              .optionFont({
                size: $r('app.float.sections_sticky_select_text_size'),
                family: 'serif',
                style: FontStyle.Normal
              })
              .backgroundColor($r('app.color.sections_tab_color_normal'))
              .margin({ left: $r('app.float.sections_margin') })
            Select([{ value: $r('app.string.sort') },
              { value: $r('app.string.one') },
              { value: $r('app.string.two') },
              { value: $r('app.string.three') }])
              .selected(1)
              .value($r('app.string.sort'))
              .font({
                size: $r('app.float.sections_sticky_select_text_size'),
                family: 'serif',
                style: FontStyle.Normal
              })
              .fontColor(Color.Black)
              .selectedOptionFont({
                size: $r('app.float.sections_sticky_select_text_size'),
                family: 'serif',
                style: FontStyle.Normal
              })
              .optionFont({
                size: $r('app.float.sections_sticky_select_text_size'),
                family: 'serif',
                style: FontStyle.Normal
              })
              .backgroundColor($r('app.color.sections_tab_color_normal'))
              .margin({ left: $r('app.float.sections_margin') })

          }
          .backgroundColor(Color.White)
          .width(YWConstants.FULL_WIDTH)
          .padding({ top: $r('app.float.sections_margin'), bottom: $r('app.float.sections_margin') })
        }.alignItems(HorizontalAlign.Start)
      }
      .height(100)
      .hitTestBehavior(HitTestMode.Transparent)
      .position({ x: 0, y: this.scrollOffset >= 220 ? 0 : 220 - this.scrollOffset })
    }
  }
}