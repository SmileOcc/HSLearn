
export class HotWordsModel {
  word:string
  wordColor:string
  wordLink:string

  constructor(word:string,color:string,link?:string) {
    this.word = word
    this.wordColor = color
    this.wordLink = link ?? ''
  }
}