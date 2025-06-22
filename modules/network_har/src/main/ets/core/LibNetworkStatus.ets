import { NetworkStatusCallback } from './NetworkConstants';
import { connection } from '@kit.NetworkKit'; //网络连接
import { hsLog } from '@learn/logger_har';
import { HSLibNetworkStatusProxy } from '../HSLibNetworkStatusProxy';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { radio } from '@kit.TelephonyKit';
import { wifiManager } from '@kit.ConnectivityKit';
import { HashMap } from '@kit.ArkTS';
import { netQuality } from '@kit.NetworkBoostKit';
import { NetworkEventData } from './EmmitterData';
import { NetEventData, NetworkData, NetworkEventName } from './NetEventData';

const TAG = "LibNetworkStatus"

export class LibNetworkStatus implements HSLibNetworkStatusProxy {
  private static instance: LibNetworkStatus;
  // 网络状态监听eventId
  private networkEventId: number = 10001;
  // 网络监听相关结果数据
  private emitterEvent: NetworkEventData;
  private connectionMap: HashMap<connection.NetBearType, connection.NetConnection> = new HashMap();

  /**
   * LibNetworkStatus单例实例
   * 保证全局只有一个网络管理类实例
   */
  private constructor() {
    this.emitterEvent = new NetworkEventData(this.networkEventId);
  }

  public static getInstance(): LibNetworkStatus {
    if (!LibNetworkStatus.instance) {
      LibNetworkStatus.instance = new LibNetworkStatus();
    }
    return LibNetworkStatus.instance;
  }

  public getEmitterEvent(): NetworkEventData {
    return this.emitterEvent;
  }

  private setEventPriority(priority: emitter.EventPriority): void {
    this.emitterEvent.priority = priority;
  }

  /**
   * 当前网络类型
   * 存储当前的网络连接状态
   */
  private currentNetType: connection.NetBearType = connection.NetBearType.BEARER_WIFI;
  /**
   * 网络是否可用
   * 标识当前是否有可用的网络连接
   */
  private isNetworkAvailable: boolean = false;

  /**
   * 存储网络连接状态变化回调函数的集合
   * 当网络状态发生变化时，会遍历此集合并调用相应的回调函数
   */
  private callbacks: Set<NetworkStatusCallback> = new Set();

  // 类的构造函数、方法以及其他逻辑实现将在这里继续...

  /**
   * 通过emitter将结果传递给页面
   * @param eventName 事件名称
   * @param status    网络状态（可传递不同的监听结果数据类型）
   * @param netType   网络类型（WI-FI、蜂窝数据等）
   * @param priority  emitter事件权重
   */
  private postEvent(eventName: NetworkEventName, status: NetworkData, netType: connection.NetBearType,
    priority?: emitter.EventPriority) {
    this.emitterEvent.priority = priority;
    const netData = new NetEventData(eventName, status, netType)
    emitter.emit(this.emitterEvent, {
      data: netData
    })
    this.callbackNetworkStatus(netData)
  }

  /**
   * 开启网络监听
   * @param netType 需要监听的网络类型
   */
  public registerNetConnectListener(...netType: connection.NetBearType[]) {
    netType.forEach((type: connection.NetBearType) => {
      this.startNetObserve(type);
      if (type === connection.NetBearType.BEARER_WIFI) {
        this.wifiStateObserve();
      }
    })
  }

  /**
   * 添加回调方法，用于监听网络状态变化
   *
   * @param callback 监听网络状态变化的回调函数
   * @param isCallBackCurrentNetworkStatus 是否立即调用回调并返回当前网络状态
   */
  addCallback(callback: NetworkStatusCallback, isCallBackCurrentNetworkStatus: boolean): void {
    if (!callback || !this.callbacks) {
      return;
    }

    // 确保回调方法未被重复添加
    if (this.callbacks.has(callback)) {
      return;
    }

    this.callbacks.add(callback);

    // 如果需要，立即调用回调并返回当前网络状态
    if (isCallBackCurrentNetworkStatus) {
      // callback(new NetEventData(eventName, this.currentNetType, netType));
    }
  }

  /**
   * 移除指定的回调方法
   *
   * @param callback 需要移除的回调方法
   */
  removeCallback(callback: NetworkStatusCallback): void {
    if (!callback || !this.callbacks || !this.callbacks.has(callback)) {
      return;
    }

    this.callbacks.delete(callback);
  }

  /**
   * 通知所有注册的回调方法当前的网络状态
   *
   * 当网络状态发生变化时，此方法将被调用，以通知所有注册的回调方法
   */
  callbackNetworkStatus(netData:NetEventData): void {
    if (!this.callbacks || this.callbacks.size === 0) {
      return;
    }

    // 遍历所有注册的回调方法，并调用它们，传递当前网络状态
    this.callbacks.forEach(callback => {
      callback(netData);
    });
  }


  /**
   * 检查当前网络是否可用
   *
   * @returns 返回一个布尔值，指示当前网络是否可用
   */
  isCheckNetworkAvailable(): boolean {
    // return this.isNetworkAvailable;
    return this.judgeHasNet()
  }

  /**
   * 获取当前的网络状态
   *
   * @returns 返回当前的网络状态码
   */
  getCurrentNetworkType(): connection.NetBearType {
    return this.currentNetType;
  }

  /**
   * 获取当前的网络类型
   *
   * 此方法通过调用系统API获取当前网络状态，并根据承载类型确定网络类型。
   * 通过精准的判断逻辑，确保获取到的网络类型准确无误。
   */

  getDefaultNetSync() {
    //获得当前网络状态
    let netHandle = connection.getDefaultNetSync()
    if (netHandle) {
      // 获取网络的类型、拥有的能力等信息
      let capabilities = connection.getNetCapabilitiesSync(netHandle)
      hsLog.i(TAG, 'getNetCapabilitiesSync：' + JSON.stringify(capabilities))
      if (capabilities && capabilities.bearerTypes && capabilities.bearerTypes.length > 0) {

        // 获取第一个承载类型
        const bearerType: connection.NetBearType = capabilities.bearerTypes[0];
        this.currentNetType = bearerType
        // 根据承载类型判断网络类型
        // switch (bearerType) {
        //   case connection.NetBearType.BEARER_CELLULAR:
        //     // 蜂窝网络
        //     break;
        //   case connection.NetBearType.BEARER_WIFI:
        //     // Wi-Fi网络
        //     break;
        //   case connection.NetBearType.BEARER_ETHERNET:
        //     // 以太网网络（通常移动设备不支持，但为完整性保留）
        //     break;
        //   case connection.NetBearType.BEARER_VPN:
        //     break;
        //   case connection.NetBearType.BEARER_BLUETOOTH:
        //     break;
        //   default:
        //   // 未知网络类型
        //     break;
        // }

      }
    }
  }

  /**
   * 判断当前网络是否可用
   * 使用网络前，例如打开一个应用时，需要检查当前连接的网络是否可用。
   * 如果可用，则正常进行网络请求；如果不可用，则需要提示用户网络不可用。
   * @returns 当前网络是否可用
   */
  judgeHasNet(): boolean {
    try {
      let netHandle = connection.getDefaultNetSync();
      if (!netHandle || netHandle.netId === 0) {
        this.isNetworkAvailable = false
        return false;
      }
      let netCapability = connection.getNetCapabilitiesSync(netHandle);
      let cap = netCapability.networkCap || [];
      if (cap.includes(connection.NetCap.NET_CAPABILITY_VALIDATED)) {
        //connection.NetCap.NET_CAPABILITY_VALIDATED，该值代表网络是通的，能够发起HTTP和HTTPS的请求。
        // 网络信息变化，网络可用
        this.isNetworkAvailable = true
        return true;
      } else {
        // 网络信息变化，网络不可用
        this.isNetworkAvailable = false
        return false;
      }
    } catch (e) {
      let err = e as BusinessError;
      hsLog.i(TAG, "JudgeHasNet" + JSON.stringify(err));
    }
    this.isNetworkAvailable = false
    return false;
  }

  /**
   * 获取网络状态，查询手机卡注册网络的运营商名称、是否处于漫游状态、设备的网络注册状态等信息
   */
  getNetworkStatus() {
    radio.getNetworkState((err: BusinessError, data: radio.NetworkState) => {
      if (err) {
        hsLog.e(TAG,`getNetworkState failed, callback: err->${JSON.stringify(err)}`);
      }
      // regState字段表示设备的网络注册状态
      // （REG_STATE_POWER_OFF，值为3）蜂窝无线电已关闭，modem下电，无法和网侧进行通信
      hsLog.i(TAG,"Success getNetworkStatus：" + JSON.stringify(data));
    });
  }

  /**
   * 查询当前网络是3G/4G/5G
   * SignalInformation.signalType表示蜂窝网络的类型
   * 未知（值为0）
   * 2G：GSM（值为1）、CDMA（值为2）
   * 3G：WCDMA（值为3）、TDSCDMA（值为4）
   * 4G：LTE（值为5）
   * 5G：NR（值为6）
   * @returns 指定SIM卡槽对应的注册网络信号强度信息列表
   */
  async getSignalType(): Promise<radio.SignalInformation[]> {
    let slotId: number = await radio.getPrimarySlotId();
    let data: Array<radio.SignalInformation> = radio.getSignalInformationSync(slotId);
    // signalType代表网络类型NetworkType
    let signalType = data[0].signalType;
    hsLog.i(TAG,"getSignalType：" + JSON.stringify(data));
    return data;
  }

  /**
   * 查询WLAN是否已使能，可以帮助用户快速了解自己是否可以使用Wi-Fi网络进行连接。
   * 当Wi-Fi跟蜂窝同时存在时，有助于实现网络连接的无缝切换。
   * @returns true:已使能， false:未使能
   */
  getWifiStatus(): boolean {
    try {
      let isWifiActive: boolean = wifiManager.isWifiActive();
      return isWifiActive;
    } catch (error) {
      hsLog.e(TAG,"failed:" + JSON.stringify(error));
    }
    return false;
  }

  /**
   * 查询WLAN是否已连接是判断能否通过Wi-Fi 进行各种网络活动的直接方式。
   * @returns true，已连接。false，未连接
   */
  getWifiIsConnected(): boolean {
    try {
      let ret = wifiManager.isConnected();
      hsLog.i(TAG,"isConnected:" + ret);
      return ret;
    } catch (error) {
      hsLog.e(TAG,"failed:" + JSON.stringify(error));
    }
    return false;
  }

  /**
   * 获取当前连接Wi-Fi的信号强度
   * 通过获取信号强度，用户可以初步判断当前网络是否能够满足其对速度的需求。
   * 取值范围为[0, 4]，取值越大表示信号越强
   * @returns 信号强度，取值范围[0, 4]，-1表示报错
   */
  async getSignalLevel(): Promise<number> {
    try {
      let wifiLinkedInfo: wifiManager.WifiLinkedInfo = await wifiManager.getLinkedInfo();
      let rssi = wifiLinkedInfo.rssi;
      let band = wifiLinkedInfo.band;
      let level = wifiManager.getSignalLevel(rssi, band);
      hsLog.i(TAG,"level:" + JSON.stringify(level));
      return level;
    } catch (error) {
      hsLog.e(TAG,"failed:" + JSON.stringify(error));
    }
    return -1;
  }


  /**
   * 注册网络状态监听：
   * 设备从无网络到有网络会触发"netAvailable"、"netCapabilitiesChange"、"netConnectionPropertiesChange"事件；
   * 设备从有网络到无网络会触发"netLost"事件
   * 设备从wifi到蜂窝网络会触发"netLost"事件（wifi不可用）、之后触发"netAvailable"事件（蜂窝可用）
   */
  startNetObserve(netType: connection.NetBearType) {
    if (this.connectionMap.hasKey(netType)) {
      hsLog.i(TAG, '已订阅网络事件，无需再次订阅')
      return
    }

    //创建NetConnection对象
    let netConnection = connection.createNetConnection({
      netCapabilities: {
        bearerTypes: [netType]
      }
    })


    //注册
    netConnection.register((error) => {
      let result = true;
      if (error) {
        result = false
        hsLog.i(TAG, 'networkConnection.register failure: ' + JSON.stringify(error))
      } else {
        hsLog.i(TAG, ' networkConnection.register success')
      }
      this.postEvent(NetworkEventName.NetObserverRegister, result, netType);

    })

    //订阅网络可用事件
    hsLog.d(TAG, '订阅网络可用事件-->')
    // 网络能力改变监听，当网络能力变化时，如网络从无网络到有网络、从4G切换到5G时，会触发该事件。
    netConnection.on('netCapabilitiesChange', (data: connection.NetCapabilityInfo) => {
      hsLog.i(TAG, "NetType :" + netType + ", network netCapabilitiesChange: " + JSON.stringify(data));
      this.postEvent(NetworkEventName.NetCapabilitiesChange, data, netType);
    })

    netConnection.on('netAvailable', (data: connection.NetHandle) => {
      hsLog.i(TAG, 'netAvailable：' + JSON.stringify(data))
      this.isNetworkAvailable = true

      //获得默认网络类型
      this.getDefaultNetSync()
      // 检查默认数据网络是否被激活，使用同步方式返回接口，如果被激活则返回true，否则返回false。
      this.postEvent(NetworkEventName.NetAvailable, connection.hasDefaultNetSync(), netType);
    })

    // 订阅网络阻塞状态事件，当网络阻塞时，如网络性能下降、数据传输出现延迟等情况时，会触发该事件
    netConnection.on('netBlockStatusChange', (data: connection.NetBlockStatusInfo) => {
      hsLog.i(TAG, "NetType :" + netType + ", network netBlockStatusChange " + JSON.stringify(data));
      this.postEvent(NetworkEventName.NetBlock, data, netType)
    });
    // 网络连接信息变化监听，当网络连接信息变化时，如从无网络到有网络、从Wi-Fi切换到蜂窝时，会触发该事件。
    netConnection.on('netConnectionPropertiesChange', (data: connection.NetConnectionPropertyInfo) => {
      hsLog.i(TAG,
        "NetType :" + netType + ", network netConnectionPropertiesChange " + JSON.stringify(data));
      this.postEvent(NetworkEventName.NetConnectionPropertiesChange, data, netType);
    });

    //订阅网络丢失事件
    hsLog.d(TAG, '订阅网络丢失事件-->')
    netConnection.on('netLost', (data: connection.NetHandle) => {
      hsLog.i(TAG, 'netLost：' + JSON.stringify(data))
      this.isNetworkAvailable = false
      this.currentNetType = netType
      this.postEvent(NetworkEventName.NetLost, true, netType)

    })

    //订阅网络不可用事件
    hsLog.d(TAG, '订阅网络不可用事件-->')
    netConnection.on('netUnavailable', () => {
      hsLog.i(TAG, 'netUnavailable')
      this.isNetworkAvailable = false
      this.currentNetType = netType
      this.postEvent(NetworkEventName.NetUnavailable, true, netType);
    })

    //检查默认数据网络是否已激活
    let hasDefaultNet = connection.hasDefaultNetSync()
    if (hasDefaultNet) {
      hsLog.i(TAG, 'hasDefaultNetSync  ' + hasDefaultNet)
      this.isNetworkAvailable = true
      //获得默认网络类型
      this.getDefaultNetSync()
    }

    this.connectionMap.set(netType, netConnection);
  }

  /**
   * WI-FI状态监听
   */
  wifiStateObserve() {
    // 注册WLAN状态改变事件
    // 0，未激活；1，已激活；2，激活中；3：去激活中
    wifiManager.on("wifiStateChange", (result: number) => {
      hsLog.i(TAG, "wifiStateChange: " + result);
      this.isNetworkAvailable = false
      this.currentNetType = connection.NetBearType.BEARER_WIFI
      this.postEvent(NetworkEventName.WifiStateChange, result,connection.NetBearType.BEARER_WIFI);
    });
    // 注册WLAN连接状态改变事件
    // 0，已断开；1，已连接
    wifiManager.on("wifiConnectionChange", (result: number) => {
      hsLog.i(TAG,  "wifiConnectionChange: " + result);
      this.isNetworkAvailable = result ? true : false
      this.currentNetType = connection.NetBearType.BEARER_WIFI
      this.postEvent(NetworkEventName.WifiConnectionChange, result,connection.NetBearType.BEARER_WIFI);
    });
  }

  /**
   * 解析网络监听结果，用于打印日志
   * @param data  网络监听结果
   * @returns 解析后的结果数据
   */
  parseResult(data: emitter.EventData): string {
    if (data.data) {
      if (!data.data.eventName) {
        hsLog.i(TAG,"parseResult data.data.eventName is undefined.")
        return "";
      }
    } else {
      hsLog.i(TAG,"parseResult data.data is undefined.")
      return "";
    }
    let result = "";
    let name: number = (data.data)!.eventName ?? -1;
    switch (name) {
      case NetworkEventName.NetObserverRegister.valueOf():
        result = "NetObserverRegister";
        break;
      case NetworkEventName.NetAvailable.valueOf():
        result = "NetAvailable";
        break;
      case NetworkEventName.NetBlock.valueOf():
        result = "NetBlock";
        break;
      case NetworkEventName.NetLost.valueOf():
        result = "NetLost";
        break;
      case NetworkEventName.NetCapabilitiesChange.valueOf():
        result = "NetCapabilitiesChange";
        break;
      case NetworkEventName.NetUnavailable.valueOf():
        result = "NetUnavailable";
        break;
      case NetworkEventName.NetConnectionPropertiesChange.valueOf():
        result = "NetConnectionPropertiesChange";
        break;
      case NetworkEventName.WifiStateChange.valueOf():
        result = "WifiStateChange";
        break;
      case NetworkEventName.WifiConnectionChange.valueOf():
        result = "WifiConnectionChange";
        break;
      case NetworkEventName.WeakNet.valueOf():
        result = "WeakNet";
        break;
      default:
        result = name.toString();
        break
    }

    let netTemp: string = "";
    let temp: number = data.data!.netType ?? -1;
    if (temp === 1) {
      netTemp = "WIFI";
    }
    if (temp === 0) {
      netTemp = "CELLULAR";
    }
    if (temp === -1) {
      netTemp = temp.toString();
    }

    result = result + "------" + (data.data!.status ?? -1) + "------" + netTemp;

    return result;
  }

  /**
   * 判断是否是弱网环境
   */
  sceneChangeObserve() {
    try {
      netQuality.on('netSceneChange', (list: Array<netQuality.NetworkScene>) => {
        if (list.length > 0) {
          list.forEach((networkScene) => {
            // 回调信息处理
            hsLog.i(TAG,`Succeeded receive netSceneChange info`);
            if (networkScene.scene == 'weakSignal' || networkScene.scene == 'congestion') {
              // 表示为弱网场景
              hsLog.i(`The current network is weak`);
              // this.postEvent(NetworkEventName.WeakNet, true)
            } else {
              // this.postEvent(NetworkEventName.WeakNet, false)
            }
          });
        }
      });
    } catch (err) {
      hsLog.e(TAG,'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }
}


