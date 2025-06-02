import { hsMockManager } from "@learn/res_har"
import { RoomListItemModel } from "../../hotellist/model/HotelListItemModel"


export class HotelRoomListViewModel {
  pageNo:number = 1

  getRoomList():Promise<RoomListItemModel[]> {

    return new Promise((resolve,reject) => {
      const list:RoomListItemModel[] = hsMockManager.reqHotelRoomList() as RoomListItemModel[] ?? []
      resolve(list)
    })

  }
}
