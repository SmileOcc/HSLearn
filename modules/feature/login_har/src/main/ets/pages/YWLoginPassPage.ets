
import { globalThis, YWNavRouterUtils } from '@learn/common_har';
import { YWLoading } from '@learn/loading_har';
import { YWTipDialog } from '@learn/alert_har';
import { YWCommonButton, YWNavBar, YWSpringLayout } from '@learn/baseui_har';
import { YWPrivacyCheckbox } from '../view/YWPrivacyCheckbox'

import {  YWResColor } from '@learn/res_har';
import { API, netReq } from '@learn/request_har';
import { YWLoginManager } from '../core/YWLoginManager';
import { YWLoginWay } from '../core/YWLoginWay';
import { loginComponentManager } from '@kit.AccountKit';
import { YWWelcome } from '../view/YWWelcome';
import { hsLog } from '@learn/logger_har';

const TAG = 'YWLoginPassPage';

@Preview
@Component
export struct YWLoginPassPage {
  @StorageProp('bottomHeight') bottomHeight: number = 0; //导航栏高度（单位：vp）
  @State account: string = '';
  @State password: string = '';
  @State isCheckboxSelected: boolean = false;
  @State unselectAnimalCount: number = 0;
  @State texts: loginComponentManager.PrivacyText[] = [{
    text: '已阅读并同意',
    type: loginComponentManager.TextType.PLAIN_TEXT
  }, {
    text: '《用户服务协议》',
    tag: API.agreement,
    type: loginComponentManager.TextType.RICH_TEXT
  }, {
    text: '和',
    type: loginComponentManager.TextType.PLAIN_TEXT
  }, {
    text: '《隐私协议》',
    tag: API.privacy,
    type: loginComponentManager.TextType.RICH_TEXT
  }, {
    text: '。',
    type: loginComponentManager.TextType.PLAIN_TEXT
  }];

  build() {
    NavDestination() {
      Column() {
        YWNavBar({
          title: '',
          onKeyBack: globalThis.blockQuickClick(() => {
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
  layout() {
    Column() {
      YWWelcome()

      Column() {
        TextInput({ placeholder: '请输入您的账号' })
          .onSubmit((EnterKeyType) => {
            hsLog.i(TAG, EnterKeyType + '输入法回车键的类型值')
          })
          .onChange((value: string) => {
            this.account = value;
          })
        TextInput({ placeholder: '请输入您的密码' }).type(InputType.Password).margin({ top: 20 })
          .onSubmit((EnterKeyType) => {
            hsLog.i(TAG, EnterKeyType + '输入法回车键的类型值')
          })
          .onChange((value: string) => {
            this.password = value;
          })
      }.margin({ top: 40 })


      Column() {
        YWCommonButton({
          text: '登录', click: () => {
            if (this.account === '') {
              showErrorDialog('请输入账户');
              return;
            }
            if (this.password === '') {
              showErrorDialog('请输入密码');
              return;
            }
            if (!this.isCheckboxSelected) {
              this.unselectAnimalCount++; //触发动画
              return;
            }
            YWLoading.open();
            netReq.post<Record<string, string>, Record<string, string>>(API.login,
              { 'authType': 'password', 'account': this.account, 'password': this.password }, {
                onSuccess: (data: Record<string, string>) => {
                  hsLog.i(TAG, '数据回调：' + JSON.stringify(data));
                  YWLoginManager.getInstance().setLogin(true);
                  YWLoginManager.getInstance().saveLoginWay(YWLoginWay.PASSWORD);
                  YWNavRouterUtils.popHome();
                },
                onFail: (code: number, message: string) => {
                  hsLog.i(TAG, '数据回调：' + code + ' | ' + message);
                  showErrorDialog(message);
                },
                onFinally: () => {
                  YWLoading.close();
                }
              })
          }
        })


        YWCommonButton({
          text: '第三方登录', isLight: false, click: () => {
            YWLoginManager.getInstance().gotoLoginPage(YWLoginWay.HUAWEI, true);
          }
        })
          .margin({ top: 12 })

        YWPrivacyCheckbox({
          texts: this.texts,
          isCheckboxSelected: this.isCheckboxSelected,
          unselectAnimalCount: this.unselectAnimalCount
        })
          .margin({ top: 20 })
      }.margin({ top: 35 })
    }.padding({ left: 16, right: 16 })
  }
}


function showErrorDialog(message: string) {
  YWTipDialog.open({
    content: message,
    showNo: false
  })
}


@Builder
export function RegisterBuilder(): void {
  YWLoginPassPage();
}