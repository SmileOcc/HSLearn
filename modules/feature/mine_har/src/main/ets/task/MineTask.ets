
import { IAppTask, TaskType } from "@learn/learn_task_har"
import { YWLocalNavType, YWNavPath, ywNavRouter } from "@learn/nav_router_har"
import { fileRecordBuilder } from "../components/filerecord/FileRecordPage"
import { userInfoBuilder } from "../components/userInfo/UserInfoPage"

export class MineTask implements IAppTask {
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

    ywNavRouter.boundRouteName(YWLocalNavType.NAV_MAIN_MINE,[

      {name:YWNavPath.mine_file_record,builder:wrapBuilder(fileRecordBuilder)},
      {name:YWNavPath.mine_user_info,builder:wrapBuilder(userInfoBuilder)},

    ])
    return Promise.resolve()
  }
}