import { hsMockManager } from "@learn/res_har"
import { DelicacyGroupListItemModel } from "../model/DelicacyGroupListItemModel"

export class DelicacyGroupListViewModel {
  pageNo:number = 1

  getDelicacyGroupList():Promise<DelicacyGroupListItemModel[]> {
    return new Promise((resolve,reject) => {
      let list: DelicacyGroupListItemModel[] = hsMockManager.reqDelicacyGroupList() as DelicacyGroupListItemModel[] ?? []
      resolve(list)
    })
  }
}