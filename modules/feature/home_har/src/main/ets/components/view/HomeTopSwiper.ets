import { YWConstants } from "@learn/constants_har";
import { ywNavRouter } from "@learn/nav_router_har";
import { HomeAdvModel } from "../model/HomeAdvModel";

@Component
export struct HomeTopSwiper {
  @State currentIndex: number = 0;
  @State swiperData: HomeAdvModel[] = [];
  @Consume('swiperDisplayCount') swiperDisplayCount: number;
  // 从AppStorage中获取设别类别，判断是否为折叠屏
  @State isFoldable: boolean | undefined = AppStorage.get(YWConstants.kIsFoldable);
  @StorageProp(YWConstants.kStorageWidth) screenWidth: number = 0; //屏幕宽度（单位：vp）
  @StorageProp(YWConstants.kStorageHeight) screenHeight: number = 0; //屏幕宽度（单位：vp）

  aboutToAppear(): void {
    //测试数据
    //测试数据
    let names:string[] = ["热点","唱歌","今天的天气怎么样","六一儿童节","开始奔跑","周末运动","登山"]
    for (let i=0; i<names.length-1; i++) {
      let advModel: HomeAdvModel = new HomeAdvModel()
      advModel.id = `top_swiper_id_${i}`
      advModel.title = names[i]
      advModel.bgColor = YWConstants.RandomColor()
      this.swiperData.push(advModel)
    }
  }

  build() {
    Swiper() {
      ForEach(this.swiperData, (dataItem: HomeAdvModel) => {
        Stack() {
          Image(dataItem.imageUrl)
            .width(this.isFoldable ? this.screenWidth / 2 : $r('app.integer.swiper_width'))
            .height($r('app.integer.swiper_height'))
            .objectFit(ImageFit.Auto)
            .borderRadius($r('app.integer.swiper_border_radius'))
            .onClick(() => {
              // 判断当前路由栈最后一个路由是否与当前跳转路由相同,相同则不跳转
              // if (ywNavRouter.navPathStack.getIndexByName(dataItem.appUri)[0] === 0) {
              //   return;
              // }
              // 点击轮播图Item时，根据点击的模块信息，将页面放入路由栈
              if (dataItem.linkUrl) {
                ywNavRouter.openRoute(this.getUniqueId())
                  .onTargetUrl(dataItem.linkUrl)
                  .onRouteMode()
                  .go()
              }

            })
            .padding(this.isFoldable ? {
              left: $r('app.integer.swiper_image_foldable_padding1'),
              right: $r('app.integer.swiper_image_foldable_padding1')
            } :
              {
                left: $r('app.integer.swiper_image_foldable_padding2'),
                right: $r('app.integer.swiper_image_foldable_padding2')
              })

          Stack() {
            Column()
              .width('100%')
              .height(24)
              .backgroundColor(Color.Black)
              .opacity(0.6)
              .borderRadius({
                bottomLeft: $r('app.integer.swiper_border_radius'),
                bottomRight: $r('app.integer.swiper_border_radius')
              })
            Text(dataItem?.title)
              .width('100%')
              .fontSize(14)
              .fontColor(Color.White)
              .padding({
                left: $r('app.integer.swipercomponent_main_page_padding5')
              })
              .id('case_title')
          }
        }
        .backgroundColor(dataItem.bgColor)
        .alignContent(Alignment.Bottom)
      })
    }
    .id("MainSwiper")
    .autoPlay(true)
    .displayCount(this.swiperDisplayCount)
    .margin({ top: $r('app.integer.swiper_margin_top'), bottom: $r('app.integer.swiper_margin_bottom') })
    .width(this.swiperDisplayCount === 2 ? this.screenWidth : $r('app.integer.swiper_width'))
  }
}