import { LibNetworkStatus } from "./core/LibNetworkStatus";
import { NetworkStatusCallback } from "./core/NetworkConstants";
import { connection } from "@kit.NetworkKit";
import { NetworkEventData } from "./core/EmmitterData";
import { emitter } from "@kit.BasicServicesKit";

export class HSRegisterNetworkListener {
  private constructor() {}

  static register(): void {
    // 开启蜂窝网络和WI-FI网络状态的监听
    LibNetworkStatus.getInstance().registerNetConnectListener(connection.NetBearType.BEARER_CELLULAR, connection.NetBearType.BEARER_WIFI)
  }

  static getEmitterEvent(): NetworkEventData {
    return LibNetworkStatus.getInstance().getEmitterEvent()
  }

  static parseResult(data: emitter.EventData): string {
    return LibNetworkStatus.getInstance().parseResult(data)
  }

  static isCheckNetworkAvailable(): boolean {
    return LibNetworkStatus.getInstance().isCheckNetworkAvailable()
  }

  static getCurrentNetworkStatus(): connection.NetBearType  {
    return LibNetworkStatus.getInstance().getCurrentNetworkType()
  }

  static addCallback(callback: NetworkStatusCallback, isCallBackCurrentNetworkStatus: boolean): void {
    return LibNetworkStatus.getInstance().addCallback(callback, isCallBackCurrentNetworkStatus)
  }

  static removeCallback(callback: NetworkStatusCallback): void {
    return LibNetworkStatus.getInstance().removeCallback(callback)
  }
}