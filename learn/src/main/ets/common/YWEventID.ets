/**
 * 事件ID
 */
class YWEventID {
  readonly GOTO_INDEX: string = 'goto_index'; //页面下标切换
  readonly CRASH_MSG: string = 'crash_msg'; //异常内容
  readonly NOISE_CHANGE: string = 'noise_change'; //噪音发生变化
}

export let eventID = new YWEventID()