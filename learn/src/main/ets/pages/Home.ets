import router from '@ohos.router'
import curves from '@ohos.curves'
import { BreakpointSystem, BreakPointType } from '../../../../../modules/common_har/src/main/ets/common/BreakPointSystem'
import { Records } from './components/DietRecord'
import { FoodInfo, Category } from '../model/DataModels'
import { getFoods, getFoodCategories, getSortedFoodData } from '../model/DataUtil'
import { Account } from './Account'


interface FoodId {
  foodId: FoodInfo;
}


@Entry
@Component
struct Home {
  @State currentTabIndex: number = 0
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm'
  private breakpointSystem: BreakpointSystem = new BreakpointSystem()

  @Builder
  bottomBarItemBuilder(name: Resource, icon: Resource, index: number) {
    Flex({
      direction: new BreakPointType({
        sm: FlexDirection.Column,
        md: FlexDirection.Row,
        lg: FlexDirection.Column
      }).getValue(this.currentBreakpoint),
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      Image(icon)
        .height(24)
        .width(24)
        .fillColor(this.getTabBarColor(index))
      Text(name)
        .margin(new BreakPointType<Padding>({
          sm: { top: 4 },
          md: { left: 8 },
          lg: { top: 4 }
        }).getValue(this.currentBreakpoint) as Padding)
        .fontSize(11)
        .fontColor(this.getTabBarColor(index))
    }
  }

  onPageShow() {
    //页面每次显示时触发一次，包括路由过程、应用进入前台等场景
    console.log("=====onPageShow 页面每次显示时触发一次，包括路由过程、应用进入前台等场景")
  }

  onPageHide() {
    //页面每次隐藏时触发一次，包括路由过程、应用进入后台等场景。
    console.log("====onPageHide 页面每次隐藏时触发一次，包括路由过程、应用进入后台等场景。")
  }

  onBackPress() {
    console.log("===onBackPress 当用户点击返回按钮时触发")
  }

  aboutToAppear() {
    this.breakpointSystem.register()
    console.log("====aboutToAppear 组件即将出现时回调该接口，具体时机为在创建自定义组件的新实例后，在执行其build()函数之前执行")

  }

  aboutToDisappear() {
    this.breakpointSystem.unregister()
    console.log("===aboutToDisappear aboutToDisappear函数在自定义组件析构销毁之前执行。不允许在aboutToDisappear函数中改变状态变量，特别是@Link变量的修改可能会导致应用程序行为不稳定")

  }

  build() {
    Tabs({
      barPosition: new BreakPointType({
        sm: BarPosition.End,
        md: BarPosition.End,
        lg: BarPosition.Start
      }).getValue(this.currentBreakpoint)
    }) {
      TabContent() {
        FoodsDisplay()
      }.tabBar(this.bottomBarItemBuilder($r("app.string.tab_bar_home"), $r("app.media.ic_bottom_home"), 0))

      TabContent() {
        Records()
      }.tabBar(this.bottomBarItemBuilder($r("app.string.tab_bar_record"), $r("app.media.ic_bottom_record"), 1))

      TabContent() {
        Account()
      }.tabBar(this.bottomBarItemBuilder($r("app.string.tab_bar_account"), $r("app.media.ic_bottom_record"), 1))
    }
    .vertical(new BreakPointType({ sm: false, md: false, lg: true }).getValue(this.currentBreakpoint) as boolean)
    .barWidth(new BreakPointType({ sm: '100%', md: '100%', lg: '56vp' }).getValue(this.currentBreakpoint) as string)
    .barHeight(new BreakPointType({ sm: '56vp', md: '56vp', lg: '60%' }).getValue(this.currentBreakpoint) as string)
    .animationDuration(0)
    .onChange((index) => {
      this.currentTabIndex = index
    })
  }

  private getTabBarColor(index: number) {
    return this.currentTabIndex == index ? $r('app.color.tab_bar_select_color') : $r('app.color.tab_bar_normal_color')
  }
}


@Component
struct FoodsDisplay {
  @State isCategoryMode: boolean = true

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      if (this.isCategoryMode) {
        CategoryModeFoods()
      } else {
        ListModeFoods()
      }
      Row() {
        Image($r("app.media.ic_switch"))
          .height(24)
          .width(24)
          .margin({ left: 24, right: 24 })
      }
      .height(56)
      .backgroundColor(this.isCategoryMode ? Color.White : '#F1F3F5')
      .onClick(() => {
        this.isCategoryMode = !this.isCategoryMode
      })
    }
  }
}

@Component
struct CategoryModeFoods {
  @State currentTabIndex: number = 0
  private foodItems: FoodInfo[] = getFoods()
  private foodCategories: Category[] = getFoodCategories()

  @Builder
  tabBarItemBuilder(value: Resource, index: number) {
    Text(value)
      .fontColor(this.currentTabIndex === index ? 'rgba(0,0,0,0.9)' : 'rgba(0,0,0,0.6)')
      .fontSize(this.currentTabIndex === index ? 24 : 18)
      .margin({ top: 2 })
      .height(56)
  }

  build() {
    Tabs() {
      TabContent() {
        FoodGrid({ foodItems: this.foodItems })
      }.tabBar(this.tabBarItemBuilder($r('app.string.category_all'), 0))

      ForEach(this.foodCategories, (foodCategory: Category, index?: number) => {
        TabContent() {
          FoodGrid({ foodItems: this.foodItems.filter(item => (item.categoryId === foodCategory.id)) })
        }.tabBar(this.tabBarItemBuilder(foodCategory.name!,
          index! + 1))
      })
    }
    .animationDuration(0)
    .barWidth('80%')
    .onChange((index) => {
      this.currentTabIndex = index
    })
  }
}



@Component
struct FoodGrid {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm'
  private foodItems?: FoodInfo[]

  build() {
    Grid() {
      ForEach(this.foodItems!, (item: FoodInfo) => {
        GridItem() {
          FoodGridItem({ foodItem: item })
        }
      })
    }
    .columnsTemplate(new BreakPointType({
      sm: '1fr 1fr',
      md: '1fr 1fr 1fr',
      lg: '1fr 1fr 1fr 1fr'
    }).getValue(this.currentBreakpoint) as string)
    .columnsGap(8)
    .rowsGap(8)
    .padding({ left: 16, right: 16 })
  }
}

@Component
struct FoodGridItem {
  private foodItem?: FoodInfo

  build() {
    Column() {
      Image(this.foodItem!.image!)
        .objectFit(ImageFit.Contain)
        .backgroundColor('#f1f3f5')
        .width('100%')
        .height(152)
        .sharedTransition(this.foodItem!.letter, {
          duration: 400,
          curve: curves.cubicBezierCurve(0.2, 0.2, 0.1, 1.0),
          delay: 100
        })
      Row() {
        Text(this.foodItem?.name)
          .fontSize(14)
        Blank()
        Text($r('app.string.calorie_with_kcal_unit', this.foodItem?.calories.toString()))
          .fontSize(14)
          .fontColor(0x99000000)
      }
      .padding({ left: 12, right: 12 })
      .width('100%')
      .height(32)
      .backgroundColor('#E5E5E5')
    }
    .height(184)
    .clip(new Rect({ width: '100%', height: '100%', radius: 12 }))
    .onClick(() => {
      router.pushUrl({ url: 'pages/FoodDetail', params: { foodId: this.foodItem } })
    })
  }
}

@Component
struct ListModeFoods {
  private foodItems: Array<FoodInfo | string> = getSortedFoodData()

  build() {
    Column() {
      Text($r("app.string.title_food_list"))
        .width('100%')
        .height(56)
        .padding({ left: 20 })
        .backgroundColor('#FF1f3f5')
        .fontSize(20)

      List() {
        ForEach(this.foodItems, (item: FoodInfo) => {
          ListItem() {
            if (item.letter !== undefined) {
              FoodListItem({ foodItem: item })
            } else {
              if (typeof (item) === 'string') {
                Text(item)
                  .fontSize(14)
                  .height(48)
                  .margin({ left: 24 })
                  .width('100%')
              }
            }
          }
        })
      }
      .layoutWeight(1)
    }
  }
}

@Component
struct FoodListItem {
  private foodItem?: FoodInfo

  build() {
    Navigator({ target: 'pages/FoodDetail' }) {
      Row() {
        Image(this.foodItem!.image!)
          .objectFit(ImageFit.Contain)
          .autoResize(false)
          .height(40)
          .width(40)
          .backgroundColor('#FFf1f3f5')
          .margin({ right: 16 })
          .borderRadius(6)
          .sharedTransition(this.foodItem!.letter, {
            duration: 400,
            // curve: curves.cubicBezier(0.2, 0.2, 0.1, 1.0),
            curve: curves.cubicBezierCurve(0.2, 0.2, 0.1, 1.0),
            delay: 100
          })
        Text(this.foodItem?.name)
          .fontSize(14)
        Blank()
        Text($r('app.string.calorie_with_kcal_unit', this.foodItem?.calories.toString()))
          .fontSize(14)
      }
      .height(64)
      .width('100%')
    }
    .params({ foodId: this.foodItem } as FoodId)
    .margin({ right: 24, left: 32 })
  }
}