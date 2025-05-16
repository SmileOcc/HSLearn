// 定义回调接口
interface ShowDialogCallback {
  operateBlock:(message: string) => void
}

class TestShowDialogModel {
  private showDialogCallback: ShowDialogCallback | null = null;

  // 设置回调函数
  setShowDialogCallback(callback: ShowDialogCallback) {
    this.showDialogCallback = callback;
  }

  // 模拟业务逻辑，触发显示弹框
  doBusinessLogic() {
    // 模拟一些业务处理
    const message = "这是弹框要显示的消息";
    if (this.showDialogCallback) {
      this.showDialogCallback.operateBlock(message);
    }
  }
}

export default TestShowDialogModel;



export class TestSheetManager {

  isShowA: boolean = false
  isShowB: boolean = false

  testAModel?:TestSheetModel
  testBModel?:TestSheetModel

  sheetUIState: TestSheetUIState = new TestSheetUIState()
}

@Observed
export class TestSheetUIState {
  testUIAModel?:TestSheetModel
  testUIBModel?:TestSheetModel
}

@Observed
export class TestSheetModel {
  id?: string
  isShowA: boolean = false
  isShowB: boolean = false
  testMessage: string = "aaa"

  showBAlert?:()=>void
  dissBlack?:(id:string)=>void
  showXAlert?:(id:string)=>void

  modeListA: Array<Chat> = [{cid:"cid_1", profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"aaaaaaa"},
    {cid:"cid_2", profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"bbbbbb 大家哦殴打巨大简欧大家记得京东数科JOJO"},
    {cid:"cid_3", profile:$r('app.media.user_avatar'),nickname:"bbbb",content:"ccccccc 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
    {cid:"cid_4", profile:$r('app.media.user_avatar'),nickname:"cccc",content:"ddddd 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
    {cid:"cid_5", profile:$r('app.media.user_avatar'),nickname:"dddd",content:"44444444 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
    {cid:"cid_6", profile:$r('app.media.user_avatar'),nickname:"eeee",content:"3333333 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
    {cid:"cid_7", profile:$r('app.media.user_avatar'),nickname:"ffff",content:"123213213123"}]

  modeListB: Array<Chat> = [{cid:"cid_1", profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"bbbbbbbb"},
    {cid:"cid_2", profile:$r('app.media.user_avatar'),nickname:"aaaa",content:"bbbbbb 大家哦殴打巨大简欧大家记得京东数科JOJO"},
    {cid:"cid_3", profile:$r('app.media.user_avatar'),nickname:"bbbb",content:"ccccccc 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
    {cid:"cid_4", profile:$r('app.media.user_avatar'),nickname:"cccc",content:"ddddd 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
    {cid:"cid_5", profile:$r('app.media.user_avatar'),nickname:"dddd",content:"44444444 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
    {cid:"cid_6", profile:$r('app.media.user_avatar'),nickname:"eeee",content:"3333333 快快快看看看就就就就就就 就打开撒可抵扣卡达克打卡"},
    {cid:"cid_7", profile:$r('app.media.user_avatar'),nickname:"ffff",content:"123213213123"}]
}

export interface Chat {
  cid: string,
  profile: Resource,
  nickname: string,
  content: string,
}
