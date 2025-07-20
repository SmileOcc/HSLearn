import { connection } from "@kit.NetworkKit";

export type NetworkData = boolean | connection.NetBlockStatusInfo | connection.NetBearType
  | connection.NetConnectionPropertyInfo | connection.NetCapabilityInfo;

// 网络监听emitter事件
export enum NetworkEventName {
  // 注册网络监听订阅事件
  NetObserverRegister,
  // 网络可用
  NetAvailable,
  // 网络阻塞
  NetBlock,
  // 网络丢失/断开
  NetLost,
  // 当网络能力变化时，如网络从无网络到有网络、从4G切换到5G
  NetCapabilitiesChange,
  // 网络不可用
  NetUnavailable,
  // WIFI状态改变
  WifiStateChange,
  // WIFI连接状态改变
  WifiConnectionChange,
  // 弱网
  WeakNet,
  // 订阅网络连接信息变化事件，当网络连接信息变化时，如从无网络到有网络、从Wi-Fi切换到蜂窝
  NetConnectionPropertiesChange
}

export class NetEventData {
  eventName: NetworkEventName;
  status: NetworkData;
  netType: connection.NetBearType;

  constructor(eventName: NetworkEventName, status: NetworkData, netType: connection.NetBearType) {
    this.eventName = eventName;
    this.status = status;
    this.netType = netType;
  }

  hasConnect(): boolean {
    if (this.eventName == NetworkEventName.NetLost || this.eventName == NetworkEventName.NetUnavailable) {
      return false
    }
    return true
  }
}