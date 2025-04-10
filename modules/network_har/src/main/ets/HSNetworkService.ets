import { LibNetworkStatus } from "./core/LibNetworkStatus";
import { NetworkStatusCallback, NetworkType } from "./core/NetworkConstants";

export class HSRegisterNetworkListener {
  private constructor() {}

  static register(): void {
    LibNetworkStatus.getInstance().registerNetConnectListener()
  }

  static isCheckNetworkAvailable(): boolean {
    return LibNetworkStatus.getInstance().isCheckNetworkAvailable()
  }

  static getCurrentNetworkStatus(): NetworkType {
    return LibNetworkStatus.getInstance().getCurrentNetworkStatus()
  }

  static addCallback(callback: NetworkStatusCallback, isCallBackCurrentNetworkStatus: boolean): void {
    return LibNetworkStatus.getInstance().addCallback(callback, isCallBackCurrentNetworkStatus)
  }

  static removeCallback(callback: NetworkStatusCallback): void {
    return LibNetworkStatus.getInstance().removeCallback(callback)
  }
}