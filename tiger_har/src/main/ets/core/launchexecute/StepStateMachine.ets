import { ILaunchStateListener } from './ILaunchStateListener';
import { ILaunchStateMachine } from './ILaunchStateMachine';
import { LaunchStepState } from './LaunchStepState';

export class StepStateMachine implements ILaunchStateMachine {
  private listener: ILaunchStateListener
  private currentState: LaunchStepState

  constructor(listener:ILaunchStateListener) {
    this.listener = listener
    this.currentState = LaunchStepState.onInit
  }
  getState(): string {
    return this.currentState
  }

  async onChangeState(state: LaunchStepState): Promise<void> {
    await this.listener.onBefore(this.currentState)
    await this.listener.onA(this.currentState)
    await this.listener.onB(this.currentState)

    this.currentState = state
    await this.listener.onTrain(this.currentState)

  }

}