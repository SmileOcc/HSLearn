/*
 * @Desc: 页面：登录
 */
import { loginComponentManager, LoginWithHuaweiIDButton } from '@kit.AccountKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import { hsGlobalThis, YWNavRouterUtils } from '@learn/common_har';
import { API, netReq } from '@learn/request_har';

import { YWCommonButton, YWNavBar, YWSpringLayout } from '@learn/baseui_har'
import { YWResColor } from '@learn/res_har'
import { YWLoading } from '@learn/loading_har'
import { YWTipDialog } from '@learn/alert_har'
import { YWPrivacyCheckbox } from '../view/YWPrivacyCheckbox'
import { YWLoginManager } from '../core/YWLoginManager';
import { YWLoginWay } from '../core/YWLoginWay';
import { YWWelcome } from '../view/YWWelcome';
import { hsLog } from '@learn/logger_har';

const TAG = 'YWLoginPage';

// @Entry
@Component
export struct YWLoginThirdPage {
  @StorageProp('bottomHeight') bottomHeight: number = 0; //导航栏高度（单位：vp）
  // 是否勾选协议
  @State @Watch('onCheckboxChange') isCheckboxSelected: boolean = false;
  @State unselectAnimalCount: number = 0;
  @State texts: loginComponentManager.PrivacyText[] = [{
    text: '已阅读并同意',
    type: loginComponentManager.TextType.PLAIN_TEXT
  }, {
    text: '《用户服务协议》',
    tag: API.agreement,
    type: loginComponentManager.TextType.RICH_TEXT
  }, {
    text: '《隐私协议》',
    tag: API.privacy,
    type: loginComponentManager.TextType.RICH_TEXT
  }, {
    text: '和',
    type: loginComponentManager.TextType.PLAIN_TEXT
  }, {
    text: '《华为账号用户认证协议》',
    tag: 'https://privacy.consumer.huawei.com/legal/id/authentication-terms.htm?code=CN&language=zh-CN',
    type: loginComponentManager.TextType.RICH_TEXT
  }, {
    text: '。',
    type: loginComponentManager.TextType.PLAIN_TEXT
  }];
  // 构造LoginWithHuaweiIDButton组件的控制器。
  controller: loginComponentManager.LoginWithHuaweiIDButtonController =
    new loginComponentManager.LoginWithHuaweiIDButtonController()
      /**
       * 当应用使用自定义的登录页时，如果用户未同意协议，需要设置协议状态为NOT_ACCEPTED，当用户同意协议后再设置
       * 协议状态为ACCEPTED，才可以使用华为账号一键登录功能。
       */
      .setAgreementStatus(loginComponentManager.AgreementStatus.NOT_ACCEPTED)
      .onClickLoginWithHuaweiIDButton((error: BusinessError, response: loginComponentManager.HuaweiIDCredential) => {
        this.handleLoginWithHuaweiIDButton(error, response);
      })
      .onClickEvent((error: BusinessError, clickEvent: loginComponentManager.ClickEvent) => {
        if (error) {
          this.dealAllError(error);
          return;
        }
        hsLog.i(TAG, `onClickEvent clickEvent: ${clickEvent}`);
      });

  onCheckboxChange() {
    this.controller.setAgreementStatus(this.isCheckboxSelected
      ? loginComponentManager.AgreementStatus.ACCEPTED
      : loginComponentManager.AgreementStatus.NOT_ACCEPTED);
  }

  // Toast提示
  showToast(resource: string) {
    try {
      promptAction.showToast({
        message: resource,
        duration: 2000
      });
    } catch (error) {
      let message = (error as BusinessError).message
      let code = (error as BusinessError).code
      hsLog.e(TAG, `showToast args error code is ${code}, message is ${message}`);
    }
  }

  handleLoginWithHuaweiIDButton(error: BusinessError | undefined,
    response: loginComponentManager.HuaweiIDCredential) {
    if (error) {
      hsLog.e(TAG,
        `Failed to click LoginWithHuaweiIDButton. Code is ${error.code}, message is ${error.message}`);
      if (error.code === ErrorCode.ERROR_CODE_NETWORK_ERROR) {
        AlertDialog.show(
          {
            message: "网络未连接，请检查网络设置。",
            offset: { dx: 0, dy: -12 },
            alignment: DialogAlignment.Bottom,
            autoCancel: false,
            confirm: {
              value: "知道了",
              action: () => {
              }
            }
          }
        );
      } else if (error.code === ErrorCode.ERROR_CODE_AGREEMENT_STATUS_NOT_ACCEPTED) {
        // 未同意协议，弹出协议弹框，推荐使用该回调方式
        this.unselectAnimalCount++; //弹出动画
      } else if (error.code === ErrorCode.ERROR_CODE_LOGIN_OUT) {
        // 华为账号未登录提示
        this.showToast("华为账号未登录，请重试")
      } else if (error.code === ErrorCode.ERROR_CODE_NOT_SUPPORTED) {
        // 不支持该scopes或permissions提示
        this.showToast("该scopes或permissions不支持");
      } else {
        // 其他提示系统或服务异常
        this.showToast('服务或网络异常，请稍后重试');
      }
      return;
    }
    try {
      if (this.isCheckboxSelected) {
        if (response) {
          hsLog.i(TAG, 'Succeed in clicking LoginWithHuaweiIDButton.');
          // 开发者根据实际业务情况使用以下信息
          let authCode = response.authorizationCode;
          let openID = response.openID;
          let unionID = response.unionID;
          let idToken = response.idToken;
          hsLog.i(TAG, `Success：authCode=${authCode},openID=${openID},unionID=${unionID},idToken=${idToken}`)
          YWLoading.open();
          netReq.post<Record<string, string>, Record<string, string>>(API.login,
            { 'authType': 'huawei', 'account': unionID, 'password': authCode }, {
              onSuccess: (data: Record<string, string>) => {
                hsLog.i(TAG, '数据回调：' + JSON.stringify(data));
                YWLoginManager.getInstance().setLogin(true);
                YWLoginManager.getInstance().saveLoginWay(YWLoginWay.HUAWEI);
                YWNavRouterUtils.popHome();
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
      } else {
        //提示同意隐私政策
        this.unselectAnimalCount++;
      }
    } catch (err) {
      hsLog.e(TAG,
        `Failed to LoginWithHuaweiIDButton, errCode: ${err.code}, errMessage: ${err.message}`);
      AlertDialog.show(
        {
          message: '服务或网络异常，请稍后重试',
          offset: { dx: 0, dy: -12 },
          alignment: DialogAlignment.Bottom,
          autoCancel: false,
          confirm: {
            value: '知道了',
            action: () => {
            }
          }
        }
      );
    }
  }

  build() {
    NavDestination() {
      Column() {
        YWNavBar({
          title: '',
          onKeyBack: hsGlobalThis.blockQuickClick(() => {
            YWNavRouterUtils.pop();
          })
        })
        YWSpringLayout({
          layout: () => {
            this.layout()
          }
        })
          .height('auto')
          .layoutWeight(1)
        Line().height(this.bottomHeight).width(1).visibility(Visibility.Hidden)
      }
      .height('100%')
      .backgroundColor(YWResColor.bgBase())
      .justifyContent(FlexAlign.Start)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)

  }

  @Builder
  private layout(): void {
    Column() {
      YWWelcome()

      Column() {
        LoginWithHuaweiIDButton({
          params: {
            // LoginWithHuaweiIDButton支持的样式。
            style: loginComponentManager.Style.BUTTON_CUSTOM,
            // LoginWithHuaweiIDButton的边框圆角半径。
            borderRadius: 24,
            // LoginWithHuaweiIDButton支持的登录类型。
            loginType: loginComponentManager.LoginType.QUICK_LOGIN,
            // LoginWithHuaweiIDButton支持按钮的样式跟随系统深浅色模式切换。
            supportDarkMode: true,
            // verifyPhoneNumber：如果华为账号用户在过去90天内未进行短信验证，是否拉起Account Kit提供的短信验证码页面。
            verifyPhoneNumber: true,
            customButtonParams: { backgroundColor: YWResColor.themeLight() }
          },
          controller: this.controller
        })
      }
      .height(40)
      .width('100%')
      .margin({ top: 80 })

      YWCommonButton({
        text: '密码登录', isLight: false, click: () => {
          YWLoginManager.getInstance().gotoLoginPage(YWLoginWay.PASSWORD, true);
        }
      }).margin({ top: 12 })

      YWPrivacyCheckbox({
        texts: this.texts,
        isCheckboxSelected: this.isCheckboxSelected,
        unselectAnimalCount: this.unselectAnimalCount,
      })
        .margin({ top: 20 })
    }
    .constraintSize({ minHeight: '100%' })
    .padding({
      left: 16,
      right: 16
    })
  }

  // 错误处理
  dealAllError(error: BusinessError): void {
    hsLog.e(TAG, `Failed to auth, errorCode=${error.code}, errorMsg=${error.message}`);
  }
}

export enum ErrorCode {
  ERROR_CODE_NETWORK_ERROR = 1001502005,
  ERROR_CODE_AGREEMENT_STATUS_NOT_ACCEPTED = 1005300001,
  ERROR_CODE_LOGIN_OUT = 1001502001,
  ERROR_CODE_NOT_SUPPORTED = 1001500003
}


@Builder
export function RegisterBuilder(): void {
  YWLoginThirdPage();
}