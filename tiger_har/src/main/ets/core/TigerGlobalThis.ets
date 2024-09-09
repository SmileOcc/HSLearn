import { common } from '@kit.AbilityKit';
import { ITigerAppContext } from './ITigerAppContext';
import { TigerAppContext } from './TigerAppContext';
import dataPreferences from '@ohos.data.preferences';
import { TigerRouteUtils } from '../route/TigerRouteUtils';

export class TigerGlobalThis {

  private constructor() {}

  private static instance: TigerGlobalThis

  private _appContext: ITigerAppContext = new TigerAppContext()

  // 缓存context
  private _uiContexts = new Map<string, common.UIAbilityContext>();
  // 缓存属性值
  private _attribute = new Map<string, string>();
  // 缓存首选项
  private _preferences = new Map<string, Promise<dataPreferences.Preferences>>();

  // 启动数据
  private _launchStoreData = new Map<string,object>()


  static saveLaunchData(key:string,data:object|undefined) {
    if (key && data) {
      let global = TigerGlobalThis.getInstance()
      global._launchStoreData.set(key,data)
    }

  }

  static readLaunchData(key:string):object | undefined {
    let global = TigerGlobalThis.getInstance()
    if (global._launchStoreData.has(key)) {
      return global._launchStoreData.get(key)
    }
    return undefined
  }


  public static getInstance(): TigerGlobalThis {
    if (!TigerGlobalThis.instance) {
      TigerGlobalThis.instance = new TigerGlobalThis();
    }
    return TigerGlobalThis.instance;
  }

  setAppContext(appContext: ITigerAppContext):void {
    this._appContext = appContext
  }

  getAppContext():ITigerAppContext {
    return this._appContext
  }

  getContext(key: string): common.UIAbilityContext | undefined {
    return this._uiContexts.get(key);
  }

  setContext(key: string, value: common.UIAbilityContext): void {
    this._uiContexts.set(key, value);
  }

  getAttribute(key: string): string | undefined {
    return this._attribute.get(key);
  }

  setAttribute(key: string, value: string): void {
    this._attribute.set(key, value);
  }

  getPreferences(key: string): Promise<dataPreferences.Preferences> | undefined {
    return this._preferences.get(key);
  }

  setPreferences(key: string, value: Promise<dataPreferences.Preferences>): void {
    this._preferences.set(key, value);
  }

  // 其他需要传递的内容依此扩展

  clear() {
    TigerGlobalThis.instance._appContext = new TigerAppContext()
    TigerGlobalThis.instance._attribute.clear()
    TigerGlobalThis.instance._uiContexts.clear()
    TigerGlobalThis.instance._preferences.clear()
  }

}