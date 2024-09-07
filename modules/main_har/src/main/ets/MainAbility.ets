import { BaseEntryAbility } from '@learn/base_har'
import { AbilityConstant, Want } from '@kit.AbilityKit'
import { window } from '@kit.ArkUI'
import { TigerRouteUtils } from '@learn/tiger_har/Index'
import { initWindowSetting } from '@learn/common_har/Index'

const ROOT_PAGE = "pages/Index"

export abstract class MainAbility extends BaseEntryAbility {

  onWindowStageCreate(windowStage: window.WindowStage): void {
    super.onWindowStageCreate(windowStage)
  }

  loadContent(windowStage: window.WindowStage): void {

    windowStage.loadContent(this.initRootPage(), this.localStorage).then((value)=>{
      //注册与初始化
      initWindowSetting(windowStage)
      TigerRouteUtils.registerTigerApp()

      return super.taskEndFinish()

    }).then(()=>{
      windowStage.loadContent(ROOT_PAGE,this.localStorage, (err) => {
        if (err.code) {
          return;
        }
      });
    })
  }

}