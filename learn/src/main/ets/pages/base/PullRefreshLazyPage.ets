import { PullToRefresh } from '@ohos/pulltorefresh'
// import { Logger } from '@yunkss/eftool';
import { MyDataSource } from '../../../../../../modules/common_har/src/main/ets/common/BasicDataSource';
import { YWConstants } from '@learn/constants_har';
import KLogger from '../../../../../../modules/common_har/src/main/ets/common/KLogger';
import { NavigationBar } from '../../common/NavigationBar';
import { LazyDataSource } from './model/LayzBasicDataSource';
import { LazyProductModel } from './model/LazyProductModel';


@Entry
@Component
struct PullRefreshLazyPage {
  @State message: string = 'Hello World';
  // 需绑定列表或宫格组件
  private scroller: Scroller = new Scroller();
  private windowHeight: number = 0
  @State private imgMarginTop: number = -100
  @State private refreshPullDownHeight: number = 0
  private pullDownHeightRadix: number = 200
  @State data: LazyDataSource = new LazyDataSource();
  @State listData: LazyProductModel[] = [];
  private isWay = 1

  aboutToAppear() {
    for (let i = 0; i <= 20; i++) {
      this.data.pushData({ title: `atitle ${i}`, sub_title: 'desc' })
      this.listData.push({ title: `atitle ${i}`, sub_title: 'desc' })
    }
  }

  creatTempData() {
    let tempDatas: MyDataSource<LazyProductModel> = new MyDataSource()
    let ranmStr = YWConstants.RandomColor()
    for (let i = 0; i <= 20; i++) {
      tempDatas.pushData({ title: `title ${i} _ ${ranmStr}`, sub_title: 'desc' })
    }
    return tempDatas
  }

  // ======================= 方式一: list不是懒加载 =======================//

  // @Builder getListView() {
  //   List({space:3, scroller:this.scroller}) {
  //     ForEach(this.listData, (item: LazyProductModel) => {
  //       ListItem() {
  //         Row() {
  //           Text(item.title).fontSize(50)
  //             .onAppear(() => {
  //               KLogger.debug("appear:" + item.title)
  //             })
  //         }
  //         .height(120)
  //         .backgroundColor(YWConstants.RandomColor())
  //         .margin({ left: 10, right: 10 })
  //       }
  //     }, (item: LazyProductModel) => item.title)
  //   }
  //   // TODO: 知识点：必须设置列表为滑动到边缘无效果，否则无法触发pullToRefresh组件的上滑下拉方法。
  //   .edgeEffect(EdgeEffect.None)
  // .onScrollStart(()=>{
  //   KLogger.debug(`=== start ${this.scroller.currentOffset().yOffset}`)
  // })
  // .onScroll(()=>{
  //   KLogger.debug(`=== scroll ${this.scroller.currentOffset().yOffset}`)
  //
  // })
  // .onAppear(()=>{
  //   KLogger.debug(`=== onAppear ${this.scroller.currentOffset().yOffset}`)
  //
  // })
  // .onAreaChange((oldValue: Area, newValue: Area)=>{
  //   KLogger.debug(`=== onAreaChange ${this.scroller.currentOffset().yOffset}`)
  //   KLogger.debug(`=== onAreaChange ${JSON.stringify(oldValue)}`)
  //   KLogger.debug(`=== onAreaChange ${JSON.stringify(newValue)}`)
  //
  //
  // })
  // .onTouch((event)=>{
  //   KLogger.debug(`=== onTouch ${this.scroller.currentOffset().yOffset}`)
  //
  // })
  // .width('100%')
  // .height('100%')
  // }

  // build() {
  //   Row() {
  //     PullToRefresh({
  //       // 必传项，列表组件所绑定的数据
  //       data: this.listData,
  //       // 必传项，需绑定传入主体布局内的列表或宫格组件
  //       scroller: this.scroller,
  //       // 必传项，自定义主体布局，内部有列表或宫格组件
  //       customList: () => {
  //         // 一个用@Builder修饰过的UI方法
  //         this.getListView();
  //       },
  //       // 可选项，下拉刷新回调
  //       onRefresh: () => {
  //         return new Promise<string>((resolve, reject) => {
  //           // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
  //           setTimeout(() => {
  //             resolve('刷新成功');
  //             // this.data = this.creatTempData();
  //           }, 3000);
  //         });
  //       },
  //       // 可选项，上拉加载更多回调
  //       onLoadMore: () => {
  //         return new Promise<string>((resolve, reject) => {
  //           // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
  //           setTimeout(() => {
  //
  //             let tempDatas:MyDataSource<LazyProductModel> = new MyDataSource()
  //             let ranmStr = YWConstants.RandomColor()
  //             for (let i = 0; i <= 20; i++) {
  //               this.data.pushData({title:`title ${i} _ ${ranmStr}`,sub_title:'desc'})
  //               this.listData.push({title:`title ${i} _ ${ranmStr}`,sub_title:'desc'})
  //
  //             }
  //
  //             resolve('');
  //
  //
  //           }, 2000);
  //         });
  //       },
  //       customLoad: null,
  //       customRefresh: null,
  //
  //     })
  //   }
  //   .width('100%')
  //   .height('100%')
  // }


  // ======================= 方式一: list懒加载 =======================//

  @Builder
  getListView() {
    List({ space: 3, scroller: this.scroller }) {
      LazyForEach(this.data, (item: LazyProductModel) => {
        ListItem() {
          Row() {
            Text(item.title).fontSize(50)
              .onAppear(() => {
                KLogger.debug("appear:" + item.title)
              })
          }
          .height(120)
          .backgroundColor(YWConstants.RandomColor())
          .margin({ left: 10, right: 10 })
        }
      }, (item: LazyProductModel) => item.title)
    }
    .padding({ top: 100 })
    // TODO: 知识点：必须设置列表为滑动到边缘无效果，否则无法触发pullToRefresh组件的上滑下拉方法。
    .edgeEffect(EdgeEffect.None)
    .onScrollStart(() => {
      KLogger.debug(`=== onScrollStart ${this.scroller.currentOffset().yOffset}`)
    })
    .onScroll((scrollOffset: number) => { //往下滑动不会触发， 神奇

      if (this.isWay == 0) {
        // 获取List上滑的高度，控制图片上滑的高度
        if (this.imgMarginTop >= -100) {
          this.imgMarginTop = -100
        } else {
          this.imgMarginTop -= scrollOffset;
        }

      }
      KLogger.debug(`=== scrollOffset:${scrollOffset}  -- ${this.imgMarginTop}`)

    })
    .onAppear(() => {
      KLogger.debug(`=== onAppear ${this.scroller.currentOffset().yOffset}`)

    })
    .onAreaChange((oldValue: Area, newValue: Area) => { //上拉、下拉在边界区域变化时
      KLogger.debug(`=== onAreaChange ${JSON.stringify(oldValue)}`)
      KLogger.debug(`=== onAreaChange ${JSON.stringify(newValue)}`)

      // TODO 知识点: 通过onAreaChange获取到List的区域高度，与屏幕高度计算差值，得到下拉高度，除以高度基数，表明图片变化的高度是下拉高度的1/2
      this.refreshPullDownHeight = (this.windowHeight - (newValue.height as number)) / this.pullDownHeightRadix;
      KLogger.debug(`=== onAreaChange ${this.refreshPullDownHeight}`)

    })
    .onTouch((event) => {
      KLogger.debug(`=== onTouch ${this.scroller.currentOffset().yOffset}`)

    })
    .width('100%')
    .height('100%')
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      //方式一 改坐标
      if (this.isWay == 0) {
        Image('')
          .position({x:0,y:this.imgMarginTop + this.pullDownHeightRadix * this.refreshPullDownHeight})
          .backgroundColor(Color.Green)
          .width('100%')
          .height(this.pullDownHeightRadix)
      } else {
        //改图片高度
        Image($r('app.media.logo'))
          .position({ x: 0, y: this.imgMarginTop })
          .objectFit(ImageFit.Cover)
          .backgroundColor(Color.Green)
          .width('100%')
          .height(this.pullDownHeightRadix + this.pullDownHeightRadix * this.refreshPullDownHeight)

      }



      Row() {
        PullToRefresh({
          // 必传项，列表组件所绑定的数据
          data: $data,
          // 必传项，需绑定传入主体布局内的列表或宫格组件
          scroller: this.scroller,
          // 必传项，自定义主体布局，内部有列表或宫格组件
          customList: () => {
            // 一个用@Builder修饰过的UI方法
            this.getListView();
          },
          // 可选项，下拉刷新回调
          onRefresh: () => {
            return new Promise<string>((resolve, reject) => {
              // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
              setTimeout(() => {
                resolve('刷新成功');
                // this.data = this.creatTempData();
              }, 3000);
            });
          },
          // 可选项，上拉加载更多回调
          onLoadMore: () => {
            return new Promise<string>((resolve, reject) => {
              // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
              setTimeout(() => {

                let tempDatas: MyDataSource<LazyProductModel> = new MyDataSource()
                let ranmStr = YWConstants.RandomColor()
                for (let i = 0; i <= 20; i++) {
                  this.data.pushData({ title: `title ${i} _ ${ranmStr}`, sub_title: 'desc' })
                  this.listData.push({ title: `title ${i} _ ${ranmStr}`, sub_title: 'desc' })

                }

                resolve('');


              }, 2000);
            });
          },
          customLoad: null,
          customRefresh: null,

        })
          .onAreaChange((oldValue, newValue) => {
            // TODO 知识点：PullToRefresh组件会铺满整改屏幕，通过onAreaChange获取到的区域高度就是屏幕高度
            // TODO 知识点：并且PullToRefresh组件不会随着上拉或下拉变化，该接口只会回调一次，此处不存在频繁回调造成的性能问题
            this.windowHeight = (newValue.height as number);
            KLogger.debug(`==== windowHeight ${this.windowHeight}`)
          })
      }
      .width('100%')
      // .layoutWeight(1)
      .height('100%')

    }
    .height('100%')

  }

  // ======================= 方式一: Scroll是懒加载 =======================//


  // @Builder getListView() {//可以出现刷新
  //   Scroll(this.scroller) {
  //     Column(){
  //       LazyForEach(this.data, (item: LazyProductModel) => {
  //         ListItem() {
  //           Row() {
  //             Text(item.title).fontSize(50)
  //               .onAppear(() => {
  //                 //KLogger.debug("appear:" + item.title)
  //               })
  //           }
  //           .height(120)
  //           .backgroundColor(YWConstants.RandomColor())
  //           .margin({ left: 10, right: 10 })
  //         }
  //       }, (item: LazyProductModel) => item.title)
  //     }
  //   }
  //   .onScrollStart(()=>{
  //     KLogger.debug(`=== start ${this.scroller.currentOffset().yOffset}`)
  //   })
  //   .onScroll(()=>{
  //     KLogger.debug(`=== scroll ${this.scroller.currentOffset().yOffset}`)
  //   })
  //   .onAppear(()=>{
  //     KLogger.debug(`=== onAppear ${this.scroller.currentOffset().yOffset}`)
  //   })
  //   .onAreaChange((oldValue: Area, newValue: Area)=>{
  //     KLogger.debug(`=== onAreaChange ${this.scroller.currentOffset().yOffset}`)
  //     KLogger.debug(`=== onAreaChange ${JSON.stringify(oldValue)}`)
  //     KLogger.debug(`=== onAreaChange ${JSON.stringify(newValue)}`)
  //   })
  //   .onTouch((event)=>{
  //     KLogger.debug(`=== onTouch ${this.scroller.currentOffset().yOffset}`)
  //   })
  //   .width('100%')
  //   .height('100%')
  // }

  // build() {
  //   Column() {
  //     PullToRefresh({
  //       // 必传项，列表组件所绑定的数据
  //       data: $data,
  //       // 必传项，需绑定传入主体布局内的列表或宫格组件
  //       scroller: this.scroller,
  //       // 必传项，自定义主体布局，内部有列表或宫格组件
  //       customList: () => {
  //         // 一个用@Builder修饰过的UI方法
  //         this.getListView();
  //       },
  //       // 可选项，下拉刷新回调
  //       onRefresh: () => {
  //         return new Promise<string>((resolve, reject) => {
  //           // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
  //           setTimeout(() => {
  //             resolve('刷新成功');
  //             // this.data = this.creatTempData();
  //           }, 3000);
  //         });
  //       },
  //       // 可选项，上拉加载更多回调
  //       onLoadMore: () => {
  //         return new Promise<string>((resolve, reject) => {
  //           // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
  //           setTimeout(() => {
  //
  //             let tempDatas:MyDataSource<LazyProductModel> = new MyDataSource()
  //             let ranmStr = YWConstants.RandomColor()
  //             for (let i = 0; i <= 20; i++) {
  //               this.data.pushData({title:`title ${i} _ ${ranmStr}`,sub_title:'desc'})
  //               this.listData.push({title:`title ${i} _ ${ranmStr}`,sub_title:'desc'})
  //
  //             }
  //
  //             resolve('');
  //
  //
  //           }, 2000);
  //         });
  //       },
  //       customLoad: null,
  //       customRefresh: null,
  //
  //     })
  //   }
  //   .width('100%')
  //   .height('100%')
  // }
}
