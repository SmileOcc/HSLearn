import { ITigerAppContext } from '../ITigerAppContext'
import { ILaunchStateMachine } from '../launchexecute/ILaunchStateMachine'
import { StepLauncherExecute } from '../launchexecute/StepLauncherExecute'
import { TaskType } from '../task/BaseStep'
import { LaunchStepData, LaunchStep } from '../task/LaunchStep'

export class SerialSteps extends LaunchStep {
  readonly appContext:ITigerAppContext
  readonly launcherExecute:StepLauncherExecute
  private taskSteps:Array<LaunchStep>

  constructor(context:ITigerAppContext,
              execute: StepLauncherExecute,
              steps:Array<LaunchStep>) {
    super()
    this.appContext = context
    this.launcherExecute = execute
    this.taskSteps = steps
  }

  async run(): Promise<LaunchStepData | undefined> {

    for (const task of this.taskSteps) {
      await task.run()
    }

    return undefined
  }

  getDataKey(): TaskType | undefined {
    return undefined
  }
}