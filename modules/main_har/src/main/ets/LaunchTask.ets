import { IBaseTask } from "@learn/base_har";
import { YWLocalNavType, YWNavPath, ywNavRouter } from "@learn/nav_router_har";
// import { SettingRootBuilder } from "@learn/setting_har";

export class LaunchTask implements IBaseTask {
  run(): Promise<void> {

    // this.registerRootNav()
    // this.registerMainNav()
    // this.registerMainTabNav()
    // ywNavRouter.boundRouteName(YWLocalNavType.NAV_ROOT,
    // [{name:YWNavPath.NAV_PATH_ROOT_SETTING:}])


    // ywNavRouter.boundRouteName(YWLocalNavType.NAV_MAIN_TAB,
    // [{name:YWNavPath.NAV_PATH_SETTING,builder:SettingRootBuilder}])

    return Promise.resolve()
  }

  // private registerRootNav() {
  //   ywNavRouter.boundRouteName(YWLocalNavType.NAV_ROOT,[
  //     {name:YWNavPath.NAV_PATH_MAIN_NAV,builder:SettingRootBuilder}
  //   ])
  //
  //
  // }
  //
  // private registerMainNav() {
  //   ywNavRouter.boundRouteName(YWLocalNavType.NAV_MAIN_NAV,[
  //     {name:YWNavPath.NAV_PATH_MAIN_TAB_NAV ,builder:SettingRootBuilder}
  //   ])
  // }
  //
  // private registerMainTabNav() {
  //
  //   ywNavRouter.boundRouteName(YWLocalNavType.NAV_MAIN_TAB,[
  //     {name:YWNavPath.NAV_PATH_MAIN_TAB_NAV ,builder:SettingRootBuilder}
  //
  //   ])
  // }

}