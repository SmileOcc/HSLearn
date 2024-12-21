/*
 * @Desc: 对外部开放：登录的各种状态和数据进行管理
 */
import { YWLoginManager } from './YWLoginManager';

export interface YWLoginService {
  /**
   * 判断当前是否已经登录
   * @returns
   */
  isLogin(): boolean;

  /**
   * 去登录，根据当前的信息判断去哪个页面登录？
   */
  login(): void;

  /**
   * 退出登录，调用登出接口，清除 cookie 等
   */
  logout(): void;

  /**
   * 获取本地 cookie
   * @returns
   */
  getCookie(): Promise<string>
}


/**
 * 对外导出，其他模块可以使用的接口
 */
export const loginService: YWLoginService = YWLoginManager.getInstance();