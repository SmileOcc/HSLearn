import { ITigerAppContext } from '../ITigerAppContext';
import { ITigerAppServer } from '../ITigerAppServer';
import { AppConfigStep } from '../launctstep/AppConfigStep';
import { AppInitStep } from '../launctstep/AppInitStep';
import { ParallelSteps } from '../launctstep/ParallelSteps';
import { SerialSteps } from '../launctstep/SerialSteps';
import { LaunchStep } from '../task/LaunchStep';
import { ILaunchListener, ILaunchServer } from './ILaunchServer';
import { ILaunchStateListener as IStateMachineListener } from './ILaunchStateListener';
import { ILaunchStateMachine } from './ILaunchStateMachine';
import { LaunchDataWrite } from './LaunchDataWrite';
import { LaunchStepState } from './LaunchStepState';
import { LaunchStoreDataManager } from './LaunchStoreDataManager';
import { StepLauncherExecute } from './StepLauncherExecute';
import { StepStateMachine } from './StepStateMachine';

export class StepLauncher implements ILaunchServer, IStateMachineListener{
  private appContext: ITigerAppContext
  private taskSteps: ReadonlyArray<LaunchStep>
  private launcherExecute: StepLauncherExecute
  private launcherStateMachine: ILaunchStateMachine
  private launchDataWrite: LaunchStoreDataManager

  private launchLinsterList:Array<ILaunchListener> = new Array()

  constructor(context:ITigerAppContext) {
    this.appContext = context
    this.launchDataWrite = new LaunchStoreDataManager()
    this.launcherStateMachine = new StepStateMachine(this)
    this.launcherExecute = new StepLauncherExecute(context,this.launcherStateMachine,this.launchDataWrite)
    this.taskSteps = this.buildSteps()

    this.launcherStateMachine.onChangeState(LaunchStepState.onInit)
  }

  registerServer(server: ILaunchListener): void {
    if (this.launchLinsterList.indexOf(server) < 0) {
      this.launchLinsterList.push(server)
    }
  }

  unRegisterServer(server:ILaunchListener): void {
    let index = this.launchLinsterList.indexOf(server)
    if (index >= 0) {
      this.launchLinsterList.splice(index,1)
    }
  }

  getLaunchStoreDataReader(): LaunchStoreDataManager {
    throw new Error('Method not implemented.');
  }

  onBefore(state: LaunchStepState): void {
    for (const observer of this.launchLinsterList) {
      observer.onEntry(state)

    }
  }

  onTrain(state: LaunchStepState): void {
    for (const observer of this.launchLinsterList) {
      observer.onEntry(state)

    }
  }

  onA(state: LaunchStepState): void {
  }

  onB(state: LaunchStepState): void {
  }


  onStart(): void {
    this.run()
  }

  onShow(): void {
    throw new Error('Method not implemented.');
  }

  buildSteps():Array<LaunchStep> {
    return [
      new AppConfigStep(this.appContext,null,null),
      new AppInitStep(this.appContext,null,null),
      new SerialSteps(this.appContext, null,null,this.launcherExecute,this.launcherStateMachine,[]),
      new ParallelSteps(this.appContext,null,LaunchStepState.onFinish,this.launcherExecute,this.launcherStateMachine,[])
    ]
  }

  async run():Promise<void> {
    for (const step of this.taskSteps) {
      await this.launcherExecute.run(step)
    }
  }
}