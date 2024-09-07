import { ITigerAppContext } from '../ITigerAppContext';
import { AppConfigStep } from '../launctstep/AppConfigStep';
import { AppInitStep } from '../launctstep/AppInitStep';
import { ParallelSteps } from '../launctstep/ParallelSteps';
import { SerialSteps } from '../launctstep/SerialSteps';
import { LaunchStep } from '../task/LaunchStep';
import { IAppServer } from './IAppServer';
import { ILaunchServer } from './ILaunchServer';
import { ILaunchStateMachine } from './ILaunchStateMachine';
import { LaunchDataWrite } from './LaunchDataWrite';
import { StepLauncherExecute } from './StepLauncherExecute';
import { StepStateMachine } from './StepStateMachine';

export class StepLauncher implements ILaunchServer, IAppServer{
  private appContext: ITigerAppContext
  private taskSteps: ReadonlyArray<LaunchStep>
  private launcherExecute: StepLauncherExecute
  private launcherStateMachine: ILaunchStateMachine
  private launchDataWrite: LaunchDataWrite

  constructor(context:ITigerAppContext) {
    this.appContext = context
    this.taskSteps = this.buildSteps()
    this.launchDataWrite = new LaunchDataWrite()
    this.launcherStateMachine = new StepStateMachine()
    this.launcherExecute = new StepLauncherExecute(context,this.launcherStateMachine,this.launchDataWrite)
  }

  buildSteps():Array<LaunchStep> {
    return [
      new AppConfigStep(this.appContext),
      new AppInitStep(this.appContext),
      new SerialSteps(this.appContext, this.launcherExecute,[]),
      new ParallelSteps(this.appContext, this.launcherExecute,[])
    ]
  }

  async run():Promise<void> {
    for (const step of this.taskSteps) {
      await this.launcherExecute.run(step)
    }
  }
}