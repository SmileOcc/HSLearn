import { LaunchStepState } from '../launchexecute/LaunchStepState'
import { LaunchStepData } from './LaunchStep'

export interface IBaseStep {

  run():Promise<LaunchStepData|void>

  getStartState():LaunchStepState | undefined

  getEndState(): LaunchStepState | undefined

  getDataKey():string | undefined

  getLog():string | undefined
}