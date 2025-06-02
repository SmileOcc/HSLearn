import { hsLog } from "@learn/logger_har"
import { hsMockManager } from "@learn/res_har"
import { HotelListItemModel, RoomListItemModel } from "../model/HotelListItemModel"

const TAG = "HotelRoomListViewModel"
export class HotelRoomListViewModel {
  pageNo:number = 1

  getRoomList():Promise<RoomListItemModel[]> {

    return new Promise((resolve,reject) => {
      // requestModelAxios.reqHotelRoomList()
      //   .then(value => {
      //     resolve(value)
      //   })
      //   .catch((error:string) => {
      //     AlertDialog.show({message:error})
      //
      //   })
       let list:RoomListItemModel[] =   hsMockManager.reqHotelRoomList() as RoomListItemModel[]
      resolve(list)
    })

  }

  getHotelList():Promise<HotelListItemModel[]> {

    return new Promise((resolve,reject) => {
      // requestModelAxios.reqHotelList()
      //   .then(value => {
      //     resolve(value)
      //   })
      //   .catch((error:string) => {
      //     AlertDialog.show({message:error})
      //
      //   })
      let list:HotelListItemModel[] =   hsMockManager.getHotelList() as HotelListItemModel[]
      resolve(list)
    })

  }
}

const roomListViewModel = new HotelRoomListViewModel()
export default roomListViewModel as HotelRoomListViewModel