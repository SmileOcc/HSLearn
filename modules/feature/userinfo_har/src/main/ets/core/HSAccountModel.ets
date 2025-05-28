@ObservedV2
export class HSAccountModel {
  userId: string
  @Trace
  nickName: string
  birthday?: string
  email?: string
  avatar?: string
  is_new?: string
  sex?: number
  token: string
  desc?: string

  outstandingOrderNum: number = 0 // 用户未付款订单数
  processingOrderNum: number = 0;  // 用户处理中订单数
  shippedOrderNum: number = 0;    // 用户运输中订单数
  reviewedNum: number = 0;       // 用户待评论订单数
  feedbackMessageCount: number = 0;    // 用户反馈未读

  phone?: string;     //手机号
  phoneCode?: string; //区号

  //会员中心入口
  is_show_vip?: boolean;     //是否展示vip
  vip_url?: string; //vip 跳转url
  vip_icon_url?: string;     //会员等级图标URL

  constructor(userId:string, nickName:string, token: string) {
    this.userId = userId
    this.nickName = nickName
    this.token = token
  }
}