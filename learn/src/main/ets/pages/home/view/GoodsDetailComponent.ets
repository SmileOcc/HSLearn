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
import { YWNavBar } from '@learn/baseui_har';
import { YWNavRouterUtils } from '@learn/common_har';
import { YWConstants } from '@learn/constants_har';


@Component
export struct GoodsDetailComponent {
  // @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        YWNavBar({
          title: '详情',
          onKeyBack: () => {
            YWNavRouterUtils.pop()
          },
        })
          .backgroundColor(Color.Blue)
        Text('xxx' + YWNavRouterUtils.navPathStack.getParamByName('Detail'))
          .fontSize($r('app.float.detail_font_size'))
          .backgroundColor(Color.White)
          .height(YWConstants.FULL_HEIGHT)
          .width(YWConstants.FULL_WIDTH)
          .textAlign(TextAlign.Center)
      }.justifyContent(FlexAlign.Center)
      .backgroundColor(Color.Yellow)
    }
  }
}
