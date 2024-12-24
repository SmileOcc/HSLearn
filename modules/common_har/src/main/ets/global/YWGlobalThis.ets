/*
 * @Desc: 全局内存对象缓存工具类，比如：保存 Function 、Context等
 */
import { common } from '@kit.AbilityKit';
import dataPreferences from '@ohos.data.preferences';
import { hsLog } from '@learn/logger_har';
import { systemDateTime } from '@kit.BasicServicesKit';
import { preferences } from '@kit.ArkData';

const TAG = 'YWGlobalThis';

//首选项key

export enum ENU_PREFS {
  Global = "Global"

}

export enum ENU_CONTEXT {
  UI_Root = "UI_RootContext"
}

type PrefValueType = number | string | boolean | Array<number> | Array<string> | Array<boolean> | bigint;

const PREF_OBJ_KEY = 'Pref'

class YWGlobalThis {

  private constructor() {}

  private static instance: YWGlobalThis


  private kMainContextKey = "_mainContextKey"
  private kMainAbilityContextKey = "_mainAbilityContextKey"

  private lastClickTime: number = 0;

  private _objects = new Map<string, Object>();

  // 缓存context
  // private _uiContexts = new Map<string, common.UIAbilityContext>();
  private _uiContexts = new Map<string, Context | common.UIAbilityContext>();
  // 缓存属性值
  private _attribute = new Map<string, string>();
  // 缓存首选项
  private _preferences = new Map<string, Promise<dataPreferences.Preferences>>();

  public init(context: Context) {//这个传入的是ability的context

    //全局持有
    this.setContext(this.kMainContextKey, context);

    let preferences: Promise<dataPreferences.Preferences> = dataPreferences.getPreferences(context, ENU_PREFS.Global);
    // 缓存首选项Promise
    this.setPref(ENU_PREFS.Global, preferences);

    // let preferencesFunc: Function = (() => {
    //   let preferences: Promise<dataPreferences.Preferences> = dataPreferences.getPreferences(context, PrefKeys.kGlobal_Pref);
    //   return preferences;
    // });
    // globalThis.setObject(PREF_OBJ_KEY, preferencesFunc);
  }


  private getFunc() {
    const func = globalThis.getObject<Function>(PREF_OBJ_KEY)
    if (func === undefined) {
      throw Error('请先调用init()！')
    }
    return func;
  }


  public getMainContext():Context | undefined {
    let context: Context  = globalThis.getContext(this.kMainContextKey) as Context;
    return context
  }

  public getMainAbilityContext():common.UIAbilityContext | undefined {
    let context: common.UIAbilityContext = globalThis.getContext(this.kMainContextKey) as common.UIAbilityContext;
    return context
  }

  public setObject(key: string, objectClass: Object): void {
    this._objects.set(key, objectClass);
  }

  public getObject<T>(value: string): T {
    return this._objects.get(value) as T;
  }

  public getObjectDef<T>(key: string, defValue: T): T {
    if (!this._objects.has(key)) {
      return defValue;
    }
    return this._objects.get(key) as T;
  }


  public static getInstance(): YWGlobalThis {
    if (!YWGlobalThis.instance) {
      YWGlobalThis.instance = new YWGlobalThis();
    }
    return YWGlobalThis.instance;
  }

  // getContext(key: string): common.UIAbilityContext | undefined {
  getContext(key: string): Context | common.UIAbilityContext | undefined {
    return this._uiContexts.get(key);
  }

  // setContext(key: string, value: common.UIAbilityContext): void {
  setContext(key: string, value: Context | common.UIAbilityContext): void {
    this._uiContexts.set(key, value);
  }

  getAttribute(key: string): string | undefined {
    return this._attribute.get(key);
  }

  setAttribute(key: string, value: string): void {
    this._attribute.set(key, value);
  }

  //================== 首选项 =================//
  getPref(key: string): Promise<dataPreferences.Preferences> {
    return this._preferences.get(key) ?? this.defaultPref();
  }

  //设置首选项
  setPref(key: string, value: Promise<dataPreferences.Preferences>): void {
    this._preferences.set(key, value);
  }

  //获取指定首选项 -> 获取值 (默认全局首选项）
  // async getPrefValue(key: string, def: PrefValueType, prefKey?: string): Promise<PrefValueType> {
  //   return (await this.getPref(prefKey ?? PrefKeys.kGlobal_Pref)).get(key, def) as Promise<PrefValueType>;
  // }

  async getPrefValue<T>(key: string, def: T, prefKey?: string): Promise<T> {
    return (await this.getPref(prefKey ?? ENU_PREFS.Global)).get(key, def as preferences.ValueType) as Promise<T>;
  }

  public getPreValueCall<T>(key: string, defValue: T, prefKey?:string, callback?: (data: T) => void) {
    this.getPref(prefKey ?? ENU_PREFS.Global).then(async (pres: dataPreferences.Preferences) => {
      if (callback){
        callback(pres.getSync(key, defValue as preferences.ValueType) as T);
      }
    }).catch((err: Error) => {
      hsLog.e(TAG, 'Get the preferences failed, err: ' + err);
      if (callback) {
        callback(defValue)
      }
    });
  }


  //指定首选项 -> 保持值 (默认全局首选项）
  async setPrefValue<T>(key: string, value: T, perfKey?: string):Promise<void> {

    let promise = await this.getPref(perfKey ?? ENU_PREFS.Global).then(async (p) => {
      await p.put(key, value as preferences.ValueType)
      await p.flush();
    }).catch((err:Error)=>{
      hsLog.e(TAG, 'set the preferences failed, err: ' + err);
    })
    return promise

  }

  public async deletePref(key: string) {
    let pref = this.getFunc();
    const preferences: dataPreferences.Preferences = await pref();
    let deleteValue = preferences.delete(key);
    deleteValue.then(() => {
      hsLog.i(TAG, 'Succeeded in deleting the key appFontSize.');
    }).catch((err: Error) => {
      hsLog.e(TAG, 'Failed to delete the key appFontSize. Cause: ' + err);
    });
  }

  public async deletePrefValue(key: string, prefKey?:string) {

    const preferences: dataPreferences.Preferences = await this.getPref(prefKey ?? ENU_PREFS.Global)
    // let deleteValue0 = (await this.getPref(prefKey ?? ENU_PREFS.Global) as dataPreferences.Preferences).delete(key);

    let deleteValue = preferences.delete(key);
    deleteValue.then(() => {
      hsLog.i(TAG, 'Succeeded in deleting the key appFontSize.');
    }).catch((err: Error) => {
      hsLog.e(TAG, 'Failed to delete the key appFontSize. Cause: ' + err);
    });
  }

  // private getPrefCall<T>(key: string, defValue: T, callback: (data: T) => void) {
  //   let pref = this.getFunc();
  //   pref().then(async (pres: dataPreferences.Preferences) => {
  //     callback(pres.getSync(key, defValue as preferences.ValueType) as T);
  //   }).catch((err: Error) => {
  //     hsLog.e(TAG, 'Get the preferences failed, err: ' + err);
  //     callback(defValue);
  //   });
  // }

  // public put(key: string, value: number | string | boolean, notCover?: boolean) {
  //   let pref = this.getFunc();
  //   pref().then(async (preferences: dataPreferences.Preferences) => {
  //     if (typeof notCover === 'undefined' || notCover === false) { //需要覆盖
  //       await preferences.put(key, value);
  //       preferences.flush();
  //       return
  //     }
  //     preferences.has(key).then(async (isExist: boolean) => {
  //       hsLog.i(TAG, 'preferences has changeFontSize is ' + isExist);
  //       if (!isExist) {
  //         await preferences.put(key, value);
  //         preferences.flush();
  //       }
  //     }).catch((err: Error) => {
  //       hsLog.i(TAG, 'Has the value failed with err: ' + err);
  //     });
  //   }).catch((err: Error) => {
  //     hsLog.i(TAG, 'Get the preferences failed, err: ' + err);
  //   });
  // }

  // 其他需要传递的内容依此扩展
  /**
   * 判断是否是快速点击
   * @returns
   */
  public isQuickClick(): boolean {
    const curTime = systemDateTime.getTime();
    if (curTime - this.lastClickTime > 600) {
      this.lastClickTime = curTime;
      return false;
    }
    hsLog.i(TAG, '点击过快了');
    return true;
  }

  /**
   * 阻断快速点击代理，比使用{isQuickClick}更加简洁
   */
  public blockQuickClick(onClick: () => void): () => void {
    return () => {
      if (this.isQuickClick()) {
        return
      }
      onClick();
    }
  }

  defaultValue<T>(value:T):Promise<T> {
    return new Promise((resolve)=>resolve(value))
  }

  defaultPref():Promise<dataPreferences.Preferences> {
    const pref = this.getPref(ENU_PREFS.Global)
    if (pref === undefined) {
      throw Error('请先调用YWGlobalThis init()！')
    }
    return pref
  }
}

export let globalThis = YWGlobalThis.getInstance();
