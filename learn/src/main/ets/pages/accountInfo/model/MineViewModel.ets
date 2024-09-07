
export class MineViewModel {

  userInfo:UserInfo|undefined
  groups:Array<Array<MineItem>> = []

  constructor() {
    this.getUserInfo()
    this.getMenuItems()
  }

  getMenuItems() {
    let list:Array<Array<MineItem>> = [
      [
        {
          img:$r('app.media.tab_new_select'),
          title:'我的订单',
          desc:'',
          type:MineItemType.order
        },
        {
          img:$r('app.media.tab_new_select'),
          title:'我的中奖',
          desc:'',
          type:MineItemType.winning
        }
      ],
      [
        {
          img:$r('app.media.tab_new_select'),
          title:'会员章程',
          desc:'',
          type:MineItemType.member
        },
        {
          img:$r('app.media.tab_new_select'),
          title:'关于瞬和',
          desc:'',
          type:MineItemType.aboutUs
        },
        {
          img:$r('app.media.tab_new_select'),
          title:'隐私政策',
          desc:'',
          type:MineItemType.privacy
        }
      ],
      [
        {
          img:$r('app.media.tab_new_select'),
          title:'账号设置',
          desc:'',
          type:MineItemType.accountSet
        },
        {
          img:$r('app.media.tab_new_select'),
          title:'账号设置1',
          desc:'',
          type:MineItemType.accountSet
        },
        {
          img:$r('app.media.tab_new_select'),
          title:'账号设置2',
          desc:'',
          type:MineItemType.accountSet
        }
      ]
    ]

    this.groups = list
  }

  getUserInfo(){

    let userInf = new UserInfo()
    userInf.name = "occ"
    userInf.isV = true
    userInf.point = '8'
    this.userInfo = userInf
  }

}

class UserInfo {
  name:string|undefined
  isV:Boolean = false
  avator:string|undefined
  point:string = '0'
}

enum MineItemType {
  unknow = 0,
  order = 1,
  winning,
  member,
  aboutUs,
  privacy,
  accountSet
}

export interface MineItem {
  img:Resource | null
  title:string
  desc:string
  type:MineItemType
}