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

export class ServiceCardViewModel {
  private fortunePicks: Array<Resource> = [];

  constructor() {
    this.fortunePicks.push($r("app.media.sample_image01"));
    this.fortunePicks.push($r("app.media.sample_image01"));
    this.fortunePicks.push($r("app.media.sample_image02"));
    this.fortunePicks.push($r("app.media.sample_image02"));
  }

  getImagesByBreakpoints(breakpoints: string): Array<Resource> {
    if (breakpoints === YWConstants.BREAKPOINTS[0]) {
      return this.fortunePicks.slice(0, 1);
    } else if (breakpoints === YWConstants.BREAKPOINTS[1]) {
      return this.fortunePicks.slice(0, 2);
    } else {
      return this.fortunePicks;
    }
  }
}