
/*
 * @Desc:
 * 1. 根据服务器配置弹窗次数等
 * 2. 采用服务器时间判断上次弹窗时间
 * 3. 每日从 0点到24点算一天
 */
import { YWTipDialog, TipParm } from '@learn/alert_har';
import { IAdvModel } from '../../../data/IAdvModel';
import { ENU_CONTEXT, ENU_PREFS, globalThis, YWAppUtils, YWNavRouterUtils } from '@learn/common_har';
// import { pref } from '@common/utils';
// import { Const } from '../common/constants/Const';
import { common } from '@kit.AbilityKit';

const LAST_ID: string = 'bulletin_last_show_id'; //上次的显示id
const LAST_TIME: string = 'bulletin_last_show_time'; //上次的显示时间
const LAST_COUNT: string = 'bulletin_last_show_count'; //上次的显示每日数量
const COUNT_EVERY_TIME: number = -1; //这个ID每一次都弹
const COUNT_ALL_1: number = 0; //这个ID只弹出一次
const COUNT_DAY_1: number = 1; //这个ID每日弹出一次

export class YWAdvBanner {
  static async show(data: IAdvModel) {
    if (data === undefined) {
      return;
    }
    if (data.start_date === undefined || data.end_date === undefined) {
      return;
    }
    const now = data.server_time !== undefined ? data.server_time : Date.now();
    const start = Date.parse(data.start_date);
    const end = Date.parse(data.end_date);
    if (now < start || now > end) {
      return;
    }
    const lastId: number = await globalThis.getPrefValue(LAST_ID, -1,ENU_PREFS.Global);
    const dayCount = data.id !== undefined ? data.id : COUNT_DAY_1;

    while (true) {
      if (dayCount === COUNT_EVERY_TIME) { //这个ID每次都弹
        globalThis.setPrefValue(LAST_ID, data.id);
        break;
      }

      if (data.id !== lastId) { //这个ID 是首次弹窗，更新缓存初始化
        globalThis.setPrefValue(LAST_ID, data.id);
        globalThis.setPrefValue(LAST_TIME, now);
        globalThis.setPrefValue(LAST_COUNT, 1);
        break;
      }

      //下面是该ID非首次弹窗处理
      const lastTime = await globalThis.getPrefValue<number>(LAST_TIME, 0);
      const lastCount = await globalThis.getPrefValue<number>(LAST_COUNT, 1);
      if (dayCount === COUNT_ALL_1) { //这个ID只弹出一次
        return;
      }
      if (now < lastTime) { //时间后退了！！！
        return;
      }

      const nowDate = new Date(now);
      const lastDate = new Date(lastTime);
      if (nowDate.getFullYear() !== lastDate.getFullYear()
        || nowDate.getMonth() !== lastDate.getMonth()
        || nowDate.getDate() !== lastDate.getDate()) { //上次弹不是同一天了。
        globalThis.setPrefValue(LAST_TIME, now);
        globalThis.setPrefValue(LAST_COUNT, 1);
        break;
      }

      //同一天时，判断弹窗次数
      if (dayCount <= lastCount) { //已经弹够了次数了
        return
      }
      globalThis.setPrefValue(LAST_COUNT, lastCount + 1); //更新这一次
      break;
    }

    data.start_date
    const parm: TipParm = { content: data.content ?? "" };
    if (data.title) {
      parm.title = data.title;
    }
    if (data.confirm) {
      parm.okMsg = data.confirm;
    }
    if (data.cancel) {
      parm.noMsg = data.cancel;
      if (data.cancel.includes('退出')) {
        parm.onNo = () => {
          globalThis.getObject<common.UIAbilityContext>(ENU_CONTEXT.UI_Root).terminateSelf();
        }
      }
      parm.outsideCancel = false;
      parm.pressBackCancel = false;
    }
    parm.onOk = () => {
      if (data.url) {
        YWAppUtils.jumpUrl(data.url);
      }
    }
    YWTipDialog.open(parm)
  }
}
