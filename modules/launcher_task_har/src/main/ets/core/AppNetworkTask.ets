import { TaskType } from "@learn/learn_task_har"
import { hsLog } from "@learn/logger_har"
import { HSRegisterNetworkListener } from "@learn/network_har"
import { ILaunchTask } from "./ILaunchTask"

const TAG = "AppNetworkTask"
export class AppNetworkTask implements ILaunchTask {
  // appcontext?:Context
  //
  // constructor(context:Context) {
  //   this.appcontext = context
  // }

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
    HSRegisterNetworkListener.register()
    HSRegisterNetworkListener.addCallback((status)=>{
      hsLog.i(TAG,`---network: ${status}`)
    },false)
    return Promise.resolve()
  }
}