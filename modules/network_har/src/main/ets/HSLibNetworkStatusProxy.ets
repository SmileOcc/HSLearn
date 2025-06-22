import { NetworkStatusCallback } from "./core/NetworkConstants";
import { connection } from "@kit.NetworkKit";
import { NetworkEventData } from "./core/EmmitterData";
import { emitter } from "@kit.BasicServicesKit";

export interface HSLibNetworkStatusProxy {
  registerNetConnectListener(...netType: connection.NetBearType[]): void;

  getEmitterEvent(): NetworkEventData

  parseResult(data: emitter.EventData): string

  isCheckNetworkAvailable(): boolean;

  getCurrentNetworkType(): connection.NetBearType;

  addCallback(callback: NetworkStatusCallback, isCallBackCurrentNetworkStatus: boolean): void;

  removeCallback(callback: NetworkStatusCallback): void;
}