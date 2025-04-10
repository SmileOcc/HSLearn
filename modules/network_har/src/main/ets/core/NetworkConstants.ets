/**
 * 网络连接状态变化回调函数的类型定义
 */
export type NetworkStatusCallback = (status: NetworkType) => void;

/**
 * 枚举：网络类型
 * 用于标识当前的网络连接状态
 */
export enum NetworkType {
  STATE_NULL = 'NULL', // 表示未联网状态
  UNKNOWN = 'UNKNOWN', // 未知网络类型
  MOBILE = 'MOBILE',   // 移动网络
  WIFI = 'WIFI',       // Wi-Fi网络
  ETHERNET = 'ETHERNET', // 以太网网络（尽管移动设备通常不支持，但为完整性保留）
  VPN = 'VPN',
  BLUETOOTH = 'BLUETOOTH'
}

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
