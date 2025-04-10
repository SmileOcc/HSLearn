import { UIAbility } from "@kit.AbilityKit"
import { window } from "@kit.ArkUI"
import { AppContextLifecycleImp } from "./core/AppContextLifecycleImp"




export interface ILifecycleObserver<T> {
  addObserver(observer: T):void
  removeObserver(observer: T):void
}

export interface IAppAbilityObservers extends ILifecycleObserver<IAbilityLifecycleObserver> {

}

export interface IAppLifecycleObservers extends ILifecycleObserver<IAppLifecycleStateChangeObserver> {

  getAbilityObserver?(): IAppAbilityObservers | undefined
}


export interface IAbilityLifecycleObserver {

  // 当Ability创建时触发
  onAbilityCreate?(ability: UIAbility): void

  // 当WindowStage创建时触发
  onWindowStageCreate?(ability: UIAbility, windowStage: window.WindowStage): void

  // 当页面获取到焦点时触发
  onWindowStageActive?(ability: UIAbility, windowStage: window.WindowStage): void

  // 当WindowStage失焦时触发
  onWindowStageInactive?(ability: UIAbility, windowStage: window.WindowStage): void

  // 当WindowStage销毁时触发
  onWindowStageDestroy?(ability: UIAbility, windowStage: window.WindowStage): void

  // 当Ability销毁时触发
  onAbilityDestroy?(ability: UIAbility): void


  // 当Ability进入前台时触发
  onAbilityForeground?(ability: UIAbility): void


  // 当Ability进入后台时触发
  onAbilityBackground?(ability: UIAbility): void

  // 当Ability从暂停状态恢复时触发
  onAbilityContinue?(ability: UIAbility): void

}

export interface IAppLifecycleStateChangeObserver {

  // 当应用程序进入前台时触发
  onApplicationForeground?(): void

  // 当应用程序进入后台时触发
  onApplicationBackground?(): void
}

export interface IAppContext {
  appInfo(): IAppInfo
}

export interface IAppInfo {
  getAppName():string
  getVersion():string
  getAppID():number
  getBoundId():string
}
