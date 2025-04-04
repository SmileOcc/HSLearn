import { appLinkTools, CommonAppLink } from "@learn/applink_har"
import { TaskType } from "@learn/learn_task_har"
import { ILaunchTask } from "./ILaunchTask"

export class AppLinkTask implements ILaunchTask {
  priority(): number {
    return 0
  }

  type(): TaskType {
    return TaskType.main
  }

  name(): string {
    return ""
  }
  run(): Promise<void> {

    //注册各种调整
    appLinkTools.registerAppLink("learn:com.app.abc", new CommonAppLink())
    appLinkTools.registerAppLink("hslearn:com.mpp.abc", new CommonAppLink())

    return Promise.resolve()
  }
}