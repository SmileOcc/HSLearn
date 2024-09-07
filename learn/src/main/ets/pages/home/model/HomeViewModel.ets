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

import { FlowItemCardType, IProductItem } from './ProductItem';

/**
 * Home page classify title data.
 */
const classifyTitle: Resource[] = [
  $r('app.string.title_bar_homepage'),
  $r('app.string.title_bar_phone'),
  $r('app.string.title_bar_computer'),
  $r('app.string.title_bar_foods'),
  $r('app.string.title_bar_men_wear'),
  $r('app.string.title_bar_fresh'),
  $r('app.string.title_bar_furniture_kitchenware')
];

/**
 * Home page swiper image data.
 */
const swiperImage: Resource[] = [
  $r('app.media.ic_home_appliances_special'),
  $r('app.media.ic_coupons'),
  $r('app.media.ic_internal_purchase_price')
];


/**
 * Home page water flow item init data.
 */
const waterFlowData: IProductItem[] = [
  {
    id: 1,
    typeId: 0,
    image_url: $r('app.media.ic_holder_mate50'),
    img_ratio: 0.75,
    name: 'XXXMate 50 8GB+256GB',
    discount: '',
    price: '5499',
    promotion: '',
    bonus_points: '赠送积分',
    show_type: FlowItemCardType.SWIPER,
    swiper_urls: [
      $r('app.media.ic_holder_mate50'),
      $r('app.media.ic_holder_50e'),
      $r('app.media.ic_holder_mouse')
    ]
  },
  {
    id: 2,
    typeId: 0,
    image_url: $r("app.media.ic_phone_gif"),
    img_ratio: 1,
    name: 'XXXPad Pro',
    discount: '',
    price: '3499',
    promotion: '',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: '赠送积分'
  },
  {
    id: 3,
    typeId: 2,
    image_url: $r('app.media.ic_holder_computer'),
    img_ratio: 0.75,
    name: 'XX设备  一起探索，一起体验',
    discount: '限时省200',
    price: '10099',
    promotion: '推荐',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: '赠送积分'
  },
  {
    id: 4,
    typeId: 3,
    image_url: $r('app.media.ic_holder_mouse'),
    img_ratio: 1.33,
    name: '送给亲人  送给好友',
    discount: '',
    price: '199',
    promotion: '',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: ''
  },
  {
    id: 5,
    typeId: 4,
    image_url: $r('app.media.ic_holder_xs2'),
    img_ratio: 1,
    name: 'XXXPadMate Xs 2 \n8GB+256GB （雅黑）',
    discount: '',
    price: '9999',
    promotion: '限时',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: '赠送积分'
  },
  {
    id: 6,
    typeId: 1,
    image_url: $r('app.media.ic_holder_50e'),
    img_ratio: 1.33,
    name: '分享知识与见解',
    discount: '',
    price: '4088',
    promotion: '',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: ''
  },
  {
    id: 7,
    typeId: 1,
    image_url: $r('app.media.ic_holder_60pro'),
    img_ratio: 0.75,
    name: 'XXX60 Pro 新品上市！\n值得拥有！\n！\n速速分享！',
    discount: '限时省200',
    price: '1299',
    promotion: '新品',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: ''
  },
  {
    id: 8,
    typeId: 0,
    image_url: $r('app.media.ic_holder_50e'),
    img_ratio: 1.33,
    name: 'XXX50E',
    discount: '',
    price: '4088',
    promotion: '',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: '赠送积分'
  },
  {
    id: 9,
    typeId: 4,
    image_url: $r('app.media.ic_holder_xs2'),
    img_ratio: 1,
    name: 'XXXPadMate Xs 2 \n8GB+512GB （雅黑）',
    discount: '',
    price: '9999',
    promotion: '限时',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: '赠送积分'
  },
  {
    id: 10,
    typeId: 2,
    image_url: $r('app.media.ic_holder_computer'),
    img_ratio: 1,
    name: 'XX设备  新品分享！新品分享！',
    discount: '',
    price: '10099',
    promotion: '推荐',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: ''
  },
  {
    id: 11,
    typeId: 3,
    image_url: $r('app.media.ic_holder_mouse'),
    img_ratio: 0.75,
    name: '送给亲人  快速分享！',
    discount: '',
    price: '199',
    promotion: '限时',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: '赠送积分'
  },
  {
    id: 12,
    typeId: 5,
    image_url: $r('app.media.ic_holder_pad'),
    img_ratio: 1.33,
    name: 'XXXPad Pro\n！\n速速分享！\n机不可失！失不再来！',
    discount: '',
    price: '3499',
    promotion: '',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: '赠送积分'
  },
  {
    id: 13,
    typeId: 1,
    image_url: $r('app.media.ic_holder_mate50'),
    img_ratio: 1,
    name: 'XXXMate 50 \n8GB+256GB',
    discount: '',
    price: '5499',
    promotion: '',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: ''
  }
];

const loadingMoreFlowData: IProductItem[] = [
  {
    id: 1,
    typeId: 0,
    image_url: $r('app.media.ic_holder_computer'),
    img_ratio: 1,
    name: 'XX设备  新品分享！新品分享！',
    discount: '',
    price: '10099',
    promotion: '推荐',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: ''
  },
  {
    id: 2,
    typeId: 1,
    image_url: $r('app.media.ic_holder_mouse'),
    img_ratio: 0.75,
    name: '送给亲人  快速分享！',
    discount: '',
    price: '199',
    promotion: '限时',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: '赠送积分'
  },
  {
    id: 3,
    typeId: 2,
    image_url: $r('app.media.ic_holder_computer'),
    img_ratio: 0.75,
    name: 'XX设备  一起探索，一起体验',
    discount: '限时省200',
    price: '10099',
    promotion: '推荐',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: '赠送积分'
  },
  {
    id: 4,
    typeId: 3,
    image_url: $r('app.media.ic_holder_mouse'),
    img_ratio: 1.33,
    name: '送给亲人  送给好友',
    discount: '',
    price: '199',
    promotion: '',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: ''
  },
  {
    id: 5,
    typeId: 4,
    image_url: $r('app.media.ic_holder_xs2'),
    img_ratio: 1,
    name: 'XXXPadMate Xs 2 \n8GB+256GB （雅黑）',
    discount: '',
    price: '9999',
    promotion: '限时',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: '赠送积分'
  },
  {
    id: 6,
    typeId: 1,
    image_url: $r('app.media.ic_holder_50e'),
    img_ratio: 1.33,
    name: '分享知识与见解',
    discount: '',
    price: '4088',
    promotion: '',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: ''
  },
  {
    id: 7,
    typeId: 1,
    image_url: $r('app.media.ic_holder_60pro'),
    img_ratio: 0.75,
    name: 'XXX60 Pro 新品上市！\n值得拥有！\n！\n速速分享！',
    discount: '限时省200',
    price: '1299',
    promotion: '新品',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: ''
  },
  {
    id: 8,
    typeId: 0,
    image_url: $r('app.media.ic_holder_50e'),
    img_ratio: 1.33,
    name: 'XXX50E',
    discount: '',
    price: '4088',
    promotion: '',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: '赠送积分'
  },
  {
    id: 9,
    typeId: 1,
    image_url: $r('app.media.ic_holder_xs2'),
    img_ratio: 1,
    name: 'XXXPadMate Xs 2 \n8GB+256GB （雅黑）',
    discount: '',
    price: '9999',
    promotion: '限时',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: '赠送积分'
  },
  {
    id: 10,
    typeId: 2,
    image_url: $r('app.media.ic_holder_computer'),
    img_ratio: 1,
    name: 'XX设备  新品分享！新品分享！',
    discount: '',
    price: '10099',
    promotion: '推荐',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: ''
  },
  {
    id: 11,
    typeId: 3,
    image_url: $r('app.media.ic_holder_mouse'),
    img_ratio: 0.75,
    name: '送给亲人  快速分享！',
    discount: '',
    price: '199',
    promotion: '限时',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: '赠送积分'
  },
  {
    id: 12,
    typeId: 5,
    image_url: $r('app.media.ic_holder_pad'),
    img_ratio: 1.33,
    name: 'XXXPad Pro\n！\n速速分享！\n机不可失！失不再来！',
    discount: '',
    price: '3499',
    promotion: '',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: '赠送积分'
  },
  {
    id: 13,
    typeId: 1,
    image_url: $r('app.media.ic_holder_mate50'),
    img_ratio: 1,
    name: 'XXXMate 50 \n8GB+256GB',
    discount: '',
    price: '5499',
    promotion: '',
    show_type: FlowItemCardType.IMAGE,
    swiper_urls: [],
    bonus_points: ''
  }
];

export { classifyTitle, swiperImage, waterFlowData, loadingMoreFlowData };