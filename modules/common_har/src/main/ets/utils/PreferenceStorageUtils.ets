import dataPreferences from '@ohos.data.preferences'
/**
 * 项目全局存储，使用ohos.data.preferences
 */
const defaultPreferenceName = "YOUR_GLOBAL_PREFERENCES_CONF"

type ValueType = number | string | boolean | Array<number> | Array<string> | Array<boolean>;


export class StorageUtils {


  private constructor() {
  }

  static readonly context = getContext();

  /**
   * 获取Prefer实例
   * @param preferenceName
   * @returns
   */
  static async getPreferences(preferenceName: string = defaultPreferenceName) {
    return await dataPreferences.getPreferences(StorageUtils.context, preferenceName)
  }

  static async put(key: string, value: ValueType, preferenceName: string = defaultPreferenceName) {
    // 获取实例
    let preferences = await StorageUtils.getPreferences(preferenceName)
    await preferences.put(key, value)
    //Tips Point ---此处一定要flush，要不然不能永久序列化到本地
    await preferences.flush()
  }
  /**
   * 获取值
   * @param key
   * @param defaultValue
   * @param preferenceName
   * @returns
   */
  static async get(key: string, defaultValue: ValueType = "", preferenceName: string = defaultPreferenceName) {
    // 获取实例
    let preferences = await StorageUtils.getPreferences(preferenceName)
    return preferences.get(key, defaultValue)
  }

  /**
   * 删除值
   * @param key
   * @param preferenceName
   * @returns
   */
  static async delete(key: string, preferenceName: string = defaultPreferenceName) {
    let preferences = await StorageUtils.getPreferences(preferenceName)
    return await preferences.delete(key)
  }

  /**
   * 清空
   * @param preferenceName
   * @returns
   */
  static async clear(preferenceName: string = defaultPreferenceName) {
    let preferences = await StorageUtils.getPreferences(preferenceName)
    return await preferences.clear()
  }
}


export class StorageKeys {
  static readonly USER_LOGIN:string = "USER_LOGIN"
  static readonly USER_INFO_KEY:string = "USER_INFO_KEY"
}