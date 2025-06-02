import { hsMockManager } from "@learn/res_har"
import { ReviewModel } from "../model/ReviewModel"


export class ReviewViewModel {
  pageNo:number = 1

  list:ReviewModel[] = []

  getReviewList():Promise<ReviewModel[]> {

    return new Promise((resolve,reject) => {
      let list: ReviewModel[] = hsMockManager.reqCommentsList() as ReviewModel[] ?? []
      resolve(list)
    })

  }
}
