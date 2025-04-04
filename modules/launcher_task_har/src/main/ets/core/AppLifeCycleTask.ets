import { TaskType } from "@learn/learn_task_har"
import { ILaunchTask } from "./ILaunchTask"

export class AppLifeCycleTask implements ILaunchTask {
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

    return Promise.resolve()
  }
}