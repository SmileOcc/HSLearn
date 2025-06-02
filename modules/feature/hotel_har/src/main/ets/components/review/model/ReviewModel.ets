export class ReviewModel {
  id:number|undefined
  commentMakerName:string|undefined
  comment:string|undefined
  score:number|undefined
  commentTime:string|undefined
  hotelName:string|undefined
}

export interface  ReviewType{
  title:string
  isSelect:boolean
}
