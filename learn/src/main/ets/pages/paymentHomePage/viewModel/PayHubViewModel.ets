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

export class PayHubViewModel {
  private functions: Array<QuickFunctionItem> = [];
  private moreFunction: QuickFunctionItem = new QuickFunctionItem($r("app.media.ic_more"),
    Constants.FUNCTIONS_NAME[9]);

  constructor() {
    this.functions.push(new QuickFunctionItem($r("app.media.fund_investment"), Constants.FUNCTIONS_NAME[0]));
    this.functions.push(new QuickFunctionItem($r("app.media.wealth_management_products"),
      Constants.FUNCTIONS_NAME[1]));
    this.functions.push(new QuickFunctionItem($r("app.media.credit_card"), Constants.FUNCTIONS_NAME[2]));
    this.functions.push(new QuickFunctionItem($r("app.media.bill"), Constants.FUNCTIONS_NAME[3]));
    this.functions.push(new QuickFunctionItem($r("app.media.speed_gain"), Constants.FUNCTIONS_NAME[4]));
    this.functions.push(new QuickFunctionItem($r("app.media.precious_metals"), Constants.FUNCTIONS_NAME[5]));
    this.functions.push(new QuickFunctionItem($r("app.media.deposit_products"), Constants.FUNCTIONS_NAME[6]));
    this.functions.push(new QuickFunctionItem($r("app.media.payment_fees"), Constants.FUNCTIONS_NAME[7]));
    this.functions.push(new QuickFunctionItem($r("app.media.quick_loan"), Constants.FUNCTIONS_NAME[8]));
    this.functions.push(new QuickFunctionItem($r("app.media.quick_loan"), Constants.FUNCTIONS_NAME[8]));
    this.functions.push(new QuickFunctionItem($r("app.media.quick_loan"), Constants.FUNCTIONS_NAME[8]));
    this.functions.push(new QuickFunctionItem($r("app.media.quick_loan"), Constants.FUNCTIONS_NAME[8]));
    this.functions.push(new QuickFunctionItem($r("app.media.quick_loan"), Constants.FUNCTIONS_NAME[8]));
    this.functions.push(new QuickFunctionItem($r("app.media.quick_loan"), Constants.FUNCTIONS_NAME[8]));
    this.functions.push(new QuickFunctionItem($r("app.media.quick_loan"), Constants.FUNCTIONS_NAME[8]));
  }


  getFunctionsByBreakpoints(bp: string): Array<QuickFunctionItem> {
    if (bp === Constants.BREAKPOINTS[0]) {
      return [...this.functions.slice(0, 7), this.moreFunction]
    } else if (bp === Constants.BREAKPOINTS[1]) {
      return [...this.functions.slice(0, 11), this.moreFunction]
    } else {
      return [...this.functions, this.moreFunction];
    }
  }
}

export class QuickFunctionItem {
  /**
   * Quick function icon
   */
  private img: Resource;
  /**
   * Quick function name
   */
  private text: string;
  /**
   * Quick function click function
   */
  private clickCallback: Function;

  constructor(img: Resource, text: string, clickCallback: Function = () => {
  }) {
    this.img = img;
    this.text = text;
    this.clickCallback = clickCallback;
  }

  public setClickCallback(func: Function) {
    this.clickCallback = func;
  }

  public getImg() {
    return this.img;
  }

  public getText() {
    return this.text;
  }

  public getClickCallback() {
    return this.clickCallback;
  }
}