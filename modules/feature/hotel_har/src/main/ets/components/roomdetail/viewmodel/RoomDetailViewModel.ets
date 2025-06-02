import { OrderItemInfo } from "../../hotellist/model/HotelListItemModel"

export class RoomDetailViewModel {
  pageNo:number = 1

  confirmRoom(params:OrderItemInfo):Promise<boolean> {

    return new Promise((resolve,reject) => {

      resolve(true)
    })

  }
}
