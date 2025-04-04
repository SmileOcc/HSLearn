import { TaskType } from "@learn/learn_task_har"
import { ILaunchTask } from "./ILaunchTask"

export class AppErrorExpectionTask implements ILaunchTask {
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
  run(): Promise<void> {

    return Promise.resolve()
  }
}