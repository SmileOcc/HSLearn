import { LaunchStepState } from '../launchexecute/LaunchStepState';
import { IBaseStep } from './IBaseStep';

export enum TaskType  {
  kAppConfigStep = "kAppConfigStep",
  kAppInitStep = "kAppInitStep"
}

const TAG = "BaseStep"
export class BaseStep implements IBaseStep {
  getLog(): string | undefined {
    return TAG
  }

  async run():Promise<object | undefined> {

    await new Promise<void>((relo)=>{
      //测试请求完成任务
      setTimeout(() => {

        console.debug("======aaaaa BaseTask")
          relo()
      }, 4000)

    })
    console.debug("======aaaaa 222 BaseTask")

    return undefined
  }

  getStartState():LaunchStepState | undefined {
    return undefined
  }

  getEndState(): LaunchStepState | undefined {
    return undefined
  }

  getDataKey(): string | undefined {
    return undefined
  }
}