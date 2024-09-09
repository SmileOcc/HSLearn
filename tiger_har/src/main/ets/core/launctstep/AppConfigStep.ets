import { ITigerAppContext } from '../ITigerAppContext';
import { LaunchStepState } from '../launchexecute/LaunchStepState';
import { AppConfigModel } from '../model/AppConfigModel';
import { TaskType } from '../task/BaseStep';
import { LaunchStepData, LaunchStep } from '../task/LaunchStep';

const TAG = "AppConfigStep"
export class AppConfigStep extends LaunchStep {
  readonly appContext:ITigerAppContext
  readonly stateForm?:LaunchStepState | null
  readonly stateTo?:LaunchStepState | null

  constructor(context:ITigerAppContext,stateForm:LaunchStepState | null, stateTo:LaunchStepState | null) {
    super();
    this.appContext = context
    this.stateForm = stateForm
    this.stateTo = stateTo
  }
  async run(): Promise<LaunchStepData> {
    return new AppConfigModel()
  }
  getDataKey(): TaskType {
    return TaskType.kAppConfigStep;
  }

  getLog(): string | undefined {
    return TAG
  }
}