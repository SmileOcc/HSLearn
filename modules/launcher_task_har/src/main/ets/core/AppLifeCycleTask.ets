import { appContextLifeInstance } from "@learn/appcontext_har"
import { TaskType } from "@learn/learn_task_har"
import { ILaunchTask } from "./ILaunchTask"

export class AppLifeCycleTask implements ILaunchTask {
  private context:Context
  constructor(context:Context) {
    this.context = context
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

    appContextLifeInstance.init(this.context)
    return Promise.resolve()
  }
}