import { NetworkStatusCallback, NetworkType } from "./core/NetworkConstants";

export interface HSLibNetworkStatusProxy {
  registerNetConnectListener(): void;

  isCheckNetworkAvailable(): boolean;

  getCurrentNetworkStatus(): NetworkType;

  addCallback(callback: NetworkStatusCallback, isCallBackCurrentNetworkStatus: boolean): void;

  removeCallback(callback: NetworkStatusCallback): void;
}