import { IAppTask, TaskType } from "@learn/learn_task_har"
import { YWLocalNavType, YWNavPath, ywNavRouter } from "@learn/nav_router_har"
import { hotelBuilder } from "../../../../Index"
import { delicacyGroupBuilder } from "../components/hotellist/DelicacyGroupListPage"
import { hotelListBuilder } from "../components/hotellist/HotelListPage"
import { myOrderBuilder } from "../components/order/MyOrderPage"
import { hotelReviewEditBuilder } from "../components/review/HotelReviewEditPage"
import { reviewListBuilder } from "../components/review/ReviewListPage"
import { hotelRoomDetailBuilder } from "../components/roomdetail/RoomDetailPage"
import { hotelRoomListBuilder } from "../components/roomlist/HotelRoomListPage"

export class HotelTask implements IAppTask {
  priority(): number {
    return 0
  }

  type(): TaskType {
    return TaskType.async
  }

  name(): string {
    return ""
  }

  run(): Promise<void> {

    //在外边注册了
    // ywNavRouter.boundRouteName(YWLocalNavType.NAV_ROOT_MAIN_TAB,[
    //   // {name:YWNavPath.root_hotel_nav,builder:wrapBuilder(hotelBuilder)},
    // ])

    ywNavRouter.boundRouteName(YWLocalNavType.NAV_HOTEL_NAV,[

      {name:YWNavPath.vc_hotel_list,builder:wrapBuilder(hotelListBuilder)},
      {name:YWNavPath.vc_hotel_delicacy_list,builder:wrapBuilder(delicacyGroupBuilder)},

      {name:YWNavPath.vc_hotel_room_list,builder:wrapBuilder(hotelRoomListBuilder)},
      {name:YWNavPath.vc_hotel_room_detail,builder:wrapBuilder(hotelRoomDetailBuilder)},
      {name:YWNavPath.vc_hotel_review_list,builder:wrapBuilder(reviewListBuilder)},
      {name:YWNavPath.vc_hotel_review_edit,builder:wrapBuilder(hotelReviewEditBuilder)},

      {name:YWNavPath.vc_hotel_my_order,builder:wrapBuilder(myOrderBuilder)},

    ])
    return Promise.resolve()
  }
}