import { BaseEntryAbility } from '@learn/base_har'
import { AbilityConstant, Want } from '@kit.AbilityKit'
import { window } from '@kit.ArkUI'
import { TigerRouteUtils } from '@learn/tiger_har/Index'
import { CatRouteUtils } from '@learn/cat_har'
import { initWindowSetting } from '@learn/common_har/Index'
import { AuthPromise } from './components/auth/YWAuthPage'
import { YWAuthManager } from './components/auth/YWAuthManager'
import { LaunchTask } from './LaunchTask'
import { ywManagerTask } from '@learn/manager_task_har/src/main/ets/core/YWMangaerTask'

const ROOT_PAGE = "root/RootPage"

const AUTH_ALERT_PAGE = "auth/YWAuthAlertPage"

export abstract class MainAbility extends BaseEntryAbility {

  onWindowStageCreate(windowStage: window.WindowStage): void {
    super.onWindowStageCreate(windowStage)
  }

  async loadContent(windowStage: window.WindowStage) {
    //注册与初始化
    initWindowSetting(windowStage)

    let promise = await YWAuthManager.checkUserPrivacy(this.context)

    if (promise) {
      const abilityTask = ywManagerTask.launchTask?.abilityTask(this.context)
      if (abilityTask) {
        // ywManagerTask.handTask(this.context, abilityTask)
        ywManagerTask.handTask(abilityTask)
      }
    }

    windowStage.loadContent(this.initRootPage(), this.localStorage).then((value)=>{
      //注册其他har app
      TigerRouteUtils.registerTigerApp()
      CatRouteUtils.registerCatApp()

      return this.startLaunchTask()

    }).then(()=>{
      this.isAuth(windowStage)
    })
  }

  async startLaunchTask():Promise<void> {
    return super.taskEndFinish()
  }

  //用户首次授权
  async isAuth(windowStage: window.WindowStage){

    let promise = await YWAuthManager.checkUserPrivacy(this.context)
    if (!promise) {
      AuthPromise.then(()=>{
        this.mainRootPage(windowStage)
      })
      //去授权页
      this.goAuthPage(windowStage)
    } else {

      this.mainRootPage(windowStage)
    }
  }

  mainRootPage(windowStage: window.WindowStage) {
    windowStage.loadContent(ROOT_PAGE,this.localStorage, (err) => {
      if (err.code) {
        return;
      }
    });
  }

  goAuthPage(windowStage: window.WindowStage) {
    windowStage.loadContent(AUTH_ALERT_PAGE)
  }

}