export const kNode_Status_Show = 1
export const kNode_Status_hide = 0

export class BaseNodeViewModel {
  context?: object
  userSession?: object
  isShow?: boolean = false
  constructor(isShow?: boolean, context?:object, userSession?: object) {
    this.context = context
    this.userSession = userSession
    this.isShow = isShow
  }
}

export class NodeViewModel extends BaseNodeViewModel{
  status: number = 0
  listerList: ((status: number) => void) [] = []
  constructor(isShow?: boolean, context?:object, userSession?: object) {
    super(isShow, context, userSession)
    if (isShow) {
      this.status = kNode_Status_Show
    }
  }
  getStatus() {
    return this.status
  }

  addLister(lister:(status: number)=>void) {
    this.listerList.push(lister)
  }
  removeLister(lister:(status: number)=>void) {
    this.listerList = this.listerList.filter((e) => e != lister)
  }

  show() {
    this.status = kNode_Status_Show
    this.listerList.forEach((e)=>{
      e(this.status)
    })
  }

  hide() {
    this.status = kNode_Status_hide
    this.listerList.forEach((e)=>{
      e(this.status)
      // this.removeLister(e)
    })
  }


}