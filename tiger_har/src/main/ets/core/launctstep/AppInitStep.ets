import { ITigerAppContext } from '../ITigerAppContext'
import { LaunchStepState } from '../launchexecute/LaunchStepState'
import { TaskType } from '../task/BaseStep'
import { LaunchStepData, LaunchStep } from '../task/LaunchStep'

const TAG = "AppInitStep"
export class AppInitStep extends LaunchStep {

  readonly appContext:ITigerAppContext
  readonly stateForm?:LaunchStepState | null
  readonly stateTo?:LaunchStepState | null

  constructor(context:ITigerAppContext,stateForm:LaunchStepState | null, stateTo:LaunchStepState | null) {
    super();
    this.appContext = context
    this.stateForm = stateForm
    this.stateTo = stateTo
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