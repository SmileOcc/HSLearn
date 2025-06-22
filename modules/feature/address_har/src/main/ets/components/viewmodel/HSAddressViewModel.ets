import { hsMockManager } from "@learn/res_har"
import { HSAddressModel } from "../model/HSAddressModel"

export class HSAddressViewModel {

  getAddressList(status?: string | undefined):Promise<HSAddressModel[]> {
    return new Promise((resolve,reject) => {
      let list = hsMockManager.reqAddressList() as HSAddressModel[] ?? []
      // if (status) {
      //   let listt = list.filter((item:object) => (item["orderStatus"] == status))
      //   resolve(listt)
      // } else {
        resolve(list)
      // }
    })

  }
}