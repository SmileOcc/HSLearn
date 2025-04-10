import { vibrator } from '@kit.SensorServiceKit';
import { resourceManager } from '@kit.LocalizationKit';
import { YWStrUtils } from './YWStrUtils';
import { PreferencesUtil } from './PreferencesUtil';
import { YWRandomUtils } from './YWRandomUtils';
import { hsLog } from '@learn/logger_har';
import { YWAssetStore } from './YWAssetStore';
import { display } from '@kit.ArkUI';
import { BusinessError, Callback, deviceInfo } from '@kit.BasicServicesKit';
import fs from '@ohos.file.fs';
import util from '@ohos.util';

/**
 * 设备相关工具类
 */
export class YWDeviceUtils {
  private static deviceIdKey: string = "device_id_cache_harmony_key";
  private static deviceId: string = ""; //设备ID




  /**
   * 获取当前默认的display对象。
   * @returns
   */
  static getDefaultDisplaySync(): display.Display {
    return display.getDefaultDisplaySync()
  }


  /**
   * 获取设备的屏幕宽度，单位为px。
   * @returns
   */
  static getWidth(): display.FoldStatus {
    return YWDeviceUtils.getDefaultDisplaySync().width;
  }

  /**
   * 获取设备的屏幕高度，单位为px。
   * @returns
   */
  static getHeight(): display.FoldStatus {
    return YWDeviceUtils.getDefaultDisplaySync().height;
  }

  /**
   * 获取设备当前显示的方向
   * Orientation:
   *   PORTRAIT  0  表示设备当前以竖屏方式显示。
   *   LANDSCAPE  1  表示设备当前以横屏方式显示。
   *   PORTRAIT_INVERTED  2  表示设备当前以反向竖屏方式显示。
   *   LANDSCAPE_INVERTED  3  表示设备当前以反向横屏方式显示。
   * @returns
   */
  static getOrientation(): display.Orientation {
    return YWDeviceUtils.getDefaultDisplaySync().orientation;
  }


  /**
   * 获取设备的状态
   * DisplayState:
   *   STATE_UNKNOWN  0  表示显示设备状态未知。
   *   STATE_OFF  1  表示显示设备状态为关闭。
   *   STATE_ON  2  表示显示设备状态为开启。
   *   STATE_DOZE  3  表示显示设备为低电耗模式。
   *   STATE_DOZE_SUSPEND  4  表示显示设备为睡眠模式，CPU为挂起状态。
   *   STATE_VR  5  表示显示设备为VR模式。
   *   STATE_ON_SUSPEND  6 表示显示设备为开启状态，CPU为挂起状态。
   * @returns
   */
  static getDisplayState(): display.DisplayState {
    return YWDeviceUtils.getDefaultDisplaySync().state;
  }


  /**
   * 获取挖孔屏、刘海屏、瀑布屏等不可用屏幕区域信息。使用Promise异步回调。建议应用布局规避该区域。
   * @returns
   */
  static async getCutoutRect(): Promise<display.Rect> {
    let cutoutInfo = await YWDeviceUtils.getDefaultDisplaySync().getCutoutInfo()
    return cutoutInfo.boundingRects[0]
  }

  /**
   * 获取挖孔屏、刘海屏等不可用屏幕区域的高度。单位px。
   * @returns
   */
  static async getCutoutHeight(): Promise<number> {
    let rect = await YWDeviceUtils.getCutoutRect();
    if (rect) {
      return rect.height;
    }
    return 0;
  }


  /**
   * 检查设备是否可折叠。
   * @returns
   */
  static isFoldable(): boolean {
    return display.isFoldable();
  }


  /**
   * 获取可折叠设备的当前折叠状态。
   * FoldStatus:
   *   FOLD_STATUS_UNKNOWN  0  表示设备当前折叠状态未知。
   *   FOLD_STATUS_EXPANDED 1  表示设备当前折叠状态为完全展开。
   *   FOLD_STATUS_FOLDED  2  表示设备当前折叠状态为折叠。
   *   FOLD_STATUS_HALF_FOLDED  3  表示设备当前折叠状态为半折叠。半折叠指完全展开和折叠之间的状态。
   * @returns
   * @returns
   */
  static getFoldStatus(): display.FoldStatus {
    return display.getFoldStatus();
  }


  /**
   * 获取可折叠设备的显示模式。
   * FoldDisplayMode:
   *   FOLD_DISPLAY_MODE_UNKNOWN  0  表示设备当前折叠显示模式未知。
   *   FOLD_DISPLAY_MODE_FULL  1  表示设备当前全屏显示。
   *   FOLD_DISPLAY_MODE_MAIN  2  表示设备当前主屏幕显示。
   *   FOLD_DISPLAY_MODE_SUB  3  表示设备当前子屏幕显示。
   *   FOLD_DISPLAY_MODE_COORDINATION  4  表示设备当前双屏协同显示。
   * @returns
   */
  static getFoldDisplayMode(): display.FoldDisplayMode {
    return display.getFoldDisplayMode();
  }


  /**
   * 开启折叠设备折叠状态变化的监听。
   * @param callback
   */
  static onFoldStatusChange(callback: Callback<display.FoldStatus>) {
    display.on('foldStatusChange', callback)
  }

  /**
   * 关闭折叠设备折叠状态变化的监听。
   * @param callback
   */
  static offFoldStatusChange(callback: Callback<display.FoldStatus>) {
    try {
      display.off('foldStatusChange', callback)
    } catch (err) {
      let error = err as BusinessError;
      hsLog.e(`DisplayUtil-offFoldStatusChange-异常 ~ code: ${error.code} -·- message: ${error.message}`);
    }
  }





  /**
   * 获取设备ID（卸载APP后依旧不变）
   * @param generateId 自己生成的id，不传使用默认生成的id
   * @param rule 是否带-
   * @returns
   */
  static async getDeviceId(generateId?: string, rule: boolean = true): Promise<string> {
    let deviceId = YWDeviceUtils.deviceId;
    if (YWStrUtils.isEmpty(deviceId)) {
      if (canIUse("SystemCapability.Security.Asset")) {
        deviceId = YWStrUtils.toStr(await YWAssetStore.get(YWDeviceUtils.deviceIdKey));
      } else {
        deviceId = YWStrUtils.toStr(await PreferencesUtil.get(YWDeviceUtils.deviceIdKey, "") as string)
        hsLog.e(`当前设备不支持,关键资产存储服务`);
      }
    }
    if (YWStrUtils.isEmpty(deviceId)) {
      if (generateId && YWStrUtils.isNotEmpty(generateId)) {
        deviceId = generateId;
      } else {
        deviceId = YWRandomUtils.generateRandomUUID(true);
      }
      if (!rule) {
        deviceId = deviceId.replace('-', ''); //去除-
      }
      if (canIUse("SystemCapability.Security.Asset")) {
        //将deviceId保存到关键资产（在应用卸载时保留）
        YWAssetStore.set(YWDeviceUtils.deviceIdKey, deviceId);
      } else {
        PreferencesUtil.put(YWDeviceUtils.deviceIdKey, deviceId)
        hsLog.e(`当前设备不支持,关键资产存储服务`);
      }
    }
    YWDeviceUtils.deviceId = deviceId;
    return deviceId;
  }


  /**
   * 获取设备的Configuration
   * @returns
   */
  static getConfiguration(): Promise<resourceManager.Configuration> {
    return getContext().resourceManager.getConfiguration();
  }

  /**
   * 获取设备的Configuration
   * @returns
   */
  static getConfigurationSync(): resourceManager.Configuration {
    return getContext().resourceManager.getConfigurationSync();
  }

  /**
   * 获取当前设备屏幕方向。
   * resourceManager.Direction:
   *   DIRECTION_VERTICAL 0 竖屏。
   *   DIRECTION_HORIZONTAL 1 横屏。
   * @returns
   */
  static getDirection(): Number {
    return YWDeviceUtils.getConfigurationSync().direction
  }


  /**
   * 获取设备的DeviceCapability
   * @returns
   */
  static getDeviceCapability(): Promise<resourceManager.DeviceCapability> {
    return getContext().resourceManager.getDeviceCapability();
  }

  /**
   * 用户获取设备的DeviceCapability
   * @returns
   */
  static getDeviceCapabilitySync(): resourceManager.DeviceCapability {
    return getContext().resourceManager.getDeviceCapabilitySync();
  }

  /**
   * 获取当前设备类型
   * resourceManager.DeviceType:
   *   DEVICE_TYPE_PHONE手机。
   *   DEVICE_TYPE_TABLET 平板。
   *   DEVICE_TYPE_CAR 汽车。
   *   DEVICE_TYPE_PC 电脑。
   *   DEVICE_TYPE_TV 电视。
   *   DEVICE_TYPE_WEARABLE 穿戴。
   *   DEVICE_TYPE_2IN1 2IN1。
   * @returns
   */
  static getDeviceType(): number {
    return YWDeviceUtils.getDeviceCapabilitySync().deviceType;
  }

  /**
   * 获取当前设备类型
   * @returns
   */
  static getDeviceTypeStr(): string {
    let deviceType = YWDeviceUtils.getDeviceType();
    switch (deviceType) {
      case resourceManager.DeviceType.DEVICE_TYPE_PHONE:
        return "手机";
      case resourceManager.DeviceType.DEVICE_TYPE_TABLET:
        return "平板";
      case resourceManager.DeviceType.DEVICE_TYPE_PC:
        return "电脑";
      case resourceManager.DeviceType.DEVICE_TYPE_TV:
        return "电视";
      case resourceManager.DeviceType.DEVICE_TYPE_CAR:
        return "汽车";
      case resourceManager.DeviceType.DEVICE_TYPE_WEARABLE:
        return "穿戴";
      case resourceManager.DeviceType.DEVICE_TYPE_2IN1:
        return "2IN1";
      default:
        return ""
    }
  }


  /**
   * 获取当前设备屏幕密度。
   * resourceManager.ScreenDensity:
   *   SCREEN_SDPI 120 小规模的屏幕密度。
   *   SCREEN_MDPI 160 中规模的屏幕密度。
   *   SCREEN_LDPI 240 大规模的屏幕密度。
   *   SCREEN_XLDPI 320 特大规模的屏幕密度。
   *   SCREEN_XXLDPI 480 超大规模的屏幕密度。
   *   SCREEN_XXXLDPI 640 超特大规模的屏幕密度。
   * @returns
   */
  static getScreenDensity(): number {
    return YWDeviceUtils.getDeviceCapabilitySync().screenDensity;
  }


  /**
   * 开启振动
   * @param duration
   * @param usage
   */
  static startVibration(duration: number = 10000, usage: vibrator.Usage = 'media'): Promise<void> {
    return vibrator.startVibration({ type: 'time', duration: duration }, { id: 0, usage: usage });
  }

  /**
   * 停止振动（按照VIBRATOR_STOP_MODE_TIME模式）
   */
  static stopVibration(): Promise<void> {
    return vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME);
  }

  // 判断是否运行在模拟器环境的函数
  static async isRunningOnEmulator(): Promise<boolean> {

    // 设备类型
    let deviceTypeInfo: string = deviceInfo.deviceType
    // 设备厂家名
    let manufactureInfo: string = deviceInfo.manufacture
    // 设备品牌名称
    let brandInfo: string = deviceInfo.brand
    let productModel: string = deviceInfo.productModel
    if (productModel == "emulator") {
      return true
    }

    // const sysDirPath = '/sys/devices/virtual/dmi/id';
    // const biosVendorFilePath = `${sysDirPath}/bios_vendor`;
    //
    // try {
    //   // 检查 sysDirPath 是否存在
    //   const sysDirStat = await fs.stat(sysDirPath);
    //   if (sysDirStat) {
    //     // 检查 biosVendorFilePath 是否存在
    //     const biosVendorFileStat = await fs.stat(biosVendorFilePath);
    //     if (biosVendorFileStat) {
    //       // 读取 bios_vendor 文件内容
    //       const file = await fs.open(biosVendorFilePath, 0o400);
    //       const buffer = new ArrayBuffer(1024);
    //       const readLength = await fs.read(file.fd, buffer);
    //       const biosVendor = new util.TextDecoder().decodeToString(new Uint8Array(buffer));
    //       await fs.close(file);
    //       // 判断是否包含模拟器相关标识
    //       return biosVendor.includes('Android') || biosVendor.includes('Genymotion');
    //     }
    //   }
    // } catch (e) {
    //   console.error(`Error checking emulator: ${e.message}`);
    // }
    return false;
  }

}


