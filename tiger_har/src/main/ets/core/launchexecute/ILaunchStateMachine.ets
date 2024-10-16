import { ExecuteInfo, LaunchStepData } from '../task/LaunchStep'
import { LaunchStepState } from './LaunchStepState'

export interface ILaunchStateMachine {

  getState():string

  onChangeState(state:LaunchStepState,info?:ExecuteInfo):Promise<void>

}