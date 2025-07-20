import { Ability, common, Context, UIAbility } from "@kit.AbilityKit";
import { AppLifecycleManager } from "./AppLifecycleManager";
import { LightWeightMap, LightWeightSet } from "@kit.ArkTS";
import { IAbilityLifecycleObserver, IAppAbilityObservers, IAppLifecycleObservers,
  IAppLifecycleStateChangeObserver } from "../service";
import window from "@ohos.window";
import { hsLog } from "@learn/logger_har";
import { hsNotificationManager } from "@learn/notification_har";

const TAG = "AppContextLifecycleImp"
export class AppContextLifecycleImp implements IAppLifecycleObservers, IAbilityLifecycleObserver {

  private lifecycleManager: IAppAbilityObservers
  private callObservers:LightWeightSet<IAppLifecycleStateChangeObserver> = new LightWeightSet()
  private abilityContextStates:LightWeightMap<Context,IStateChange> = new LightWeightMap()
  private modelState: LifecycleState = LifecycleState.onForeground

  constructor(context: Context) {
    this.lifecycleManager = new AppLifecycleManager(context, this)
  }

  onAbilityCreate(ability: UIAbility): void {
    if (!this.abilityContextStates.hasKey(ability.context)) {
      this.abilityContextStates.set(ability.context, { onForeground: false })
    }
  }

  onWindowStageCreate(ability: UIAbility, windowStage: window.WindowStage): void {

  }

  onWindowStageActive(ability: UIAbility, windowStage: window.WindowStage): void {
  }

  onWindowStageInactive(ability: UIAbility, windowStage: window.WindowStage): void {
  }

  onWindowStageDestroy(ability: UIAbility, windowStage: window.WindowStage): void {
  }

  onAbilityDestroy(ability: UIAbility): void {
    if (this.abilityContextStates.hasKey(ability.context)) {
      this.abilityContextStates.remove(ability.context)
    }
  }

  onAbilityForeground(ability: UIAbility): void {
    this.abilityContextStates.set(ability.context, {onForeground: true})
    let abilityArray:Array<IStateChange> = Array.from(this.abilityContextStates.values())
    let foregroundAbility:Array<IStateChange> = abilityArray.filter((value)=>{
      return value.onForeground == true
    })
    if (foregroundAbility.length == 1) {
      this.modelState = LifecycleState.onForeground
      this.onNotifyForeground()
      //可以上报一个埋点
    }
  }

  onAbilityBackground(ability: UIAbility): void {
    this.abilityContextStates.set(ability.context, {onForeground: false})
    let abilityArray:Array<IStateChange> = Array.from(this.abilityContextStates.values())
    let backgroundAbility:Array<IStateChange> = abilityArray.filter((value)=>{
      return value.onForeground == false
    })
    if (abilityArray.length == backgroundAbility.length) {
      this.modelState = LifecycleState.onBackground
      this.onNotifyBackground()
      //可以上报一个埋点
    }

    hsNotificationManager.getNotifyCount()

  }

  onAbilityContinue(ability: UIAbility): void {
  }

  addObserver(observer: IAppLifecycleStateChangeObserver): void {
    if (!this.callObservers.has(observer)) {
      this.callObservers.add(observer)
    }
  }


  removeObserver(observer: IAppLifecycleStateChangeObserver): void {
    if (this.callObservers.has(observer)) {
      this.callObservers.remove(observer)
    }
  }


  isOnForeground(): boolean {
    return this.modelState == LifecycleState.onForeground
  }

  /////

  getAbilityObserver?(): IAppAbilityObservers {
    return this.lifecycleManager
  }



  addAbilityObservers(observer: IAbilityLifecycleObserver) {
    this.lifecycleManager.addObserver(observer)
  }

  removeAbilityObservers(observer: IAbilityLifecycleObserver) {
    this.lifecycleManager.removeObserver(observer)

  }

  onNotifyForeground() {
    hsLog.i(TAG,"onNotifyForeground")

    this.callObservers?.forEach((value)=>{
      value?.onApplicationForeground?.()
    })
  }

  onNotifyBackground() {
    hsLog.i(TAG,"onNotifyBackground")
    this.callObservers?.forEach((value)=>{
      value?.onApplicationBackground?.()
    })
  }


  // 当应用程序进入前台时触发
  onApplicationForeground(): void {
  }

  // 当应用程序进入后台时触发
  onApplicationBackground(): void {
  }

}

export interface IStateChange {

  onForeground: boolean
}

export enum LifecycleState {
  onForeground,
  onBackground
}