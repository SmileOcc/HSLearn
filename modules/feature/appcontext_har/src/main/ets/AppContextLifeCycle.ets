import { AppContextLifecycleImp } from "./core/AppContextLifecycleImp"
import {
  IAbilityLifecycleObserver,
  IAppAbilityObservers, IAppLifecycleObservers, IAppLifecycleStateChangeObserver } from "./service"

export class AppContextLifeCycle implements IAppLifecycleObservers {

  private context?:Context
  private lifecycleProxy?: AppContextLifecycleImp

  init(context:Context) {
    this.context = context
    this.lifecycleProxy = new AppContextLifecycleImp(context)
  }

  isOnForeground():boolean {
    return this.lifecycleProxy?.isOnForeground() ?? false
  }

  getAbilityObserver(): IAppAbilityObservers | undefined {
    return this.lifecycleProxy?.getAbilityObserver?.()
  }

  addObserver(observer: IAppLifecycleStateChangeObserver): void {
    this.lifecycleProxy?.addObserver(observer)
  }

  removeObserver(observer: IAppLifecycleStateChangeObserver): void {
    this.lifecycleProxy?.removeObserver(observer)
  }

  addAbilityObserver(observer: IAbilityLifecycleObserver) {
    this.lifecycleProxy?.addAbilityObservers(observer)
  }

  removeAbilityObserver(observer: IAbilityLifecycleObserver) {
    this.lifecycleProxy?.removeAbilityObservers(observer)
  }

}

export const appContextLifeInstance = new AppContextLifeCycle()