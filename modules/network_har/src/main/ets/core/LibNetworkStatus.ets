import { NetworkStatusCallback, NetworkType } from './NetworkConstants';
import { connection } from '@kit.NetworkKit'; //网络连接
import { hsLog } from '@learn/logger_har';
import { HSLibNetworkStatusProxy } from '../HSLibNetworkStatusProxy';

const TAG = "LibNetworkStatus"

export class LibNetworkStatus implements HSLibNetworkStatusProxy {
  /**
   * LibNetworkStatus单例实例
   * 保证全局只有一个网络管理类实例
   */
  private constructor() {
  }

  private static instance: LibNetworkStatus;

  public static getInstance(): LibNetworkStatus {
    if (!LibNetworkStatus.instance) {
      LibNetworkStatus.instance = new LibNetworkStatus();
    }
    return LibNetworkStatus.instance;
  }

  /**
   * 当前网络状态
   * 存储当前的网络连接状态
   */
  private currentNetworkStatus: NetworkType = NetworkType.STATE_NULL;
  /**
   * 网络是否可用
   * 标识当前是否有可用的网络连接
   */
  private isNetworkAvailable: boolean = false;
  /**
   * 鸿蒙网络连接对象
   * 用于与鸿蒙系统的网络API进行交互
   */
  private networkConnection?: connection.NetConnection;
  /**
   * 存储网络连接状态变化回调函数的集合
   * 当网络状态发生变化时，会遍历此集合并调用相应的回调函数
   */
  private callbacks: Set<NetworkStatusCallback> = new Set();

  // 类的构造函数、方法以及其他逻辑实现将在这里继续...

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
      callback(this.currentNetworkStatus);
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
  callbackNetworkStatus(): void {
    if (!this.callbacks || this.callbacks.size === 0) {
      return;
    }

    // 遍历所有注册的回调方法，并调用它们，传递当前网络状态
    this.callbacks.forEach(callback => {
      callback(this.currentNetworkStatus);
    });
  }


  /**
   * 检查当前网络是否可用
   *
   * @returns 返回一个布尔值，指示当前网络是否可用
   */
  isCheckNetworkAvailable(): boolean {
    return this.isNetworkAvailable;
  }

  /**
   * 获取当前的网络状态
   *
   * @returns 返回当前的网络状态码
   */
  getCurrentNetworkStatus(): NetworkType {
    return this.currentNetworkStatus;
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
      let capabilities = connection.getNetCapabilitiesSync(netHandle)
      hsLog.i(TAG, 'getNetCapabilitiesSync：' + JSON.stringify(capabilities))
      if (capabilities && capabilities.bearerTypes && capabilities.bearerTypes.length > 0) {

        // 获取第一个承载类型
        const bearerType: connection.NetBearType = capabilities.bearerTypes[0];
        // 根据承载类型判断网络类型
        switch (bearerType) {
          case connection.NetBearType.BEARER_CELLULAR:
            // 蜂窝网络

            this.currentNetworkStatus = NetworkType.MOBILE;
            break;
          case connection.NetBearType.BEARER_WIFI:
            // Wi-Fi网络

            this.currentNetworkStatus = NetworkType.WIFI;
            break;
          case connection.NetBearType.BEARER_ETHERNET:
            // 以太网网络（通常移动设备不支持，但为完整性保留）

            this.currentNetworkStatus = NetworkType.ETHERNET;
            break;
          case connection.NetBearType.BEARER_VPN:
            this.currentNetworkStatus = NetworkType.VPN;
            break;
          case connection.NetBearType.BEARER_BLUETOOTH:
            this.currentNetworkStatus = NetworkType.BLUETOOTH;
            break;
          default:
          // 未知网络类型

            this.currentNetworkStatus = NetworkType.UNKNOWN;
            break;
        }

      }
    }
  }

  /**
   * 注册网络状态监听：
   * 设备从无网络到有网络会触发"netAvailable"、"netCapabilitiesChange"、"netConnectionPropertiesChange"事件；
   * 设备从有网络到无网络会触发"netLost"事件
   * 设备从wifi到蜂窝网络会触发"netLost"事件（wifi不可用）、之后触发"netAvailable"事件（蜂窝可用）
   */
  registerNetConnectListener() {
    if (this.networkConnection) {
      hsLog.i(TAG, '已订阅网络事件，无需再次订阅')
      return
    }

    //创建NetConnection对象
    this.networkConnection = connection.createNetConnection()


    //注册
    this.networkConnection.register((error) => {
      if (error) {
        hsLog.i(TAG, 'networkConnection.register failure: ' + JSON.stringify(error))
      } else {
        hsLog.i(TAG, ' networkConnection.register success')
      }
    })

    //订阅网络可用事件
    hsLog.d(TAG, '订阅网络可用事件-->')
    this.networkConnection.on('netAvailable', (data: connection.NetHandle) => {
      hsLog.i(TAG, 'netAvailable：' + JSON.stringify(data))
      this.isNetworkAvailable = true

      //获得默认网络类型
      this.getDefaultNetSync()

      //回调网络状态
      this.callbackNetworkStatus()
    })

    //订阅网络丢失事件
    hsLog.d(TAG, '订阅网络丢失事件-->')
    this.networkConnection.on('netLost', (data: connection.NetHandle) => {
      hsLog.i(TAG, 'netLost：' + JSON.stringify(data))
      this.isNetworkAvailable = false
      this.currentNetworkStatus = NetworkType.STATE_NULL

      //回调网络状态
      this.callbackNetworkStatus()
    })

    //订阅网络不可用事件
    hsLog.d(TAG, '订阅网络不可用事件-->')
    this.networkConnection.on('netUnavailable', () => {
      hsLog.i(TAG, 'netUnavailable')
      this.isNetworkAvailable = false
      this.currentNetworkStatus = NetworkType.STATE_NULL

      //回调网络状态
      this.callbackNetworkStatus()
    })

    //判断默认网络状态
    let hasDefaultNet = connection.hasDefaultNetSync()
    if (hasDefaultNet) {
      hsLog.i(TAG, 'hasDefaultNetSync  ' + hasDefaultNet)
      this.isNetworkAvailable = true
      //获得默认网络类型
      this.getDefaultNetSync()
    }
  }
}
