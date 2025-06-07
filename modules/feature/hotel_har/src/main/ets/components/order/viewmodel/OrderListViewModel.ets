import { hsMockManager } from "@learn/res_har"
import { OrderListItemModel } from "../model/OrderListItemModel"

export class OrderListViewModel {
  pageNo:number = 1

  getOrderList(status?: string | undefined):Promise<OrderListItemModel[]> {
    return new Promise((resolve,reject) => {
      let list = hsMockManager.reqStateOrderList() as OrderListItemModel[] ?? []
      if (status) {
        let listt = list.filter((item:object) => (item["orderStatus"] == status))
        resolve(listt)
      } else {
        resolve(list)
      }
    })

  }

}
