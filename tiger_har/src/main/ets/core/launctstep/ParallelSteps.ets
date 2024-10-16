import { ITigerAppContext } from '../ITigerAppContext'
import { ILaunchStateMachine } from '../launchexecute/ILaunchStateMachine'
import { LaunchStepState } from '../launchexecute/LaunchStepState'
import { StepLauncherExecute } from '../launchexecute/StepLauncherExecute'
import { TaskType } from '../task/BaseStep'
import { LaunchStepData, LaunchStep } from '../task/LaunchStep'

export class ParallelSteps extends LaunchStep {
  readonly appContext: ITigerAppContext
  readonly launcherExecute: StepLauncherExecute
  private taskSteps: Array<LaunchStep>
  readonly stateForm?: LaunchStepState | null
  readonly stateTo?: LaunchStepState | null
  private launcherStateMachine: ILaunchStateMachine

  constructor(context: ITigerAppContext,
              stateForm: LaunchStepState | null,
              stateTo: LaunchStepState | null,
              execute: StepLauncherExecute,
              launcherStateMachine: ILaunchStateMachine,
              steps: Array<LaunchStep>) {
    super()
    this.appContext = context
    this.launcherExecute = execute
    this.taskSteps = steps
    this.launcherStateMachine = launcherStateMachine

    this.stateForm = stateForm
    this.stateTo = stateTo
  }

  async run(): Promise<void> {
    if (this.taskSteps.length == 0) {
      if (this.stateTo) {
        this.launcherStateMachine.onChangeState(this.stateTo)
      }
      return
    }

    try {
      await Promise.all(
        this.taskSteps.map(async (value) => {
          try {
            await this.launcherExecute.run(value)
            if (this.stateTo) {
              this.launcherStateMachine.onChangeState(this.stateTo)
            }
          } catch (error) {
            throw Error("启动任务出错，终止：" + JSON.stringify(error))
          }
        }))
    } catch (error) {

    }


  }

  getDataKey(): TaskType | undefined {
    return undefined
  }
}