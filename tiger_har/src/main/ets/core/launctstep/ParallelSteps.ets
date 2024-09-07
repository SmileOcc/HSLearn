import { ITigerAppContext } from '../ITigerAppContext'
import { StepLauncherExecute } from '../launchexecute/StepLauncherExecute'
import { TaskType } from '../task/BaseStep'
import { LaunchStepData, LaunchStep } from '../task/LaunchStep'

export class ParallelSteps extends LaunchStep {

  readonly appContext:ITigerAppContext
  readonly launcherExecute:StepLauncherExecute
  private taskSteps:Array<LaunchStep>

  constructor(context:ITigerAppContext, exectue: StepLauncherExecute, steps:Array<LaunchStep>) {
    super()
    this.appContext = context
    this.launcherExecute = exectue
    this.taskSteps = steps
  }

  async run(): Promise<LaunchStepData | undefined> {

    // for (const task of this.taskSteps) {
    //   task.run()
    // }

    return Promise.all(this.taskSteps.map((value)=>{
       this.launcherExecute.run(value)
    }))

  }

  getDataKey(): TaskType | undefined {
    return undefined
  }
}