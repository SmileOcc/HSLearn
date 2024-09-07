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
import { CommonConstants } from '../common/constants/CommonConstants';

import { WaterFlowDataSource } from '../model/SectionsWaterFlowDataSource';

@Reusable
struct ReusableFlowItem {
  @State item: number = 0;

  aboutToReuse(params: Record<string, number>) {
    this.item = params.item;
  }

  aboutToAppear() {
  }

  build() {
    RelativeContainer() {
      Image($rawfile(`sections/${this.item % 4}.jpg`))
        .objectFit(ImageFit.Cover)
        .width('100%')
        .layoutWeight(1)
        .borderRadius($r('app.float.sections_item_radius'))
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .id('image')

      Stack() {
      }
      .linearGradient({
        angle: 0,
        colors: [[$r('app.color.linearGradient_first_color'), 0.0],
          [$r('app.color.linearGradient_last_color'), 1.0]]
      })
      .width(CommonConstants.FULL_WIDTH)
      .height($r('app.float.sections_item_blur_height'))
      .borderRadius($r('app.float.sections_item_radius'))
      .hitTestBehavior(HitTestMode.None)
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End }
      })
      .id('mask')

      Text('NO. ' + (this.item + 1))
        .fontSize($r('app.float.sections_item_text_size'))
        .fontColor(Color.White)
        .alignRules({
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .margin({
          left: $r('app.float.sections_item_text_margin_left'),
          bottom: $r("app.float.sections_item_text_margin_bottom")
        })
        .id('text')
    }
    .width(CommonConstants.FULL_WIDTH)
    .borderRadius($r('app.float.sections_item_radius'))
    .backgroundColor(Color.Gray)
  }
}

@Preview
@Component
export struct SectionsPage {
  @State minSize: number = 80;
  @State maxSize: number = 180;
  scroller: Scroller = new Scroller();
  dataSource: WaterFlowDataSource = new WaterFlowDataSource();
  dataCount: number = this.dataSource.totalCount();
  private itemHeightArray: number[] = [];
  @State sections: WaterFlowSections = new WaterFlowSections();
  sectionMargin: Margin = {
    top: 8,
    left: 0,
    bottom: 0,
    right: 0
  }
  oneColumnSection: SectionOptions = {
    itemsCount: 3,
    crossCount: 1,
    columnsGap: 5,
    rowsGap: 10,
    margin: this.sectionMargin,
    onGetItemMainSizeByIndex: (index: number) => {
      return 170;
    }
  }
  twoColumnSection: SectionOptions = {
    itemsCount: 2,
    crossCount: 2,
    margin: this.sectionMargin,
    onGetItemMainSizeByIndex: (index: number) => {
      return 100;
    }
  }
  lastSection: SectionOptions = {
    itemsCount: 20,
    crossCount: 2,
    margin: this.sectionMargin,
    onGetItemMainSizeByIndex: (index: number) => {
      return this.itemHeightArray[index % 100];
    }
  }

  getSize() {
    let ret = Math.floor(Math.random() * this.maxSize);
    return (ret > this.minSize ? ret : this.minSize);
  }

  setItemSizeArray() {
    for (let i = 0; i < 100; i++) {
      this.itemHeightArray.push(this.getSize());
    }
  }

  aboutToAppear() {
    this.setItemSizeArray();
    let sectionOptions: SectionOptions[] = [];
    let count = 0;
    let oneOrTwo = 0;
    while (count < this.dataCount) {
      if (this.dataCount - count < 96) {
        this.lastSection.itemsCount = this.dataCount - count;
        sectionOptions.push(this.lastSection);
        break;
      }
      if (oneOrTwo++ % 2 == 0) {
        sectionOptions.push(this.oneColumnSection);
        count += this.oneColumnSection.itemsCount;
      } else {
        sectionOptions.push(this.twoColumnSection);
        count += this.twoColumnSection.itemsCount;
      }
    }
    this.sections.splice(0, 0, sectionOptions);
  }

  build() {
    Column({ space: 0 }) {
      WaterFlow({ scroller: this.scroller, sections: this.sections }) {
        LazyForEach(this.dataSource, (item: number) => {
          FlowItem() {
            ReusableFlowItem({ item: item })
          }
          .width(CommonConstants.FULL_WIDTH)
          .borderRadius($r('app.float.sections_item_radius'))
          .backgroundColor(Color.Gray)
        }, (item: string) => item)
      }
      .columnsGap($r('app.float.sections_margin'))
      .rowsGap($r('app.float.sections_margin'))
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.FULL_HEIGHT)
      .layoutWeight(1)
      .onScrollIndex((first: number, last: number) => {
        if (last + 20 >= this.dataSource.totalCount()) {
          for (let i = 0; i < this.dataCount; i++) {
            this.dataSource.addLastItem();
          }
          this.lastSection.itemsCount += 100;
          this.sections.update(-1, this.lastSection);
        }
      })
    }
  }
}