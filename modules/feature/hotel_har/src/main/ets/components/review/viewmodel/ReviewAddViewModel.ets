import { ReviewModel } from "../model/ReviewModel"

export class ReviewAddViewModel {

  confirmReview(params:ReviewModel):Promise<boolean> {

    return new Promise((resolve,reject) => {
      // requestModelAxios.postComment(params)
      //   .then(value => {
      //     resolve(true)
      //   })
      //   .catch((error:string) => {
      //     AlertDialog.show({message:error})
      //     reject(error)
      //   })
      resolve(true)
    })

  }
}
