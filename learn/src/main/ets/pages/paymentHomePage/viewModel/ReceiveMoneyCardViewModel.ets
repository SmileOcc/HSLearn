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

export class ReceiveMoneyCardViewModel {
  private receiveMoneyServiceCards: ReceiveMoneyServiceCardItem[] = [];

  constructor() {
    this.receiveMoneyServiceCards.push(new ReceiveMoneyServiceCardItem($r("app.media.receive_money_record"),
      YWConstants.RECEIVE_MONEY_SERVICE_CARD_ITEM[0]));
    this.receiveMoneyServiceCards.push(new ReceiveMoneyServiceCardItem($r("app.media.receive_money_notice"),
      YWConstants.RECEIVE_MONEY_SERVICE_CARD_ITEM[1]));
    this.receiveMoneyServiceCards.push(new ReceiveMoneyServiceCardItem($r("app.media.receive_money_record"),
      YWConstants.RECEIVE_MONEY_SERVICE_CARD_ITEM[2], YWConstants.RECEIVE_MONEY_SERVICE_CARD_ITEM[3]));
  }

  public getReceiveMoneyServiceCards() {
    return this.receiveMoneyServiceCards;
  }

  public getReceiveMoneyServiceCardsWithNotBrief():ReceiveMoneyServiceCardItem[] {
    const data:ReceiveMoneyServiceCardItem[] = [...this.receiveMoneyServiceCards];
    data[2].setBrief('');
    return data;
  }
}

export class ReceiveMoneyServiceCardItem {
  /**
   * service card left icon.
   */
  private image: Resource;
  /**
   * service card bottom text.
   */
  private text: string;
  /**
   * service card function brief.
   */
  private brief: string;

  constructor(image: Resource, text: string, brief: string = '') {
    this.image = image;
    this.text = text;
    this.brief = brief;
  }

  public getImage() {
    return this.image;
  }

  public getText() {
    return this.text;
  }

  public getBrief() {
    return this.brief;
  }

  public setBrief(brief: string) {
    this.brief = brief;
  }
}