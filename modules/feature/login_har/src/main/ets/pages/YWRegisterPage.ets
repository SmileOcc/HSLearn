
import { YWNavBar } from '@learn/baseui_har';
import { YWLoading } from '@learn/loading_har'
import { YWTipDialog } from '@learn/alert_har'
import { YWNavRouterUtils } from '@learn/common_har';
import { API, netReq } from '@learn/request_har';
import { hsLog } from '@learn/logger_har';

const TAG = 'YWRegisterPage';

@Component
export struct YWRegisterPage {
  @State data: String = '';

  build() {
    NavDestination() {
      Column() {
        YWNavBar({
          title: '注册',
          onKeyBack: () => {
            YWNavRouterUtils.pop()
          },
        })
        Button('测试登录').onClick(() => {
          YWLoading.open();
          netReq.post<Record<string, string>, Record<string, string>>(API.login,
            {
              'authType': 'password',
              'account': 'qincji',
              'password': 'abcd1234'
            }, {
              onSuccess: (data: Record<string, string>) => {
                hsLog.i(TAG, '数据回调：' + JSON.stringify(data));
                AppStorage.setOrCreate('isLogin', true);
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
                YWNavRouterUtils.popHome();
              }
            })
        })
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.data = JSON.stringify(context.pathInfo);
    })
  }
}

@Builder
export function RegisterBuilder(): void {
  YWRegisterPage();
}

