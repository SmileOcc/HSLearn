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
import { Constants } from '../../../../../../../modules/common_har/src/main/ets/common/Constants';
import RouterUtils from '../../../../../../../modules/common_har/src/main/ets/utils/RouterUtils';

@Component
export default struct SearchComponent {
  build() {
    Row(){
      Row() {
        Image($r('app.media.ic_search'))
          .width($r('app.float.search_width'))
          .height($r('app.float.search_height'))
          .margin({
            left: $r('app.float.search_margin_left'),
            right: $r('app.float.search_margin_right')
          })
        Text($r('app.string.search_text'))
          .fontSize($r('app.float.small_font_size'))
          .fontColor(Color.Black)
          .opacity(Constants.SIXTY_OPACITY)
          .fontWeight(FontWeight.Normal)
      }
      .layoutWeight(1)
      .height($r('app.float.search_swiper_height'))
      .borderRadius($r('app.float.search_radius'))
      .backgroundColor(Color.White)
      .margin({
        top: $r('app.float.search_margin_top'),
        left: $r('app.float.home_margin_left'),
        right: $r('app.float.home_margin_right')
      })
      .onClick(()=>{
        RouterUtils.jumpRouter('pages/search/SearchPage')
      })
    }.width(Constants.FULL_WIDTH)
  }
}