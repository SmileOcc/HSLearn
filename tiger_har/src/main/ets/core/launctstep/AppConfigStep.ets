import { ITigerAppContext } from '../ITigerAppContext';
import { AppConfigModel } from '../model/AppConfigModel';
import { TaskType } from '../task/BaseStep';
import { LaunchStepData, LaunchStep } from '../task/LaunchStep';

const TAG = "AppConfigStep"
export class AppConfigStep extends LaunchStep {
  readonly appContext:ITigerAppContext

  constructor(context:ITigerAppContext) {
    super();
    this.appContext = context
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