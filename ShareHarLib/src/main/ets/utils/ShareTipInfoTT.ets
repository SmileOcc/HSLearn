
export default  class ShareTipInfoTT {
  static defaultTip:string = "====default==="

  title:string | undefined
  img:Resource | undefined

  constructor(title:string, img:Resource|undefined) {
    this.title = title
    this.img = img
  }
}