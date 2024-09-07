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

import ToolBarData from './ToolBarData';
import GridMenuData from './GridDataModel';

/*
 * The DataModel file instead of network data.
 */
export default class DataModel {
  public static readonly TOOL_BAR: ToolBarData[] = [
    {
      num: 0,
      text: $r('app.string.nav_index'),
      icon: $rawfile('index/ic_home_off.svg'),
      icon_after: $rawfile('index/ic_home_on.svg'),
    },
    {
      num: 1,
      text: $r('app.string.nav_shopping_cart'),
      icon: $rawfile('index/ic_shopping_off.svg'),
      icon_after: $rawfile('index/ic_shopping_on.svg'),
    },
    {
      num: 2,
      text: $r('app.string.nav_mine'),
      icon: $rawfile('index/ic_my_off.svg'),
      icon_after: $rawfile('index/ic_my_on.svg'),
    }
  ];
  public static readonly GRID_MENU: GridMenuData[] = [
    {
      text: $r('app.string.grid_work'),
      icon: $rawfile('index/ic_work.svg'),
    },
    {
      text: $r('app.string.grid_sport'),
      icon: $rawfile('index/ic_sport.svg'),
    },
    {
      text: $r('app.string.grid_life'),
      icon: $rawfile('index/ic_life.svg'),
    },
    {
      text: $r('app.string.grid_phone'),
      icon: $rawfile('index/ic_phone.svg'),
    },
    {
      text: $r('app.string.grid_play'),
      icon: $rawfile('index/ic_play.svg'),
    }
  ];
}