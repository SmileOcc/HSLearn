import { common } from '@kit.AbilityKit';
import dataPreferences from '@ohos.data.preferences';

export class GlobalThis {

  private constructor() {}

  private static instance: GlobalThis

  // 缓存context
  private _uiContexts = new Map<string, common.UIAbilityContext>();
  // 缓存属性值
  private _attribute = new Map<string, string>();
  // 缓存首选项
  private _preferences = new Map<string, Promise<dataPreferences.Preferences>>();


  public static getInstance(): GlobalThis {
    if (!GlobalThis.instance) {
      GlobalThis.instance = new GlobalThis();
    }
    return GlobalThis.instance;
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
}