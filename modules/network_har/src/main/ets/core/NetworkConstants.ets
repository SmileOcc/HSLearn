import { connection } from "@kit.NetworkKit";
import { NetEventData } from "./NetEventData";


/**
 * 网络连接状态变化回调函数的类型定义
 */
export type NetworkStatusCallback = (netEventData: NetEventData) => void;

/**
 * 枚举：承载类型（内部使用）
 * 与具体平台的API对接，用于标识网络连接的承载类型
 */
enum BearerType {
  MOBILE = 0,
  WIFI = 1,
  // ... 其他可能的承载类型，根据平台API添加
  ETHERNET = 3
}
