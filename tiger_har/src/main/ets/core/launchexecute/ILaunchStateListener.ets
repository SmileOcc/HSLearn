import { LaunchStepState } from './LaunchStepState'

export interface ILaunchStateListener {
  onBefore(state:LaunchStepState):void

  onTrain(state:LaunchStepState):void

  onA(state:LaunchStepState):void

  onB(state:LaunchStepState):void

}