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

import { swiperImage } from '../model/HomeViewModel';

@Component
export default struct SwiperComponent {
  private dotIndicator: DotIndicator = new DotIndicator();

  aboutToAppear() {
    this.dotIndicator.selectedColor($r('app.color.indicator_select')).color($r('app.color.indicator_unselect'));
  }

  build() {
    Swiper() {
      ForEach(swiperImage, (item: Resource) => {
        Image(item)
          .width(YWConstants.FULL_WIDTH)
          .height($r('app.float.swiper_image_height'))
          .borderRadius($r('app.float.swiper_radius'))
          .backgroundColor(Color.White)
      }, (item: Resource) => JSON.stringify(item))
    }
    .indicator(this.dotIndicator)
    .autoPlay(true)
    .itemSpace(0)
    .width(YWConstants.FULL_WIDTH)
    .displayCount(1)
    .padding({ left: $r('app.float.home_margin_left'), right: $r('app.float.home_margin_right') })
  }
}