
import { AbilityConstant, AbilityStage } from "@kit.AbilityKit";
// import { kyStoreManger, PreferencesUtil, YWAppEvent, YWDeviceUtils } from "@learn/common_har";
// import { distributedKVStore } from "@kit.ArkData";
// import { hsLog } from '@learn/logger_har';
import { ywManagerTask } from "@learn/manager_task_har";
import { AppErrorExpectionTask, AppLifeCycleTask, AppLinkTask, NavigationRouteTask } from "@learn/launcher_task_har";

/*
 * @Desc: 应用入口，初始化一些库和SDK，在module.json5配置路径。
 */
const TAG = 'LearnStage'

export class LauncherStage extends AbilityStage {
  onCreate(): void {
    let context = getContext()
    ywManagerTask.init({stageTask:[
      () => new AppErrorExpectionTask(context),
      () => new AppLifeCycleTask(),
      () => new AppLinkTask(),
      () => new NavigationRouteTask()
    ],abilityTask:[

    ]})

  }
}