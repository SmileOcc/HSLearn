import { notificationManager } from "@kit.NotificationKit"
import { Ability, common, wantAgent, WantAgent } from "@kit.AbilityKit"
import { BusinessError } from "@kit.BasicServicesKit"
import { hsLog } from "@learn/logger_har"
import { pushCommon, pushService, serviceNotification } from "@kit.PushKit"
import { HSExtraData } from "./HSExtraData"
import { promptAction } from "@kit.ArkUI"

const TAG = "HSNotification"
// 本地通知发布通道
class HSNotification {
  context?: common.UIAbilityContext
  private curr_id: number = 1
  private pushToken?: string

  constructor() {}
  initContext(context: common.UIAbilityContext, ability: Ability) {
    this.context = context
    this.receiveMessage(ability)
    this.reqPushToken()


  }

  getToken(): string | undefined {
    return this.pushToken
  }

  private async reqPushToken(): Promise<void> {
    try {
      this.pushToken = await pushService.getToken();
      hsLog.i(TAG,`Get push token successfully: ${this.pushToken}`);
      // TODO: please send the pushToken to your application server
    } catch (e) {
      const err: BusinessError = e;
      hsLog.e(TAG,`Failed to get push token: ${err.code} ${err.message}`);
    }
  }

  async getPushToken(success: (token: string) => void) {
    pushService.getToken().then((data: string) => {
      this.pushToken = data
      success(data);
      hsLog.i(TAG,'Succeeded in getting push token:', data);
    }).catch((err: BusinessError) => {
      hsLog.e(TAG,`Failed to get push token: ${err.code} ${err.message}`);
    });
  }

  // 删除Push Token后，本应用下的所有Push Kit历史数据会一并删除
  async myDeletePushToken() {
    try {
      await pushService.deleteToken();
      hsLog.i(TAG, 'Succeeded in deleting push token');
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      hsLog.e(TAG,`Failed to delete push token: ${e.code} ${e.message}`);
    }
  }

  isNotificationEnabledSync() {
    return notificationManager.isNotificationEnabledSync()
  }

  checkNotificationEnabled(isShowToast?: boolean) {
    // 请求通知授权
    notificationManager.isNotificationEnabled()
      .then((data) => {
        // data为true表示已经授权过通知
        if (data) return
        // 弹窗让用户选择是否允许发送通知
        isShowToast && notificationManager.requestEnableNotification(this.context)
      })
  }

  /**
   * 校验是否已授权通知服务
   * @param callBack  回调函数
   * @returns
   */
  async authorizeNotification(callBack: (grant: boolean) => void): Promise<void> {
    let isAuth = await notificationManager.isNotificationEnabled(); //获取通知使能状态。
    let context = getContext() as common.UIAbilityContext
    if (!isAuth) {
      //未授权，拉起授权,应用请求通知使能模态弹窗。
      notificationManager.requestEnableNotification(context, (err: BusinessError) => {
        if (err) {
          callBack(false);
        } else {
          callBack(true);
        }
      })
    } else {
      callBack(true);
    }
  }



  // 发送通知
  sendNotify(notifyRequest: notificationManager.NotificationRequest) {
    return notificationManager.publish(notifyRequest)
      .then(_ => {
        return Promise.resolve()
      })
      .catch((err: BusinessError) => {
        hsLog.e(TAG,'myData > err:发送通知', JSON.stringify(err))
        return Promise.reject(err)
      })
  }
  // 获取当前应用的通知数
  getNotifyCount() {
    notificationManager.getActiveNotificationCount()
      .then((data) => {
        notificationManager.setBadgeNumber(data, (err) => { // 给应用设置通知数量角标
          hsLog.i(TAG,'myData > err: 设置当前应用的通知数', JSON.stringify(err))
        })
      })
      .catch((err: BusinessError) => {
        hsLog.e(TAG,'myData > err: 获取当前应用未删除的通知数', JSON.stringify(err))
      })
  }
  async testLocalNotify() {

    //创建wantAgent
    let wantAgentObj = await this.getWantAgent(this.curr_id);

    // 构建NotificationRequest对象
    // 不同类型的通知，请参考鸿蒙开发者官网构建不同的NotificationRequest对象
    const notifyRequest: notificationManager.NotificationRequest = {
      id: this.curr_id,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: '文本通知',
          text: '测试本地通知',
          additionalText: '附加内容',

        },

      },
      notificationSlotType: notificationManager.SlotType.SOCIAL_COMMUNICATION,
      wantAgent: wantAgentObj, //WantAgent封装了应用的行为意图，点击通知时触发该行为。
      removalWantAgent: wantAgentObj, //当移除通知时，通知将被重定向到的WantAgent实例。
      extraInfo:{"url":"hsLearn://aaa/bb"}
    }


    // 调用通知发送方法
    this.sendNotify(notifyRequest) // 传入NotificationRequest对象
      .then(() => {
        hsLog.i(TAG,'myData 通知发送成功')
        this.curr_id ++ // 由于发送相同id的通知会覆盖之前的通知，所以每次发送通知时id要变化
      })
  }

  /**
   * 创建一个可拉起Ability的Want
   * @returns
   */
  private async getWantAgent(noticeId: number): Promise<WantAgent> {
    let context = getContext() as common.UIAbilityContext; //获取当前上下文对象
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          deviceId: '',
          bundleName: context.abilityInfo.bundleName,
          moduleName: context.abilityInfo.moduleName,
          abilityName: context.abilityInfo.name,
          action: 'action_notice',
          entities: [],
          uri: 'hslearn://deeplink/aa',
          parameters: {
            'params_notice': noticeId,
            'cotent':"aaabb"
          }
        }
      ],
      actionType: wantAgent.OperationType.START_ABILITY | wantAgent.OperationType.SEND_COMMON_EVENT,
      requestCode: 0,
      actionFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG]
    };

    //
    //wantAgent.getWantAgent(wantAgentInfo,this.getWantAgentCallback)

    // try {
    //   wantAgent.getWantAgent(wantAgentInfo).then((data)=>{
    //
    //   }).catch((e:BusinessError)=>{
    //
    //   })
    // } catch (e) {
    //
    // }


    return await wantAgent.getWantAgent(wantAgentInfo);
  }

  //getWantAgent回调
  getWantAgentCallback(err: BusinessError, data: WantAgent) {
    if (err) {
      console.error(`getWantAgent failed, code: ${JSON.stringify(err.code)}, message: ${JSON.stringify(err.message)}`);
    } else {
    }
  }

  /**
   * Receives scenario-specific messages from Push Kit
   */
  private receiveMessage(ability: Ability): void {
    try {
      pushService.receiveMessage('IM', ability, (payload) => {
        try { // recommend to add try-catch block to capture exceptions
          hsLog.i(TAG,`receiveMessage, type: ${payload.type}`);
          // get extraData passed by REST API
          const extraData: HSExtraData = JSON.parse(JSON.parse(payload.data).data);

          // TODO: modify it based on your service scenario
          promptAction.showToast({
            message: $r('app.string.express_message', extraData.time, extraData.amount),
            duration: 5000,
          });
        } catch (e) {
          const err: BusinessError = e;
          hsLog.e(TAG,`Failed to process message: ${err.code} ${err.message}`);
        }
      });
    } catch (e) {
      const err: BusinessError = e;
      hsLog.e(TAG,`Failed to receive message: ${err.code} ${err.message}`);
    }
  }

  //接收后台消息内容
  receiveBackground(ability: Ability) {
    pushService.receiveMessage('BACKGROUND', ability, (data: pushCommon.PushPayload) => {
      // process message，并建议对Callback进行try-catch
      try {
        hsLog.i(TAG, 'Receive background message');
      } catch (e) {
        let errRes: BusinessError = e as BusinessError;
        hsLog.e(TAG, `Failed to process data: ${errRes.code} ${errRes.message}`);
      }
    });
  }

  //订阅 单次订阅最多支持输入3个entityId，若存在完全相同的entityId，最终只会保留1个
  async requestSubscribeNotification() {
    try {
      // entityIds请替换为待订阅的模板ID
      let entityIds: string[] = ['id1', 'id2'];
      hsLog.i(TAG, 'Request subscribe notification begin.');
      hsLog.i(TAG, `Request subscribe notification entityIds: ${entityIds}`);
      serviceNotification.requestSubscribeNotification(this.context, entityIds,(e,data)=>{

        // 当用户同意订阅（ResultCode的值为0），应用服务端调用REST API推送订阅消息
        let kk = e.code

        hsLog.i(TAG, `Succeeded in requesting subscribe notification: ${JSON.stringify(data)}`);
      })

    } catch (err) {
      let e: BusinessError = err as BusinessError;
      hsLog.e(TAG, `Failed to request subscribe notification: ${e.code} ${e.message}`);
    }
  }
}

export const hsNotificationManager: HSNotification = new HSNotification()

// Push Token一般情况不会变化，仅下列场景Push Token会发生变化：
// 卸载应用后重新安装。
// 设备恢复出厂设置。
// 应用显式调用deleteToken()接口后重新调用getToken()接口。
// 应用显式调用deleteAAID()接口后重新调用getToken()接口。
// 大区切换后（仅涉及Wearable设备）。
// 因此，建议您在应用启动时调用getToken()接口，若设备的Push Token发生变化，及时上报到您的应用服务器更新Push Token。