import { ITigerAppContext } from '../ITigerAppContext'
import { TaskType } from '../task/BaseStep'
import { LaunchStepData, LaunchStep } from '../task/LaunchStep'

const TAG = "AppInitStep"
export class AppInitStep extends LaunchStep {

  readonly appContext:ITigerAppContext

  constructor(context:ITigerAppContext) {
    super();
    this.appContext = context
  }

  async run(): Promise<LaunchStepData | undefined> {
    return undefined
  }

  getDataKey(): TaskType {
    return TaskType.kAppInitStep
  }

  getLog(): string | undefined {
    return TAG
  }
}