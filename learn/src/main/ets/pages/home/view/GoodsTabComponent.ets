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
import { YWConstants } from '@learn/constants_har';
import { waterFlowData } from '../model/HomeViewModel';
import { IProductItem } from '../model/ProductItem';
import { TAB_DATA, TabDataModel, TabDataSource } from '../model/TabsData';
import { WaterFlowDataSource } from '../model/WaterFlowDataSource';
import WaterFlowComponent from './WaterFlowComponent';

/**
 * Goods Tab Page
 */
@Preview
@Component
export struct GoodsTabComponent {
  @State tabsIndex: number = 0;
  @State isMask: boolean = true;
  tabsController: TabsController = new TabsController();
  tabDataSource: TabDataSource = new TabDataSource();
  tabScroller: Scroller = new Scroller();
  tabStart: number = 0;
  tabEnd: number = 0;
  dataSource: WaterFlowDataSource = new WaterFlowDataSource(waterFlowData);

  filterData(index: number) {
    let newListData: IProductItem[] = [];
    if (index !== 0) {
      for (let i = 0; i < waterFlowData.length; i++) {
        if (waterFlowData[i].typeId === TAB_DATA[index].id) {
          newListData.push(waterFlowData[i]);
        }
      }
      this.dataSource = new WaterFlowDataSource(newListData);
      return this.dataSource;
    } else {
      this.dataSource = new WaterFlowDataSource(waterFlowData);
      return this.dataSource;
    }
  }

  aboutToAppear(): void {
    for (let index = 0; index < TAB_DATA.length; index++) {
      this.tabDataSource.pushData(TAB_DATA[index]);
    }
  }

  @Builder
  tabBuilder(index: number, name: string | undefined) {
    Row() {
      Text(name)
        .constraintSize({ minWidth: this.tabsIndex === index ? 90 : 66 })
        .textAlign(TextAlign.Center)
        .fontSize($r('app.float.tab_font_size'))
        .fontColor(this.tabsIndex === index ? '#FFFFFF' : '#000000')
        .fontWeight(this.tabsIndex === index ? 500 : 400)
        .height(YWConstants.FULL_HEIGHT)
        .padding({ left: $r('app.float.tab_text_padding_left'), right: $r('app.float.tab_text_padding_right') })
        .backgroundColor(this.tabsIndex === index ? $r('app.color.focus_color') : $r('app.color.tab_normal_color'))
        .borderRadius(21)
    }
    .padding({
      top: $r('app.float.tab_padding_top'),
      bottom: $r('app.float.tab_padding_bottom'),
      left: 0,
      right: $r('app.float.tab_padding_right')
    })
    .justifyContent(FlexAlign.Center)
    .height($r('app.float.tab_height'))
    .align(Alignment.Center)
    .onClick(() => {
      this.tabsIndex = index;
      this.tabsController.changeIndex(index);
      this.filterData(index);
    })
  }

  @Builder
  moreBuilder() {
    Row() {
      Image($r('app.media.ic_more')).width($r('app.float.tab_more_width')).height($r('app.float.tab_more_height'))
    }
    .justifyContent(FlexAlign.End)
    .padding({ left: $r('app.float.tab_more_padding_left') })
    .height($r('app.float.tab_height'))
  }

  build() {
    Column() {
      Column() {
        Row() {
          this.moreBuilder()
          Stack() {
            List({ scroller: this.tabScroller }) {
              ForEach(TAB_DATA, (tabItem: TabDataModel, index: number) => {
                this.tabBuilder(index, tabItem.navData)
              })
            }
            .width(YWConstants.FULL_WIDTH)
            .height(YWConstants.FULL_HEIGHT)
            .listDirection(Axis.Horizontal)
            .contentStartOffset(12)
            .scrollBar(BarState.Off)
            .onScrollIndex((start, end, center) => {
              this.tabStart = start
              this.tabEnd = end
            })

            Stack() {
            }
            .linearGradient({
              angle: 90,
              colors: [['rgba(241,243,245,1)', 0.0], ['rgba(241,243,245,0)', 0.07], ['rgba(241,243,245,0)', 0.93],
                ['rgba(241,243,245,1)', 1.0]]
            })
            .width(YWConstants.FULL_WIDTH)
            .height(YWConstants.FULL_HEIGHT)
            .hitTestBehavior(HitTestMode.None)
          }
          .alignContent(Alignment.End)
          .layoutWeight(1)
          .height($r('app.float.tab_height'))
        }
        .padding({ right: $r('app.float.home_margin_right') })
        .direction(Direction.Rtl)
        .alignItems(VerticalAlign.Bottom)
        .width(YWConstants.FULL_WIDTH)
      }
      .alignItems(HorizontalAlign.Start)
      .width(YWConstants.FULL_WIDTH)

      Tabs({ controller: this.tabsController }) {
        ForEach(TAB_DATA, (tabItem: TabDataModel, index) => {
          TabContent() {
            WaterFlowComponent({ datasource: this.filterData(index) })
          }
        })
      }
      .padding({ left: $r('app.float.home_margin_left'), right: $r('app.float.home_margin_right') })
      .barMode(BarMode.Scrollable)
      .barWidth(YWConstants.FULL_WIDTH)
      .barHeight(0)
      .onChange((index: number) => {
        this.tabsIndex = index;
        this.filterData(index);
        if (this.tabsIndex <= this.tabStart || this.tabsIndex >= this.tabEnd) {
          this.tabScroller.scrollToIndex(this.tabsIndex, true);
        }
      })

    }.height(YWConstants.FULL_HEIGHT)
  }
}

