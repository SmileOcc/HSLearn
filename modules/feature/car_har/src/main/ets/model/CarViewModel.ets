import {YWBaseModel, IUState } from '@learn/common_har';

export class CarViewModel extends  YWBaseModel<CarUIState> {
  iuState: CarUIState = new CarUIState()
  goodlist: CartGood[] = goodList

  constructor() {
    super();

    //odd测试数据
    let cartGood = new CartGood({
      id: '16756',
      wname: '惠润 绿野芳香洗发露 600ml',
      jdPrice: 35.00,
      imageurl: 'https://m.360buyimg.com/mobilecms/s558x558_jfs/t1/188208/35/38739/41823/6515995cF15cdb08a/cf82ab82e3e36eb7.jpg!q50.jpg.webp',
      jdMainPrice: 45.00,
    })
    cartGood.goodObj = new GoodObj("123","测试2333",100)
    this.goodlist.push(cartGood)
    this.iuState.goodList = this.goodlist
  }

  updateData() {

    //这种改是无效的，如果是直接给iuState的第一层是可以的，嵌套的不行
    let payInfo = this.iuState.payInfo
    // this.iuState.payInfo.isTraFree = false
    // this.iuState.payInfo.allPrice = 1001.0
    // this.iuState.payInfo.payPrice = 999.0

    payInfo.isTraFree = false
    payInfo.allPrice = 1001.0
    payInfo.payPrice = 999.0
    this.iuState.payInfo = payInfo

    //这样调整 是有效的
    let testPayInfo = new CarPayInfo()
    testPayInfo.isTraFree = false
    testPayInfo.allPrice = 1001.0
    testPayInfo.payPrice = 999.0
    this.iuState.payInfo = testPayInfo
  }
}

@Observed
export class CarUIState implements IUState {
  isLoading:boolean = true
  payInfo: CarPayInfo = new CarPayInfo()
  goodList: CartGood[] = []
  isEmpty: boolean = false
}

@Observed
export class CarPayInfo {
  topTip?: string
  //是否免运费
  isTraFree: boolean = false
  isAll: boolean = false
  allPrice: number = 0.0
  payPrice: number = 0.0
}

export interface Good {
  id: string // id
  wname: string // 名称
  jdPrice: number // 会员价
  imageurl: string // 图片
  jdMainPrice: number // 原价
}

//嵌套内可以不加, 最好添加，防止嵌套监听
@Observed
export class GoodObj {
  id: string // id
  wname: string // 名称
  jdPrice: number // 会员价
  imageurl?: string // 图片
  jdMainPrice?: number // 原价

  constructor(id: string, name: string, jdPrice: number, img?: string, jdMainPrice?: number) {
    this.id = id
    this.wname = name
    this.jdPrice = jdPrice
    this.imageurl = img
    this.jdMainPrice = jdMainPrice
  }
}


@Observed
export class CartGood {
  id: string // id
  good: Good // 商品
  count: number // 个数
  goodObj?: GoodObj
  testGoodName: string = "123333"

  constructor(good: Good, count: number = 1) {
    this.id = good.id
    this.good = good
    this.count = count
  }
}


export const goodList: CartGood[] = [
  new CartGood({
    id: '16756',
    wname: '惠润 绿野芳香洗发露 600ml',
    jdPrice: 35.00,
    imageurl: 'https://m.360buyimg.com/mobilecms/s558x558_jfs/t1/188208/35/38739/41823/6515995cF15cdb08a/cf82ab82e3e36eb7.jpg!q50.jpg.webp',
    jdMainPrice: 45.00,
  }),
  new CartGood({
    id: '16758',
    wname: '潘婷 高保湿深水泡弹 12ml*8盒',
    jdPrice: 59.00,
    imageurl: 'https://m.360buyimg.com/mobilecms/s558x558_jfs/t1/246382/22/1792/26433/6596a0ccFea974bdb/f4961f6aeb7d998f.png!q50.jpg.webp',
    jdMainPrice: 78.00,
  }),
  new CartGood({
    id: '29714',
    wname: '得力 折叠中国象棋套装 原木色 中号',
    jdPrice: 28.90,
    imageurl: 'https://m.360buyimg.com/mobilecms/s558x558_jfs/t1/182908/16/25089/133946/62959bf1E13ddee79/f8c0cd4baaa57db8.jpg!q50.jpg.webp',
    jdMainPrice: 36.90,
  }),
  new CartGood({
    id: '854',
    wname: '南孚 5号碱性电池 30粒',
    jdPrice: 56.00,
    imageurl: 'https://m.360buyimg.com/mobilecms/s558x558_jfs/t1/199998/27/33294/68995/642aceebF857a36e0/994c63e2c6fa0bbb.png!q50.jpg.webp',
    jdMainPrice: 65.90,
  }),
  new CartGood(
    {
      id: '34849',
      wname: '洁丽雅  新疆棉方巾4条装  35*35cm 55g/条',
      jdPrice: 22.90,
      imageurl: 'https://m.360buyimg.com/mobilecms/s558x558_jfs/t1/245460/14/1920/91732/659534b6Fa05d822a/7a92fea15856ee28.png!q50.jpg.webp',
      jdMainPrice: 29.90,
    },
  ), new CartGood(
  {
    id: '3484',
    wname: '洁柔手帕纸Lotion',
    jdPrice: 12.40,
    imageurl: 'https://img14.360buyimg.com/mobilecms/s360x360_jfs/t1/141643/29/1675/581709/5ef85e48Efc16bf7d/1a42445a7d7d55c4.jpg!q70.dpg.webp',
    jdMainPrice: 29.90,
  },
)
]

