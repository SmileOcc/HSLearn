import Logger from '../common/KLogger'
import { EnviInfo } from '../../../../../../learn/src/main/ets/model/EnvirInfo'
import { UserInfoModel } from '../../../../../../learn/src/main/ets/pages/accountInfo/model/UserInfoModel'
import dataPreferences from '@ohos.data.preferences';
import { bundleManager, Context } from '@kit.AbilityKit';
import preferences from '@ohos.data.preferences';
import { YWAppUtils } from './YWAppUtils';

/*注意：开发工具DevEco studio中，默认每次启动app是先卸载再安装导致本地保存的数据丢失，需要改下配置每次运行都覆盖安装
【entry-->edit config... --> keep application data】*/

const defaultPreferenceName: string = "YW_HARMONY_UTILS_PREFERENCES"

//整存整取，汗。。。。
export class PreferencesUtil {
  //日志过滤器
  private static readonly LOG: string = "====PreferencesUtil"
  //本地保存的文件名，和文件内的key名这里打算共用一个就行
  private static readonly FILENAME_AND_KEY: string = 'FILENAME_AND_KEY'
  /** 本地要保存的用户信息 */
  public mUserInfo: UserInfoModel = new UserInfoModel()
  // 本地要保存的环境信息
  public mEnvirInfo: EnviInfo = new EnviInfo()
  //=========单例模式，保存数据到内存实例 start=========
  private static instance: PreferencesUtil;

  private constructor() {
  }

  /**
   * 通过单例，获取本地映射到内存中的实例
   * @returns 内存中本地数据的实例
   */
  public static getInstance() {
    if (PreferencesUtil.instance == null) {
      PreferencesUtil.instance = new PreferencesUtil();
    }
    return PreferencesUtil.instance;
  }


  public static async getData(context: Context) {
    try {
      Logger.info(PreferencesUtil.LOG, 'getData');
      let file = await dataPreferences.getPreferences(context, PreferencesUtil.FILENAME_AND_KEY)
      Logger.info(PreferencesUtil.LOG, 'getData', 'file succ');
      let value = await file.get(PreferencesUtil.FILENAME_AND_KEY, JSON.stringify(PreferencesUtil.getInstance()))
      Logger.info(PreferencesUtil.LOG, 'getData', 'get succ', 'value:' + value);

      //这个方法受控制了，不生效了
      // Object.assign(PreferencesUtil.getInstance(), JSON.parse(value.toString()))//将本地数据 拷贝到单例中去。

      //odd测试数据
      let localPreferencesUtil:PreferencesUtil = JSON.parse(value.toString())
      PreferencesUtil.getInstance().mUserInfo = localPreferencesUtil.mUserInfo
      PreferencesUtil.getInstance().mEnvirInfo = localPreferencesUtil.mEnvirInfo

      Logger.info(PreferencesUtil.LOG, 'getData', 'assign succ');

      let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
      let data = await bundleManager.getBundleInfoForSelf(bundleFlags); //开始保存app的版本名称和版本号
      PreferencesUtil.getInstance().mEnvirInfo.versionName = data.versionName
      PreferencesUtil.getInstance().mEnvirInfo.versionCode = data.versionCode
      Logger.info(PreferencesUtil.LOG, 'getData', 'set versionName and versionCode succ');
    } catch (e) {
      Logger.error(PreferencesUtil.LOG, 'getData', JSON.stringify(e));
    }
  }


  public static async saveData(context:Context) {
    try {
      Logger.info(PreferencesUtil.LOG, 'saveData');
      let file = await dataPreferences.getPreferences(context, PreferencesUtil.FILENAME_AND_KEY)
      Logger.info(PreferencesUtil.LOG, 'saveData', 'file succ');
      await file.put(PreferencesUtil.FILENAME_AND_KEY, JSON.stringify(PreferencesUtil.getInstance()))
      Logger.info(PreferencesUtil.LOG, 'saveData', 'put succ');
      await file.flush()
      Logger.info(PreferencesUtil.LOG, 'saveData', 'flush succ');
    } catch (e) {
      Logger.error(PreferencesUtil.LOG, 'saveData', JSON.stringify(e));
    }
  }

  /**
   * 获取Preferences实例
   * @param name
   * @returns
   */
  private static async getPreferences(name: string = defaultPreferenceName): Promise<preferences.Preferences> {
    return dataPreferences.getPreferences(YWAppUtils.getContext(), name);
  }

  /**
   * 将数据缓存
   * @param key
   * @param value
   * @param preferenceName
   */
  static async put(key: string, value: preferences.ValueType, preferenceName: string = defaultPreferenceName) {
    let preferences = await PreferencesUtil.getPreferences(preferenceName); //获取实例
    await preferences.put(key, value);
    await preferences.flush(); //此处一定要flush，要不然不能永久序列化到本地
  }

  /**
   * 获取缓存值
   * @param key
   * @param defValue
   * @param preferenceName
   * @returns
   */
  static async get(key: string, defValue: preferences.ValueType, preferenceName: string = defaultPreferenceName) {
    let preferences = await PreferencesUtil.getPreferences(preferenceName); //获取实例
    return preferences.get(key, defValue);
  }

  /**
   * 获取string类型的缓存值
   * @param key
   * @returns
   */
  static async getString(key: string): Promise<string> {
    return (await PreferencesUtil.get(key, "")) as string;
  }

  /**
   * 获取number类型的缓存值
   * @param key
   * @returns
   */
  static async getNumber(key: string) {
    return (await PreferencesUtil.get(key, 0)) as number;
  }

  /**
   * 获取boolean类型的缓存值
   * @param key
   * @param defValue
   * @param preferenceName
   * @returns
   */
  static async getBoolean(key: string) {
    return (await PreferencesUtil.get(key, false)) as boolean;
  }

  /**
   * 检查缓存的Preferences实例中是否包含名为给定Key的存储键值对
   * @param key
   * @param preferenceName
   * @returns
   */
  static async has(key: string, preferenceName: string = defaultPreferenceName) {
    let preferences = await PreferencesUtil.getPreferences(preferenceName); //获取实例
    return await preferences.has(key);
  }

  /**
   * 删除缓存值
   * @param key
   * @param preferenceName
   * @returns
   */
  static async delete(key: string, preferenceName: string = defaultPreferenceName) {
    let preferences = await PreferencesUtil.getPreferences(preferenceName); //获取实例
    await preferences.delete(key);
    return await preferences.flush() //此处一定要flush，要不然不能永久序列化到本地
  }

  /**
   * 清空缓存
   * @param preferenceName
   * @returns
   */
  static async clear(preferenceName: string = defaultPreferenceName) {
    let preferences = await PreferencesUtil.getPreferences(preferenceName); //获取实例
    await preferences.clear();
    return await preferences.flush() //此处一定要flush，要不然不能永久序列化到本地
  }


}


function assign(target: Record<string, Object>, ...source: Object[]): Record<string, Object> {
  for (const items of source) {
    for (const key of Object.keys(items)) {
      target[key] = Reflect.get(items, key)
    }
  }
  return target;
}


