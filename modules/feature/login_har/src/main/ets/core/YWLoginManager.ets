/*
 * @Desc: 这是只对内部 login 模块的管理
 */
import { YWLoginService } from './YWLoginService';
import { AxiosError, AxiosResponse } from '@ohos/axios';
import { PreferencesUtil, YWNavRouterUtils } from '@learn/common_har';
import { API, netReq } from '@learn/request_har';
import { YWTipDialog } from '@learn/alert_har';
import { YWLoading } from '@learn/loading_har'
import { YWLoginWay } from './YWLoginWay';
import { hsLog } from '@learn/logger_har';

const TAG = 'YWLoginManager';

export class YWLoginManager implements YWLoginService {
  private static instance: YWLoginManager;
  private hasLogin: boolean = false;

  private constructor() {
    this.init();
  }

  private init() {
    netReq.onResponseIntercept((response: AxiosResponse) => {
      const code: number = response.data['code'] as number;
      if (401 === code) {
        AppStorage.setOrCreate('isLogin', false);
        netReq.axios().defaults.headers.common['Cookie'] = '';
        PreferencesUtil.put('Cookie', '');
        return response;
      }
      if (response.config.url && API.login.includes(response.config.url) && code === 1) { //处理登录cookie
        hsLog.i(TAG, '登录cookie onResponseIntercept: ' + JSON.stringify(response));
        let cookies = response.headers['set-cookie'];
        if (cookies === undefined || cookies.length === 0) {
          return response;
        }
        let cookie = cookies.pop();
        if (cookie === undefined) {
          return response;
        }
        netReq.axios().defaults.headers.common['Cookie'] = cookie;
        PreferencesUtil.put('Cookie', cookie); //TODO - 未处理多个cookie
        hsLog.i(TAG, '成功设置登录cookie: ' + cookie);
      }

      return response;
    });
    netReq.onErrorIntercept((error: AxiosError) => {
      if (error.code && error.code.includes('401')) { //session过期
        hsLog.i(TAG, '登录失效 onErrorIntercept: ' + JSON.stringify(error.message));
        this.setLogin(false);
      }
      return error;
    })
  }

  static getInstance() {
    if (!YWLoginManager.instance) {
      YWLoginManager.instance = new YWLoginManager();
    }
    return YWLoginManager.instance;
  }

  async getCookie(): Promise<string> {
    const localCookie = await PreferencesUtil.get<string>('Cookie', '');
    this.setLogin(localCookie !== '');
    return localCookie;
  }

  isLogin(): boolean {
    return this.hasLogin;
  }

  login(): void {
    //当登录成功后，记录 YWLoginWay ，用户调用登录时自动切换
    PreferencesUtil.getCall<string>('YWLoginWay', YWLoginWay.HUAWEI, (lastLongWay: string) => {
      YWNavRouterUtils.push(lastLongWay,undefined,(info)=>{
        hsLog.i(`info ==== ${info}`)
      });
    });
  }

  logout(): void {
    YWLoading.open();
    netReq.postNotBody<void>(API.logout, {
      onSuccess: () => {
        hsLog.i(TAG, '登出成功...');
        this.setLogin(false);
      },
      onFail: (code: number, message: string) => {
        hsLog.i(TAG, '数据回调：' + code + ' | ' + message);
        YWTipDialog.open({
          content: message,
          showNo: false
        })
      },
      onFinally: () => {
        YWLoading.close();
      }
    })
  }

  /**
   * 设置登录状态并进行通知
   * @param login
   */
  setLogin(login: boolean) {
    this.hasLogin = login;
    //全局通知 UI 更改登录状态
    AppStorage.setOrCreate('isLogin', login);
    if (!login) {
      PreferencesUtil.put('Cookie', '');
    }
  }

  /**
   * 记录上次登录状态
   * @param YWLoginWay
   */
  saveLoginWay(loginWay: YWLoginWay) {
    PreferencesUtil.put('YWLoginWay', loginWay)
  }

  /**
   * 去哪个页面登录
   * @param YWLoginWay
   */
  gotoLoginPage(loginWay: YWLoginWay, replace: boolean = false) {
    if (replace) {
      YWNavRouterUtils.replace(loginWay);
    } else {
      YWNavRouterUtils.push(loginWay);
    }
  }
}
