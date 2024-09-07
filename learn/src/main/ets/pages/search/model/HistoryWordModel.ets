
export class HistoryWordModel {
  index:number = 0
  word:string = ''
  wordColor:string|undefined
  link:string = ''

  constructor(index:number,word:string,link?:string,color?:string) {
    this.index = index
    this.word = word
    this.wordColor = color
    this.link = link ?? ''
  }
}