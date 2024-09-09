import { LaunchStepState } from './LaunchStepState'

export interface ILaunchStateMachine {

  getState():string

  onChangeState(state:LaunchStepState):Promise<void>

}