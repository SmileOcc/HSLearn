export class GoodsModel {
  name : String
  image : String = '';
  price : number
  discount : number | undefined //折扣价

  //构造函数
  constructor(name: String, image: String, price: number, discount?: number) {
    this.name = name
    this.image = image
    this.price = price
    this.discount = discount
  }


}

// export function MockGoodList(): Array<GoodsModel> {
export function MockGoodList() {

  //图片资源
  let url: String = 'https://lmg.jj20.com/up/allimg/1114/0406210Z024/2104060Z024-5-1200.jpg'

  let items:Array<GoodsModel> = [
    new GoodsModel('华为',url,3456),
    new GoodsModel('遥遥领先',url,56,15),
    new GoodsModel('很吊啊',url,3756,500),
    new GoodsModel('列表',url,9456),
    new GoodsModel('产品',url,4456),
    new GoodsModel('很吊啊',url,3456),
    new GoodsModel('列表1',url,3456),
    new GoodsModel('列表2',url,3456),
    new GoodsModel('列表3',url,3456),
    new GoodsModel('列表4',url,3456),
    new GoodsModel('列表5',url,3456),
    new GoodsModel('列表6',url,3456),
    new GoodsModel('列表7',url,3456),

  ]

  return items
}
