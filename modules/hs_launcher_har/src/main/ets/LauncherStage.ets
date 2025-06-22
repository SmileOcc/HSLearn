import { AbilityConstant, AbilityStage } from "@kit.AbilityKit";
// import { kyStoreManger, PreferencesUtil, YWAppEvent, YWDeviceUtils } from "@learn/common_har";
// import { distributedKVStore } from "@kit.ArkData";
// import { hsLog } from '@learn/logger_har';
import { ywManagerTask } from "@learn/manager_task_har";
import {
  AccountUserTask,
  AppExceptionTask,
  AppLifeCycleTask,
  AppLinkTask,
  AppNetworkTask,
  NavigationRouteTask
} from "@learn/launcher_task_har";
import { AppConfig } from "@learn/app_config_har";
import { CarTask } from "@learn/car_har";
import { MineTask } from "@learn/mine_har";
import { HotelTask } from "@learn/hotel_har";
import { AddressTask } from "@learn/address_har";

/*
 * @Desc: 应用入口，初始化一些库和SDK，在module.json5配置路径。
 */
const TAG = 'LauncherStage'

export class LauncherStage extends AbilityStage {
  onCreate(): void {

    //初始化环境配置
    AppConfig.getInstance().init(this.context)
    //let context = getContext()
    //context.getApplicationContext() //不能直接传入这个，取获取，不然有问题
    ywManagerTask.init({
      stageTask: (context) => [
        () => new AppExceptionTask(context),
        () => new AppLifeCycleTask(context),
        () => new AppLinkTask(),
        () => new NavigationRouteTask(),
        () => new CarTask(),
        () => new MineTask(),
        () => new HotelTask(),
        () => new AddressTask(),
        () => new AppNetworkTask(),
        () => new AccountUserTask(context)
      ],
      abilityTask: (context) => []
    })

  }
}