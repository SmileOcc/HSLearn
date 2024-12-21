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
import RouterUtils from '../../../../../../../modules/common_har/src/main/ets/utils/RouterUtils';

import DataModel from '../model/DataModel';
import GridMenuData from '../model/GridDataModel';

@Preview
@Component
export struct GridComponent {
  @State data: GridMenuData[] = DataModel.GRID_MENU;

  build() {
    Column() {
      Grid() {
        ForEach(this.data, (item: GridMenuData) => {
          GridItem() {
            Column() {
              Image(item.icon)
                .width($r('app.float.grid_image_width'))
                .height($r('app.float.grid_image_height'))
                .padding({
                  left: $r('app.float.grid_image_padding_left'),
                  right: $r('app.float.grid_image_padding_right')
                })
                .objectFit(ImageFit.Contain)
              Text(item.text)
                .width(YWConstants.FULL_WIDTH)
                .fontSize($r('app.float.grid_font_size'))
                .textAlign(TextAlign.Center)
                .margin({ top: $r('app.float.grid_text_margin_top') })
            }

          }
          .onClick(()=>{
            RouterUtils.jumpRouter('pages/search/SearchResultPage')
          })
        }, (item: GridMenuData, index: number) => index.toString())
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr')

    }
    .width(YWConstants.FULL_WIDTH)
    .height($r('app.float.grid_height'))
    .padding({
      top: $r('app.float.grid_padding_top'),
      bottom: $r('app.float.grid_padding_bottom'),
      left: $r('app.float.home_margin_left'),
      right: $r('app.float.home_margin_right')
    })
  }
}