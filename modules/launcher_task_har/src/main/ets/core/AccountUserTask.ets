import { TaskType } from "@learn/learn_task_har"
import { hsLog } from "@learn/logger_har"
import { HSUserInfoManager } from "@learn/userinfo_har"
import { ILaunchTask } from "./ILaunchTask"

const TAG = "AccountUserTask"
export class AccountUserTask implements ILaunchTask {
  appcontext?:Context

  constructor(context:Context) {
    this.appcontext = context
  }

  priority(): number {
    return 0
  }

  type(): TaskType {
    return TaskType.main
  }

  name(): string {
    return ""
  }

  async run(): Promise<void> {
    const userInfo = await HSUserInfoManager.getInstance().mockUserInfo()
    hsLog.i(TAG,`launc userInfo: ${JSON.stringify(userInfo)}`)
    return Promise.resolve()
  }
}