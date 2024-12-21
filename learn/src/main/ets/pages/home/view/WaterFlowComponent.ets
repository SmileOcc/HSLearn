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

import { WaterFlowDataSource } from '../model/WaterFlowDataSource';
// import { CommonConstants, CommonConstants as Const, NavPageStyle } from '../common/constants/CommonConstants';
import { loadingMoreFlowData } from '../model/HomeViewModel';
import FlowItemComponent from '../view/FlowItemComponent';
import ProductItem from '../model/ProductItem';
import { YWNavRouterUtils } from '@learn/common_har';
import { YWConstants } from '@learn/constants_har';

@Component
export default struct WaterFlowComponent {
  @Prop datasource: WaterFlowDataSource;
  // @Consume('pageInfos') pageInfos: NavPathStack;
  private scroller: Scroller = new Scroller();
  private isEnd: boolean = false;

  aboutToAppear() {
    if (this.datasource.totalCount() <= YWConstants.DATASOURCE_MIN_COUNT) {
      this.isEnd = true;
    }
    getContext(this).eventHub.on(YWConstants.EVENT_QUICK_TOP_FUNC, (): void => {
      this.scroller.scrollToIndex(0);
    })
    getContext(this).eventHub.on(YWConstants.EVENT_REFRESH_WATERFLOW_DATA, (): void => {
    })
    getContext(this).eventHub.on(YWConstants.EVENT_REMOVE_ITEM, (id: number): void => {
      this.datasource.deleteItem(id);
    })
  }

  build() {
    WaterFlow({ footer: (): void => this.itemProgressFoot(), scroller: this.scroller }) {
      LazyForEach(this.datasource, (item: ProductItem, index) => {
        FlowItem() {
          FlowItemComponent({ item: item })
        }.onClick(() => {
          // this.pageInfos.pushPathByName('Detail', item.id);
          YWNavRouterUtils.navPush({name:'Detail',param:item.id})
        })
      }, (item: ProductItem) => JSON.stringify(item))
    }
    .height(YWConstants.FULL_HEIGHT)
    .friction(YWConstants.WATER_FLOW_FRICTION)
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
    .onScrollIndex((first: number, last: number) => {
      if ((last + YWConstants.CACHED_COUNT) === this.datasource.totalCount()) {
        setTimeout(() => {
          this.datasource.addMoreData(loadingMoreFlowData)
        }, YWConstants.TIME_OUT_FIVE_HUNDREDS)
      }
    })
    .layoutWeight(YWConstants.WATER_FLOW_LAYOUT_WEIGHT)
    .layoutDirection(FlexDirection.Column)
    .columnsTemplate(YWConstants.WATER_FLOW_COLUMNS_TEMPLATE)
    .columnsGap($r('app.float.water_flow_columns_gap'))
    .rowsGap($r('app.float.water_flow_row_gap'))
    .padding({
      bottom: 29 * 2
    })
    .cachedCount(YWConstants.CACHED_COUNT)
  }

  @Builder
  itemProgressFoot() {
    Row({ space: 5 }) {
      LoadingProgress()
        .width($r('app.float.loadingProgress_width'))
        .height($r('app.float.loadingProgress_height'))
      Text($r('app.string.loading')).fontSize($r('app.float.progress_font_size')).fontColor(Color.Gray)
    }
    .justifyContent(FlexAlign.Center)
    .width(YWConstants.FULL_WIDTH)
    .margin({ top: $r('app.float.progress_margin_top') })
    .visibility(this.isEnd ? Visibility.Hidden : Visibility.Visible)
  }
}