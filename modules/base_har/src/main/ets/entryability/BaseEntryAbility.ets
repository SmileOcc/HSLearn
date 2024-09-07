import {
  abilityAccessCtrl,
  AbilityConstant,
  bundleManager,
  Context,
  Permissions,
  UIAbility,
  Want
} from '@kit.AbilityKit';

import { hilog } from '@kit.PerformanceAnalysisKit';
import { display, window } from '@kit.ArkUI';
import { BaseAbility } from './BaseAbility';


export abstract  class BaseEntryAbility extends BaseAbility {

  isFinshTask = false

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onCreate(want, launchParam)

    //测试请求完成任务
    setTimeout(() => {

      console.debug("======aaaaa 111")

      this.isFinshTask = true

    }, 4000)
  }




  taskEndFinish(): Promise<void> {
    return  this.waitTaskRequest()
  }


  async waitTaskRequest():Promise<void> {
    return new Promise<void>((resolve) => {
      if (this.isFinshTask) {
        console.debug("======bbbbb 111")

        resolve()
      } else {
        setTimeout(() => this.waitTaskRequest().then(resolve), 100);
      }
    });
  }


  initRootPage() {
    return this.flashPage()
  }

  abstract flashPage(): string

}

