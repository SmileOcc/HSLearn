import { IAppTask, TaskType } from "@learn/learn_task_har"
import { YWLocalNavType, YWNavPath, ywNavRouter } from "@learn/nav_router_har"
import { addressDetailBuilder } from "../components/AddressDetail"
import { addressListBuilder } from "../components/AddressListPage"

export class AddressTask implements IAppTask {
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

      {name:YWNavPath.root_address_nav,builder:wrapBuilder(addressListBuilder)},
      {name:YWNavPath.root_address_detail_nav,builder:wrapBuilder(addressDetailBuilder)},

    ])
    return Promise.resolve()
  }
}