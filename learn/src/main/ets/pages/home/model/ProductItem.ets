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

/**
 * Card show type in WaterFlow
 */
export enum FlowItemCardType {
  IMAGE, SWIPER
}

export interface IProductItem {
  /**
   * Product image url.
   */
  image_url: Resource | string;

  /**
   * Product name.
   */
  name: string;

  /**
   * Product discount.
   */
  discount: string;

  /**
   * Product price.
   */
  price: string;

  /**
   * Product promotion.
   */
  promotion: string;

  /**
   * Product bonus points.
   */
  bonus_points: string;

  /**
   * Image width/height ratio
   */
  img_ratio: number;

  /**
   * ID
   */
  id: number;

  /**
   * Show type
   */
  show_type: FlowItemCardType;

  /**
   * urls for swiper card
   */
  swiper_urls: Resource[] | string[];

  /**
   * type ID
   */
  typeId: number;
}

/**
 * Water flow item.
 */
export default class ProductItem implements IProductItem {
  image_url: Resource | string;
  name: string;
  discount: string;
  price: string;
  promotion: string;
  bonus_points: string;
  img_ratio: number = 1;
  id: number = 0;
  show_type: FlowItemCardType = FlowItemCardType.IMAGE;
  swiper_urls: Resource[] | string[] = [];
  typeId: number = 0;

  constructor() {
    this.image_url = '';
    this.name = '';
    this.discount = '';
    this.price = '';
    this.promotion = '';
    this.bonus_points = '';
  }
}