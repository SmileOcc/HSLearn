import { AbilityLifecycleCallback, ApplicationStateChangeCallback, common, UIAbility } from "@kit.AbilityKit";
import { window } from "@kit.ArkUI";
import { IAbilityLifecycleObserver, IAppAbilityObservers, IAppLifecycleObservers,
  IAppLifecycleStateChangeObserver } from "../service";
import { LightWeightSet } from "@kit.ArkTS";
import { hsLog } from "@learn/logger_har";

const TAG = "AppLifecycleManager"
export class AppLifecycleManager implements IAppAbilityObservers {

  context: Context
  lifecycleId: number = -1
  abilityCallObservers:LightWeightSet<IAbilityLifecycleObserver> = new LightWeightSet()

  constructor(context:Context, listener:IAbilityLifecycleObserver) {
    this.context = context
    // // 获取应用上下文
    this.abilityCallObservers.add(listener)
    const applicationContext = this.context.getApplicationContext();

    // const stateChangeCallback:AbilityLifecycleCallback = {
    //   onAbilityCreate: (ability: UIAbility): void => {
    //
    //   },
    //   onWindowStageCreate: (ability: UIAbility, windowStage: window.WindowStage): void => {
    //
    //   },
    //   onWindowStageActive: (ability: UIAbility, windowStage: window.WindowStage): void => {
    //
    //   },
    //   onWindowStageInactive: (ability: UIAbility, windowStage: window.WindowStage): void => {
    //
    //   },
    //   onWindowStageDestroy: (ability: UIAbility, windowStage: window.WindowStage): void => {
    //
    //   },
    //   onAbilityDestroy: (ability: UIAbility): void => {
    //
    //   },
    //   onAbilityForeground: (ability: UIAbility): void => {
    //
    //   },
    //   onAbilityBackground: (ability: UIAbility): void => {
    //
    //   },
    //   onAbilityContinue: (ability: UIAbility): void => {
    //
    //   }
    // }

    //1 生命周期监听 利用 applicationStateChange 监听前后台变化
    // 监听应用程序状态变化
    // 创建一个EntryApplicationStateChangeCallback实例来处理状态变化
    //applicationContext.on('applicationStateChange', new EntryApplicationStateChangeCallback(this));
    //

    //2 生命周期监听 利用 abilityLifecycle 监听应用生命周期
    // // 监听Ability Lifecycle事件
    // // 创建一个EntryAbilityLifecycleCallback实例，并获取监听ID
    this.lifecycleId = applicationContext.on('abilityLifecycle', new EntryAbilityLifecycleCallback(this));
  }

  addObserver(observer: IAbilityLifecycleObserver): void {
    if (!this.abilityCallObservers.has(observer)) {
      this.abilityCallObservers.add(observer)
    }
  }


  removeObserver(observer: IAbilityLifecycleObserver): void {
    if (this.abilityCallObservers.has(observer)) {
      this.abilityCallObservers.remove(observer)
    }
  }


  // 当Ability销毁时触发
  onDestroy(): void {
    // 获取应用上下文
    const applicationContext = this.context.getApplicationContext();

    // 注销应用程序状态变化的监听
    applicationContext.off('applicationStateChange');

    // 如果有Ability Lifecycle的监听ID，则注销监听
    if (this.lifecycleId !== -1) {
      applicationContext.off('abilityLifecycle', this.lifecycleId);
    }

    // 在这里可以执行清理资源和释放内存的操作
    // ...
  }


}

// 但是要特别注意：系统级弹窗（例如权限授权弹窗），
// 或者自定义 subwindow 的浮窗，
// 都会触发 onWindowStageInactive 周期，
// 因为此时主窗口失焦，除非自定义 subwindow 的浮窗是不可交互的蒙层。
// 所以监听前后台具体选用的周期，要特别谨慎

// EntryAbilityLifecycleCallback 类扩展自 AbilityLifecycleCallback，用于处理Ability的生命周期事件
export class EntryAbilityLifecycleCallback extends AbilityLifecycleCallback {

  private lifecycleManager:AppLifecycleManager
  constructor(manager:AppLifecycleManager) {
    super();
    this.lifecycleManager = manager
  }
  // 当Ability创建时触发
  onAbilityCreate(ability: UIAbility): void {
    // 在这里可以执行Ability创建后的初始化操作
    this.lifecycleManager.abilityCallObservers.forEach((value)=>{
      value?.onAbilityCreate?.(ability)
    })
  }

  // 当WindowStage创建时触发
  onWindowStageCreate(ability: UIAbility, windowStage: window.WindowStage): void {
    // 在这里可以执行WindowStage创建后的初始化操作
    this.lifecycleManager.abilityCallObservers.forEach((value)=>{
      value?.onWindowStageCreate?.(ability, windowStage)
    })
  }

  // 当页面获取到焦点时触发
  onWindowStageActive(ability: UIAbility, windowStage: window.WindowStage): void {
    // 在这里可以执行页面激活时的操作，如恢复状态、刷新数据等
    this.lifecycleManager.abilityCallObservers.forEach((value)=>{
      value?.onWindowStageActive?.(ability, windowStage)
    })
  }

  // 当WindowStage失焦时触发
  onWindowStageInactive(ability: UIAbility, windowStage: window.WindowStage): void {
    // 在这里可以执行页面失焦时的操作，如暂停动画、保存状态等
    this.lifecycleManager.abilityCallObservers.forEach((value)=>{
      value?.onWindowStageInactive?.(ability, windowStage)
    })
  }

  // 当WindowStage销毁时触发
  onWindowStageDestroy(ability: UIAbility, windowStage: window.WindowStage): void {
    // 在这里可以执行WindowStage销毁前的清理操作
    this.lifecycleManager.abilityCallObservers.forEach((value)=>{
      value?.onWindowStageDestroy?.(ability, windowStage)
    })
  }

  // 当Ability销毁时触发
  onAbilityDestroy(ability: UIAbility): void {
    // 在这里可以执行Ability销毁前的清理操作
    this.lifecycleManager.abilityCallObservers.forEach((value)=>{
      value?.onAbilityDestroy?.(ability)
    })
  }

  // 当Ability进入前台时触发
  onAbilityForeground(ability: UIAbility): void {
    hsLog.i(TAG,"onAbilityForeground")
    // 在这里可以执行Ability进入前台时的操作，如恢复暂停的动画等
    this.lifecycleManager.abilityCallObservers.forEach((value)=>{
      value?.onAbilityForeground?.(ability)
    })
  }

  // 当Ability进入后台时触发
  onAbilityBackground(ability: UIAbility): void {
    hsLog.i(TAG,"onAbilityBackground")

    // 在这里可以执行Ability进入后台时的操作，如暂停动画、保存状态等
    this.lifecycleManager.abilityCallObservers.forEach((value)=>{
      value?.onAbilityBackground?.(ability)
    })
  }

  // 当Ability从暂停状态恢复时触发
  onAbilityContinue(ability: UIAbility): void {
    // 在这里可以执行Ability恢复时的操作，如继续动画等
    this.lifecycleManager.abilityCallObservers.forEach((value)=>{
      value?.onAbilityContinue?.(ability)
    })
  }
}


// EntryApplicationStateChangeCallback 类扩展自 ApplicationStateChangeCallback，用于处理应用程序状态变化事件
export class EntryApplicationStateChangeCallback extends ApplicationStateChangeCallback {

  private lifecycleManager:AppLifecycleManager
  constructor(manager:AppLifecycleManager) {
    super();
    this.lifecycleManager = manager
  }

  // 当应用程序进入前台时触发
  onApplicationForeground(): void {
    // 在这里可以执行应用程序进入前台时的操作，如恢复网络请求等
    hsLog.i(TAG,"onApplicationForeground")
  }

  // 当应用程序进入后台时触发
  onApplicationBackground(): void {
    // 在这里可以执行应用程序进入后台时的操作，如暂停动画、停止网络请求等
    hsLog.i(TAG,"onApplicationBackground")
  }
}

