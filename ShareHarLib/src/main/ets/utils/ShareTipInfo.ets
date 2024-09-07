
export class ShareTipInfo {
  static defaultTip:string = "====default==="

  title:string | undefined
  img:Resource | undefined

  constructor(title:string, img:Resource|undefined) {
    this.title = title
    this.img = img
  }
}

export function createShareInfo(title:string, img:Resource|undefined) {
  new ShareTipInfo(title, img)
}