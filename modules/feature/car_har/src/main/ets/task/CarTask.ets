import { IAppTask, TaskType } from "@learn/learn_task_har"
import { YWLocalNavType, YWNavPath, ywNavRouter } from "@learn/nav_router_har"
import { goodsDetailBuilder } from "../components/goods_detail/GoodsDetailPage"

export class CarTask implements IAppTask {
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

    ywNavRouter.boundRouteName(YWLocalNavType.NAV_ROOT_MAIN_TAB,[

      {name:YWNavPath.vc_car_goods_detail,builder:wrapBuilder(goodsDetailBuilder)},

      ])

    ywNavRouter.boundRouteName(YWLocalNavType.NAV_MAIN_CAR,[

      {name:YWNavPath.vc_car_goods_detail,builder:wrapBuilder(goodsDetailBuilder)},
    ])
    return Promise.resolve()
  }
}