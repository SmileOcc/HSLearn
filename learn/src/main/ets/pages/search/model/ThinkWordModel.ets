
export class ThinkWordModel {
  wordStart:string|undefined
  wordMid:string|undefined
  wordEnd:string|undefined
  highLightIndex:number = 0
  highLightColor:string =''
  normalColor:string = ''

  constructor(color:string,normal:string,index:number,start:string,mid:string,end:string) {
    this.highLightColor = color
    this.normalColor = normal
    this.highLightIndex = index
    this.wordStart = start
    this.wordMid = mid
    this.wordEnd = end
  }
}