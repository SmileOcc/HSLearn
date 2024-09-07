

// import { NavBar } from '../components/NavBar/NavBar'
import router from '@ohos.router';
// import { Condition, ConditionList } from '../model/Condition';
import { PullToRefresh } from '@ohos/pulltorefresh'
// import { ProductModel } from '../model/ProductModel';
// import { config } from '../common/config';
// import { ReplacePath } from '../common/utils';
import promptAction from '@ohos.promptAction';
import KLogger from '../../../../../../modules/common_har/src/main/ets/common/KLogger';


class ProductModel {
  title: string | undefined = ''
  sub_title: string | undefined = ''
  pic: string | undefined = ''
  price: string | undefined = ''
}


@Observed
class Condition {
  name: string
  checked: boolean
  list: ConditionList[]

  constructor(title: string, flg: boolean, list: ConditionList[]) {
    this.name = title
    this.checked = flg
    this.list = list
  }
}

class ConditionList {
  name: string
  checked: boolean

  constructor(title: string, flg: boolean) {
    this.name = title
    this.checked = flg
  }
}

@Entry
@Component
struct ProductListPage {
  @State opacityValue: number = 100;
  @State selectIndex: number = 0;
  @State conditionListData: Condition [] = [
    new Condition("数据接口", false, [new ConditionList("Type-C", false)]),
    new Condition("指纹识别", false, [new ConditionList("侧边指纹", false), new ConditionList("屏下指纹", false)]),
    new Condition("电池容量", false, [new ConditionList("4600mAh", false), new ConditionList("4610mAh", false), new ConditionList("4500mAh", false), new ConditionList("4880mAh", false)]),
    new Condition("CPU主频", false, [new ConditionList("最高3.2GHz", false), new ConditionList("最高3.3GHz", false)]),
    new Condition("CPU型号", false, [new ConditionList("骁龙8+", false), new ConditionList("第三代骁龙8+", false)]),
    new Condition("存储容量", false, [new ConditionList("最高1024GB", false), new ConditionList("最高512GB", false)]),
  ]
  @State toggleIndex: number = 0;
  @State isSelect: boolean = false;
  @State priceSort: number = -1; //价格排序
  @State topAreaHeight: number = 0;
  @State filterAreaHeight: number = 0;
  @State productListData: ProductModel[] = [];
  @State cid: string = "";
  @State page: number = 1;
  @State isMore: boolean = true; //是否还有更多产品
  // 需绑定列表或宫格组件
  private scroller: Scroller = new Scroller();

  aboutToAppear() {
    this.getProductList(this.cid);
  }

  getProductList(cid: string, resolve?: (value: string | PromiseLike<string>) => void) {

    let tempData: ProductModel[] = []
    for (let i = 0; i < 10; i++) {
      let product = new ProductModel()
      product.title = 'title' + i
      product.sub_title = 'sub_title' + i
      product.pic = ''
      product.price = '100' + i
      tempData.push(product)
    }

    this.productListData = this.productListData.concat(tempData);
    this.isMore = tempData.length < 10 ? false : true; //每页十条
    if (this.isMore) {
      this.page++;
    }
    if (resolve) {
      setTimeout(() => {
        resolve('刷新成功');
      }, 2000);
    }
  }

  //搜索区域
  @Builder
  SearchArea() {
    Row() {
      Image($r("app.media.arrow_left_new"))
        .width("42lpx")
        .height("42lpx")
        .margin({ right: '20lpx' })
        .onClick(() => {
          router.back();
        })

      Search({
        placeholder: "手机",
      })
        .layoutWeight(1)
        .height("100lpx")
        .placeholderFont({ size: 12, weight: 400 })
        .textFont({ size: 12, weight: 400 })
      Text("搜索").fontSize('32lpx')
        .margin({ left: "30lpx" })

    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height('120lpx')
    .padding({ left: '34lpx', right: '34lpx' })
    .backgroundColor("#fff")
    .onTouch(() => {
      this.toggleIndex = 0;
      this.isSelect = false;
    })
  }

  @Builder
  TopAreaWidget() {
    Column() {
      // NavBar({
      //   title: "",
      //   isCustom: true,
      //   opacityValue: $opacityValue
      // }) {
      //   this.SearchArea()
      // }
      this.SearchArea()
    }.onAreaChange((oldValue: Area, newValue: Area) => {
      this.topAreaHeight = Number(newValue.height);
    })
  }

  //筛选区域
  @Builder
  FilterWidget() {
    Column() {
      Row() {
        Text("综合")
          .layoutWeight(1)
          .height('90lpx')
          .fontSize("36lpx")
          .textAlign(TextAlign.Center)
          .fontWeight(this.selectIndex === 0 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.selectIndex === 0 ? $r("app.color.theme_color_orange") : '#000')
          .onClick(() => {
            this.selectIndex = 0;
            this.priceSort = -1;
          })

        Text("销量")
          .layoutWeight(1)
          .height('90lpx')
          .fontSize("36lpx")
          .textAlign(TextAlign.Center)
          .fontWeight(this.selectIndex === 1 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.selectIndex === 1 ? $r("app.color.theme_color_orange") : '#000')
          .onClick(() => {
            this.selectIndex = 1;
            this.priceSort = -1;
          })

        Row() {
          Text("价格")
            .fontSize("36lpx")
            .fontWeight(this.selectIndex === 2 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.selectIndex === 2 ? $r("app.color.theme_color_orange") : '#000')

          Column() {
            Image($r("app.media.arrow_left_new"))
              .width('18lpx')
              .height('18lpx')
              .fillColor(this.priceSort === 0 ? $r("app.color.theme_color_orange") : "#ffc6c6c6")
            Image($r("app.media.arrow_right_new"))
              .width('18lpx')
              .height('18lpx')
              .fillColor(this.priceSort === 1 ? $r("app.color.theme_color_orange") : "#ffc6c6c6")
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .margin({
            left: '8lpx'
          })
        }
        .layoutWeight(1)
        .height('90lpx')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.selectIndex = 2;

          if (this.priceSort === -1) {
            this.priceSort = 0
          } else if (this.priceSort === 0) {
            this.priceSort = 1
          } else if (this.priceSort === 1) {
            this.priceSort = 0
          }
        })

        Text("新品优先")
          .layoutWeight(1)
          .height('90lpx')
          .fontSize("36lpx")
          .textAlign(TextAlign.Center)
          .fontWeight(this.selectIndex === 3 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.selectIndex === 3 ? $r("app.color.theme_color_orange") : '#000')
          .onClick(() => {
            this.selectIndex = 3;
            this.priceSort = -1;
          })

        Text("筛选")
          .layoutWeight(1)
          .height('90lpx')
          .textAlign(TextAlign.Center)
          .fontSize("36lpx")
          .onClick(() => {

          })
      }
      .width('100%')
      .height('90lpx')
      .justifyContent(FlexAlign.SpaceAround)
      .backgroundColor("#fff")
      .onTouch(() => {
        this.toggleIndex = 0;
        this.isSelect = false;
      })

      Scroll() {
        Row({ space: "30lpx" }) {
          ForEach(this.conditionListData, (item: Condition, key) => {
            Row() {
              Text(item.name).fontSize('30lpx')
              Image($r("app.media.arrow_left_new"))
                .width("18lpx")
                .height('18lpx')
                .fillColor("#ffc6c6c6")
                .margin({ left: '8lpx', top: '8lpx' })
            }
            .height(this.toggleIndex === key && this.isSelect ? '76lpx' : '66lpx')
            .backgroundColor("#f4f4f4")
            .padding({ left: '16lpx', right: '16lpx', top: '18lpx' })
            .margin({
              bottom: this.toggleIndex === key && this.isSelect ? 0 : '10lpx'
            })
            .alignItems(VerticalAlign.Top)
            .borderRadius({
              topLeft: 2,
              topRight: 2,
              bottomLeft: this.toggleIndex === key && this.isSelect ? 0 : 2,
              bottomRight: this.toggleIndex === key && this.isSelect ? 0 : 2
            })
            .onClick(() => {
              item.checked = !item.checked;
              this.isSelect = this.toggleIndex === key && this.isSelect ? false : true;
              this.toggleIndex = key;
            })

          })
        }
        .height('90lpx')
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Bottom)
        .padding({ left: '30lpx', right: '30lpx' })

      }
      .width("100%")
      .height('90lpx')
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .backgroundColor("#fff")
    }.onAreaChange((oldValue: Area, newValue: Area) => {
      this.filterAreaHeight = Number(newValue.height);
    })
  }

  //筛选下拉弹窗
  @Builder
  FilterPopupWidget() {
    if (this.isSelect) {
      Stack({ alignContent: Alignment.Top }) {
        Column() {
        }
        .width('100%')
        .height('100%')
        .backgroundColor("#000")
        .opacity(0.2)
        .offset({
          y: '180lpx'
        })
        .onTouch(() => {
          this.toggleIndex = 0;
          this.isSelect = false;
        })

        FilterListDataView({ datas: this.conditionListData[this.toggleIndex], currentIndex: this.toggleIndex });
      }.height("100%")
    }
  }

  //帮你挑
  @Builder
  HelpYouChoose() {
    Column() {
      Row() {
        Column() {
          Text("手机「帮你挑」")
            .fontSize("34lpx")
            .fontColor($r("app.color.theme_color_orange"))
            .textAlign(TextAlign.Start)
            .width('100%')
          Text("帮你轻松选手机")
            .fontColor("#999")
            .fontSize("30lpx")
            .margin({ top: '6lpx' })
            .textAlign(TextAlign.Start)
            .width('100%')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Start)

        Row() {
          Text("去看看")
            .fontSize("28lpx")
            .fontColor("#999")
          Image($r("app.media.arrow_right_new"))
            .width("20lpx")
            .height("20lpx")
        }
      }.width("100%")
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: '20lpx' })


      Grid() {
        GridItem() {
          Column() {
            Column() {
              Image("https://cdn.cnbj1.fds.api.mi-img.com/mi-mall/5c57d3a5e8a2fde79bcffce9d5344c80.png?thumb=1&w=120&h=120&f=webp&q=100")
                .width("100%")
                .height('100%')
            }
            .width("200lpx")
            .height('200lpx')
            .backgroundColor("#f4f4f4")
            .borderRadius(6)
            .padding("30lpx")

            Text("Xiaomi MIX系列")
              .fontSize("28lpx")
              .fontWeight(500)
              .margin({ top: "20lpx" })
          }
        }

        GridItem() {
          Column() {
            Column() {
              Image("https://cdn.cnbj1.fds.api.mi-img.com/mi-mall/16cb4384a3d34bf7b480f3b9ce4f00a7.png?thumb=1&w=120&h=120&f=webp&q=100")
                .width("100%")
                .height('100%')
            }
            .width("200lpx")
            .height('200lpx')
            .backgroundColor("#f4f4f4")
            .borderRadius(6)
            .padding("30lpx")

            Text("Xiaomi 数字旗舰")
              .fontSize("28lpx")
              .fontWeight(500)
              .margin({ top: "20lpx" })
          }
        }

        GridItem() {
          Column() {
            Column() {
              Image("https://cdn.cnbj1.fds.api.mi-img.com/mi-mall/c29ce8888fee7bf46aa56cfdb5367b06.png?thumb=1&w=120&h=120&f=webp&q=100")
                .width("100%")
                .height('100%')
            }
            .width("200lpx")
            .height('200lpx')
            .backgroundColor("#f4f4f4")
            .borderRadius(6)
            .padding("30lpx")

            Text("Redmi K系列")
              .fontSize("28lpx")
              .fontWeight(500)
              .margin({ top: "20lpx" })
          }
        }

        GridItem() {
          Column() {
            Column() {
              Image("https://cdn.cnbj1.fds.api.mi-img.com/mi-mall/2d2df29f703cb991f0425ef37ac1aa96.png?thumb=1&w=120&h=120&f=webp&q=100")
                .width("100%")
                .height('100%')
            }
            .width("200lpx")
            .height('200lpx')
            .backgroundColor("#f4f4f4")
            .borderRadius(6)
            .padding("30lpx")

            Text("Redmi Turbo系列")
              .fontSize("28lpx")
              .fontWeight(500)
              .margin({ top: "20lpx" })
          }
        }
      }.columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsTemplate("1fr")
      .columnsGap("30lpx")
      .height('300lpx')

    }
    .backgroundColor("#fff")
    .borderRadius(8)
    .padding("20lpx")
    .margin({ left: "20lpx", right: "20lpx", top: "20lpx" })
  }

  //产品组件
  @Builder
  ProductWidget() {
    Scroll(this.scroller) {
      Column({ space: "20lpx" }) {
        this.HelpYouChoose();

        ForEach(this.productListData, (item: ProductModel, key) => {
          Column() {
            Row() {
              Image($r('app.media.logo'))
                .width("280lpx")
                .height("280lpx")
                .borderRadius(6)

              Column() {
                Text(item.title)
                  .width('100%')
                  .fontSize("38lpx")
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Start)
                Text(item.sub_title)
                  .width('100%')
                  .fontSize('32lpx')
                  .textAlign(TextAlign.Start)
                  .fontColor("#999")
                  .margin({
                    top: "16lpx",
                    bottom: "16lpx"
                  })
                  .textOverflow({
                    overflow: TextOverflow.Ellipsis,
                  })
                  .maxLines(2)


                Row() {
                  Column() {
                    Text("CPU")
                      .fontSize("26lpx")
                      .fontColor("#444")
                      .fontWeight(500)
                    Text("Helio G25")
                      .fontSize("24lpx")
                      .fontColor("#888")
                      .margin({
                        top: "10lpx"
                      })
                  }

                  Divider()
                    .vertical(true)
                    .height('50lpx')
                    .strokeWidth(1)
                    .color("#ffeeeeee")
                    .margin({ left: "10lpx", right: "10lpx" })

                  Column() {
                    Text("高清拍摄")
                      .fontSize("26lpx")
                      .fontColor("#444")
                      .fontWeight(500)
                    Text("2000w像素")
                      .fontSize("24lpx")
                      .fontColor("#888")
                      .margin({
                        top: "10lpx"
                      })
                  }

                  Divider()
                    .vertical(true)
                    .height('50lpx')
                    .strokeWidth(1)
                    .color("#ffeeeeee")
                    .margin({ left: "10lpx", right: "10lpx" })

                  Column() {
                    Text("超大屏")
                      .fontSize("26lpx")
                      .fontColor("#444")
                      .fontWeight(500)
                    Text("6.7寸")
                      .fontSize("24lpx")
                      .fontColor("#888")
                      .margin({
                        top: "10lpx"
                      })
                  }
                }.width("100%")
                .justifyContent(FlexAlign.SpaceAround)

                Row() {
                  Text("￥").fontSize("26lpx").fontWeight(FontWeight.Bold)
                  Text(`${item.price}`).fontSize("38lpx").fontWeight(FontWeight.Bold)
                  Text("起").fontSize("26lpx").fontWeight(FontWeight.Bold)
                }
                .width("100%")
                .justifyContent(FlexAlign.Start)
                .alignItems(VerticalAlign.Bottom)
                .margin({ top: "20lpx" })

                Row() {
                  Text("0条评价").fontSize("28lpx")
                    .fontColor("#999")
                    .margin({ right: "30lpx" })
                  Text("99.3%满意").fontSize("28lpx")
                    .fontColor("#999")
                }.width("100%")
                .justifyContent(FlexAlign.Start)
                .margin({ top: "20lpx" })

              }
              .layoutWeight(1)
              .justifyContent(FlexAlign.Start)
              .padding({ left: "20lpx" })
            }
            .width("100%")
            .backgroundColor("#fff")
            .borderRadius(8)
            .padding("30lpx")
            .alignItems(VerticalAlign.Top)

          }.padding({
            left: "20lpx",
            right: "20lpx"
          })
        }, (item: string) => item)

        if (!this.isMore) {
          Text("—————我也是有底线的—————")
            .width("100%")
            .margin({
              top: "20lpx",
              bottom: "20lpx"
            })
            .textAlign(TextAlign.Center)
            .fontSize("32lpx")
            .fontColor("#999")
        }

      }.width("100%")
      .padding({ bottom: "20lpx" })
    }
    .onScrollStart(()=>{
      KLogger.debug(`=== start ${this.scroller.currentOffset().yOffset}`)
    })
    .onScroll(()=>{
      KLogger.debug(`=== scroll ${this.scroller.currentOffset().yOffset}`)

    })
    .onAppear(()=>{
      KLogger.debug(`=== onAppear ${this.scroller.currentOffset().yOffset}`)

    })
    .onAreaChange((oldValue: Area, newValue: Area)=>{
      KLogger.debug(`=== onAreaChange ${this.scroller.currentOffset().yOffset}`)
      KLogger.debug(`=== onAreaChange ${JSON.stringify(oldValue)}`)
      KLogger.debug(`=== onAreaChange ${JSON.stringify(newValue)}`)


    })
    .onTouch((event)=>{
      KLogger.debug(`=== onTouch ${this.scroller.currentOffset().yOffset}`)

    })
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {

      //商品内容
      Column() {

        PullToRefresh({
          // 必传项，列表组件所绑定的数据
          data: this.productListData,
          // 必传项，需绑定传入主体布局内的列表或宫格组件
          scroller: this.scroller,
          // 必传项，自定义主体布局，内部有列表或宫格组件
          customList: () => {
            // 一个用@Builder修饰过的UI方法
            //商品列表
            this.ProductWidget();
          },
          // 可选项，下拉刷新回调
          onRefresh: () => {
            return new Promise<string>((resolve, reject) => {
              // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
              this.page = 0;
              this.productListData = [];
              this.getProductList(this.cid, resolve)
            });
          },
          // 可选项，上拉加载更多回调
          onLoadMore: () => {
            return new Promise<string>((resolve, reject) => {
              // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
              this.getProductList(this.cid, resolve)
            });
          },
          customLoad: null,
          customRefresh: null,
        })


        // 足迹按钮
        Stack({ alignContent: Alignment.BottomEnd }) {
          RelativeContainer() {
            Button() {
              Image($r("app.media.account_message_new"))
                .width("54lpx")
                .height("54lpx")
                .fillColor("#666")
            }
            .alignRules({
              right: {
                anchor: "__container__",
                align: HorizontalAlign.End
              },
              bottom: {
                anchor: "__container__",
                align: VerticalAlign.Bottom
              }
            })
            .width("100lpx")
            .height('100lpx')
            .backgroundColor("#fff")
            .shadow({
              radius: 20,
              color: "rgba(0,0,0,0.2)"
            })
            .id("btn1")
          }
          .width("100lpx")
          .height("100lpx")
          .offset({
            x: -15,
            y: -120
          })
        }.width("100%")

      }
      .width('100%')
      .height('100%')
      .backgroundColor("#f4f4f4")
      .padding({ top: this.topAreaHeight + this.filterAreaHeight })

      //顶部内容
      Column() {
        this.TopAreaWidget();
        //筛选条件组件
        this.FilterWidget();
        this.FilterPopupWidget();
      }

    }
  }
}

//筛选条件列表组件
@Component
struct FilterListDataView {
  @ObjectLink datas: Condition
  @Prop currentIndex: number

  build() {
    Column() {
      List() {
        ForEach(this.datas.list, (item: ConditionList, key) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontSize("34lpx")
                .fontColor(item.checked ? $r("app.color.theme_color_orange") : "#000")
              Image($r("app.media.arrow_left_new"))
                .width("44lpx")
                .height("44lpx")
                .fillColor($r("app.color.theme_color_orange"))
                .visibility(item.checked ? Visibility.Visible : Visibility.Hidden)
            }.width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ left: "30lpx", right: "30lpx", top: "30lpx", bottom: "30lpx" })
            .onClick(() => {
              this.datas.list[key].checked = !this.datas.list[key].checked;
              this.datas.list = [...this.datas.list]
            })
          }

        })
      }
      .divider({
        strokeWidth: 1,
        startMargin: 10,
        endMargin: 10
      })

      Row({ space: "30lpx" }) {
        Button("重置")
          .layoutWeight(1)
          .height('100lpx')
          .fontSize("34lpx")
          .onClick(() => {
            for (let i = 0; i < this.datas.list.length; i++) {
              this.datas.list[i].checked = false
            }
            this.datas.list = [...this.datas.list];
          })
        Button("确定")
          .layoutWeight(1)
          .height('100lpx')
          .fontSize("34lpx")
          .fontColor(Color.White)
          .backgroundColor($r("app.color.theme_color_orange"))
          .onClick(() => {
            console.log(this.currentIndex + '')
          })
      }
      .width("100%")
      .padding({ left: "30lpx", right: "30lpx", top: "30lpx", bottom: "30lpx" })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width("100%")
    .backgroundColor("#f4f4f4")

  }
}



