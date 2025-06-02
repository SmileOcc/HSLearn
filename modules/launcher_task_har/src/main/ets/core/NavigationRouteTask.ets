import { carListBuilder, goodsDetailBuilder, mainCarBuilder } from "@learn/car_har";
import { mainCategoryBuilder } from "@learn/category_har";
import { debugDemoBuilder } from "@learn/debug_demo_har";
import { mainHomeBuilder } from "@learn/home_har";
import { hotelBuilder } from "@learn/hotel_har";
import { TaskType } from "@learn/learn_task_har";
import { lionAppBuilder,
  lionMainBuilder,
  lionMainHomeBuilder, lionMainMeBuilder, lionMainNewsBuilder } from "@learn/lion_har";
import { learnMainBuilder, mainNavBuilder } from "@learn/main_har";
import { mainMineBuilder } from "@learn/mine_har";
import { YWLocalNavType, YWNavPath, ywNavRouter } from "@learn/nav_router_har";
import { learnSettingBuilder } from "@learn/setting_har";
import { commonTabContentBuilder } from "@learn/tab_nav_common_har";
import { commonTabNavBuilder } from "@learn/tab_nav_common_har";
import { maintTabContentViewBuilder } from "@learn/tab_nav_har";
import { ILaunchTask } from "./ILaunchTask";

export class NavigationRouteTask implements ILaunchTask {
  priority(): number {
    return 0
  }

  type(): TaskType {
    return TaskType.main
  }

  name(): string {
    return ""
  }
  run(): Promise<void> {
    //TODO 注册路由
    this.registerRootNav()

    this.registerRootMainNav()

    this.registerRootMainTabNav()

    this.registerCommonTabNav()

    this.registerCatNav()

    this.registerMiniApp()

    this.registerLionNav()

    this.registerSettingNav()

    this.registerDemoNav()

    this.registerMainMineNav()

    return Promise.resolve()
  }

  private registerRootNav() {

    ywNavRouter.boundRouteName(YWLocalNavType.NAV_ROOT,[
      {name:YWNavPath.root_main_nav,builder:wrapBuilder(mainNavBuilder)},

    {name:YWNavPath.root_setting,builder:wrapBuilder(learnSettingBuilder)},

    // {name:YWNavPath.root_lion_nav,builder:wrapBuilder(lionAppBuilder)}

    ])
  }

  private registerSettingNav() {

    ywNavRouter.boundRouteName(YWLocalNavType.NAV_ROOT_LEARN_SETTING,[
      {name:YWNavPath.root_demo_tab_nav,builder:wrapBuilder(debugDemoBuilder)},

    ])
  }

  private registerRootMainNav() {

    ywNavRouter.boundRouteName(YWLocalNavType.NAV_ROOT_MAIN_NAV,[
      {name:YWNavPath.main_tab_nav,builder:wrapBuilder(learnMainBuilder)},

    ])


  }

  private registerRootMainTabNav() {

    ywNavRouter.boundRouteName(YWLocalNavType.NAV_ROOT_MAIN_TAB,[

      {name:YWNavPath.main_tab_home,builder:wrapBuilder(maintTabContentViewBuilder)},
      {name:YWNavPath.main_tab_category,builder:wrapBuilder(maintTabContentViewBuilder)},
      {name:YWNavPath.main_tab_car,builder:wrapBuilder(maintTabContentViewBuilder)},
      {name:YWNavPath.main_tab_mine,builder:wrapBuilder(maintTabContentViewBuilder)},

      // {name:YWNavPath.vc_car,builder:wrapBuilder(mainCarBuilder)},

      {name:YWNavPath.root_lion_nav,builder:wrapBuilder(lionAppBuilder)},
      {name:YWNavPath.root_hotel_nav,builder:wrapBuilder(hotelBuilder)}


    ])
  }

  private registerCommonTabNav() {

    // ywNavRouter.boundRouteName(YWLocalNavType.NAV_COMMON_TAB,[
    //   {name:YWNavPath.lion_tab_home,builder:wrapBuilder(commonTabContentBuilder)},
    //   {name:YWNavPath.lion_tab_news,builder:wrapBuilder(commonTabContentBuilder)},
    //   {name:YWNavPath.lion_tab_me,builder:wrapBuilder(commonTabContentBuilder)},
    //   // {name:YWNavPath.main_tab_mine,builder:wrapBuilder(maintTabContentViewBuilder)},
    // ])
  }

  private registerLionNav() {


    ywNavRouter.boundRouteName(YWLocalNavType.NAV_LION_MAIN_NAV,[
      {name:YWNavPath.root_lion_tab_nav,builder:wrapBuilder(lionMainBuilder)},

    ])

    // ywNavRouter.registerCustomRoute(YWLocalNavType.NAV_LION_MAIN_TAB_NAV,YWLocalNavType.NAV_LION_MAIN_NAV,YWNavPath.root_lion_tab_nav, new Map())

    ywNavRouter.boundRouteName(YWLocalNavType.NAV_LION_MAIN_TAB_NAV, [
      {name:YWNavPath.lion_tab_home,builder:wrapBuilder(commonTabContentBuilder)},
      {name:YWNavPath.lion_tab_news,builder:wrapBuilder(commonTabContentBuilder)},
      {name:YWNavPath.lion_tab_me,builder:wrapBuilder(commonTabContentBuilder)},
    ])
  }

  private registerMainMineNav() {
    ywNavRouter.boundRouteName(YWLocalNavType.NAV_MAIN_MINE,[

      {name:YWNavPath.vc_car,builder:wrapBuilder(mainCarBuilder)},
    // {name:YWNavPath.vc_car,builder:wrapBuilder(carListBuilder)},

      {name:YWNavPath.vc_car_goods_detail,builder:wrapBuilder(goodsDetailBuilder)},

    ])
  }


  private registerDemoNav() {
    //内部自己独立路由管理
  }

  private registerCatNav() {

  }

  private registerMiniApp() {

  }


}