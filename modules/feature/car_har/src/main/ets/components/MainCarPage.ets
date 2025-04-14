import { YWRouterNavParams, ywNavManager, YWLocalNavType } from "@learn/nav_router_har"
import { hsLog } from "@learn/logger_har"
import { YWResColor, YWResImage } from "@learn/res_har"
import { CarPayInfo, CartGood, CarUIState, CarViewModel, goodList, GoodObj } from '../model/CarViewModel'

const TAG = "MainCarPage"

const MAIN_RED: string = '#f4304b'
const LIGHT_GRAY: string = '#f5f5f5'
const DEEP_GRAY: string = '#bebebe'


@Builder
export function mainCarBuilder(name:string, params:YWRouterNavParams) {
  NavDestination(){
    MainCarPage()
  }
  .hideTitleBar(true)
}


@Entry
@Component
export default struct MainCarPage {
  @State
  list: CartGood[] = goodList

  @State isEmpty:boolean = true

  private viewModel:CarViewModel = new CarViewModel()

  @State iuState: CarUIState = this.viewModel.iuState

  aboutToAppear(): void {

    setTimeout(()=>{
      this.viewModel.updateData()
      //
      // let payInfo = this.iuState.payInfo
      // payInfo.isTraFree = false
      // payInfo.allPrice = 1001.0
      // payInfo.payPrice = 1999.0
      // this.iuState.payInfo = payInfo
      // this.iuState.isEmpty = true
    }, 2000)
  }

  build() {
    Column() {
      // 标题
      TitleCom({iuState: this.iuState})
      // 内容
      ContentCom({iuState: this.iuState})

      // 支付
      PayCom({iuState: this.iuState})
    }
    .height('100%')
    .backgroundColor(LIGHT_GRAY)
    .onClick(()=>{
      let kkk = this.iuState
      let mm = this.viewModel.iuState
    })

  }
}

// 内容区域
@Component
struct ContentCom {
  @Prop iuState: CarUIState

  build() {
    Scroll() {
      Column() {
        if (this.iuState.isEmpty == false) {
          // 支付
          FreightCom({iuState: this.iuState})
            .margin(10)
          // 商品列表
          Column({ space: 10 }) {
            ListTitleCom({iuState: this.iuState})
            // 自营区域
            List() {
              // ForEach(Array.from({ length: 3 }), (item: CartGood, index: number) => {
              //   ListItem() {
              //     GoodsListItem()
              //   }
              // })

              ForEach(this.iuState.goodList, (item: CartGood, index: number) => {
                ListItem() {
                  GoodsListItem({itemInfo: item})
                }
              })
            }
            .divider({ strokeWidth: .5, startMargin: 10, endMargin: 10, color: DEEP_GRAY })
          }
          .backgroundColor(Color.White)
          .margin({ left: 10, right: 10 })
        } else {
          // 空车 商品为空时显示
          EmptyCom()
        }
      }
    }
    .align(Alignment.Top)
    .padding({ bottom: 10 })
    .edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1)
  }
}

// 标题(显示商品种类)
@Component
struct TitleCom {
  @Prop iuState: CarUIState
  // @ObjectLink
  build() {
    Row() {
      // 文字
      Stack({ alignContent: Alignment.Bottom }) {
        Text(`购物车(10 )`)
          .height('100%')
        Text('')
          .width(25)
          .height(2)
          .linearGradient({ angle: 90, colors: [[MAIN_RED, 0], [Color.White, 1]] })
      }
      .height('100%')

      // 地址
      Row() {
        Image(YWResImage.addressLocate())
          .width(15)
          .fillColor(DEEP_GRAY)
        Text('北京市昌平区建材城西路')
          .fontSize(12)
          .fontColor(DEEP_GRAY)
      }
      .height(20)
      .padding({ left: 5, right: 5 })
      .borderRadius(10)
      .backgroundColor(LIGHT_GRAY)

      // 编辑
      Text('编辑')
    }
    .padding({ left: 20, right: 20 })
    .width('100%')
    .height(40)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(Color.White)
  }
}

// 运费（地址下方）
@Component
struct FreightCom {
  // 默认 69 可以由外部传入
  minPrice: number = 69.00
  totalPrice: number = 0

  @Prop iuState: CarUIState

  build() {
    Column() {
      if (this.iuState.payInfo.isTraFree == false) {
        // 运费不够 提示
        Row() {
          Row({ space: 5 }) {
            // 凑单免运费
            Text() {
              Span('凑单')
              Span('免运费')
                .fontColor(MAIN_RED)
            }
            .fontSize(13)
            .fontFamily('medium')

            // 分割线
            Divider()
              .vertical(true)
              .height(8)
              .color(DEEP_GRAY)
              .strokeWidth(1)

            // 运费信息
            Row() {
              Text() {
                Span('还需凑钱 ')
                Span(`¥${(this.minPrice - this.totalPrice).toFixed(2)}`)
                  .fontColor(MAIN_RED)
                Span('可免运费')
              }
              .fontSize(13)

              Image(YWResImage.cartHelp())
                .width(15)
            }
          }

          // 按钮
          Button() {
            Row() {
              Text('去凑单')
                .fontColor(Color.White)
                .fontSize(12)
              Image(YWResImage.whiteArr())
                .height(14)
                .width(10)
                .fillColor(Color.White)
            }
            .backgroundColor(MAIN_RED)
            .borderRadius(20)
            .padding({ left: 10, top: 3, bottom: 3, right: 2 })
          }
        }
        .width('100%')
      } else {
        // 运费足够 提示
        Row({ space: 5 }) {
          Text('运费')
            .backgroundColor(MAIN_RED)
            .fontSize(12)
            .fontColor(Color.White)
            .padding(2)
            .borderRadius(3)
          Divider()
            .vertical(true)
            .height(12)
            .strokeWidth(2)
          Text('已免运费')
            .fontSize(12)
            .fontColor(Color.Gray)
          Image(YWResImage.cartHelp())
            .width(15)

        }
      }
    }
    .borderRadius(5)
    .height(30)
    .padding({ left: 8, right: 8 })
    .linearGradient({ colors: [['#ffe8ea', 0], [Color.White, 1]] })
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}

// 支付（最下方组件）
@Component
struct PayCom {
  @Prop iuState: CarUIState

  build() {
    Row() {
      Row() {
        CheckboxGroup({
          group: 'cart'
        })
          .selectedColor(MAIN_RED)

        Text('全选')
          .fontSize(12)
      }

      Row() {
        Text('合计:')
          .fontSize(14)
        PriceCom({
          fontColor: Color.Black,
          price: this.iuState.payInfo.allPrice
        })
        Button(`入会结算(${this.iuState.payInfo.payPrice})`)
          .fontColor('#ffe3cc')
          .backgroundColor(Color.Black)
          .fontSize(14)
          .margin({ left: 5 })
      }

    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 10, right: 10 })
    .height(48)
    .width('100%')
    .backgroundColor(Color.White)
    .onClick(()=>{
      //测试
      //这样调整 是有效的
      let testPayInfo = new CarPayInfo()
      testPayInfo.isTraFree = false
      testPayInfo.allPrice = 2001.0
      testPayInfo.payPrice = 999.0
      this.iuState.payInfo = testPayInfo
    })
  }
}

// 价格（根据传入的价格渲染数字）
@Component
struct PriceCom {
  @Prop iuState: CarUIState

  @Prop price: number = 0
  fontColor: ResourceColor = MAIN_RED
  discard: boolean = false

  getSplicePrice() {
    return this.price.toFixed(2)
      .split('.')
  }

  build() {
    Text() {
      Span('¥')
        .fontSize(12)
      Span(this.getSplicePrice()[0]
        .toString())
        .fontSize(this.discard ? 12 : 16)
        .fontWeight(600)
      Span('.')
      Span(this.getSplicePrice()[1] == undefined ? '00' : this.getSplicePrice()[1])
        .fontSize(12)
    }
    .fontColor(this.fontColor)
    .decoration({ type: this.discard ? TextDecorationType.LineThrough : TextDecorationType.None })
  }
}

// 空车：购物车为空显示
@Component
struct EmptyCom {
  build() {
    Column({ space: 20 }) {
      Image(YWResImage.orderBank())
        .width(90)
      Text('购物车竟然是空的~')
        .fontSize(14)
        .fontColor(Color.Gray)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .padding(50)

  }
}

// 列表区域标题：装饰用
@Component
struct ListTitleCom {
  @Prop iuState: CarUIState

  build() {
    Row({ space: 5 }) {
      Image(YWResImage.addressCompany())
        .width(12)
      Text('自营')
        .fontWeight(600)
        .fontSize(15)
      Divider()
        .vertical(true)
        .height(10)
        .strokeWidth(2)
      Text('1号会员店提供服务')
        .fontColor(DEEP_GRAY)
        .fontSize(12)
    }
    .alignSelf(ItemAlign.Start)
    .padding({ left: 15, top: 10 })
  }
}

// 列表项：
@Component
struct GoodsListItem {
  @ObjectLink itemInfo: CartGood

  build() {
    Row({ space: 10 }) {
      // 左
      Checkbox({
        group: 'cart'
      })
        .shape(CheckBoxShape.CIRCLE)
        .selectedColor(MAIN_RED)


      // 右
      Row({ space: 8 }) {
        // 商品图片
        Image('https://m.360buyimg.com/mobilecms/s558x558_jfs/t1/188208/35/38739/41823/6515995cF15cdb08a/cf82ab82e3e36eb7.jpg!q50.jpg.webp')
          .width(90)
          .padding(5)
          .border({ width: .5, color: DEEP_GRAY })
          .borderRadius(10)
        //   信息
        Column() {
          // 标题
          Text(this.itemInfo.goodObj ? this.itemInfo.goodObj.wname : this.itemInfo.good.wname)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontSize(14)
            .fontWeight(400)
            .width('100%')
          Text(`测试sub: ${this.itemInfo.testGoodName}`)
          // 价格 + 数量
          Row() {
            Column() {
              // 左
              Row() {
                Image(YWResImage.cartSaleEn())
                  .width(35)
                PriceCom({ price: 10.00 })
              }

              PriceCom({ discard: true, fontColor: DEEP_GRAY, price: 19.00 })
            }
            .alignItems(HorizontalAlign.Start)

            Blank()

            // 个数 Counter 内置组件
            Counter() {
              Text('2')
            }
            .scale({ x: .8, y: .8 })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
        }
        .height(90)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .layoutWeight(1)
    }
    .padding({ left: 10, top: 10, bottom: 10 })
    .onClick(()=>{
      //测试 这个修改无效
      this.itemInfo.good.wname = "1111"
      let cartGood = new CartGood({
        id: '16756',
        wname: '111 惠润 绿野芳香洗发露 600ml',
        jdPrice: 35.00,
        imageurl: 'https://m.360buyimg.com/mobilecms/s558x558_jfs/t1/188208/35/38739/41823/6515995cF15cdb08a/cf82ab82e3e36eb7.jpg!q50.jpg.webp',
        jdMainPrice: 45.00,
      })

      //无效
      let good = this.itemInfo.good
      good.wname = "222222"

      // 不允许@ObjectLink装饰的数据自身赋值
      // this.objLink= ...
      //this.itemInfo = cartGood

      //这种无效 因为good 是interface
      // this.itemInfo.good = good

      // 这个有效
      // this.itemInfo.good = cartGood.good

      //测试二
      let goodobj = this.itemInfo.goodObj
      if (goodobj) {
        //类也是无效的
        goodobj.wname = "mmmmmm"
        this.itemInfo.goodObj = goodobj
      }

      if (goodobj) {
        //有效，还是要直接赋值
        let testGoodObj = new GoodObj("212","bbbbb",11111)
        this.itemInfo.goodObj = testGoodObj
      }

      //测试三 有效
      // this.itemInfo.testGoodName = "xixixixix"
    })

  }
}