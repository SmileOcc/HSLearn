import { LaunchStepState } from '../launchexecute/LaunchStepState'

export interface IBaseStep {

  run():Promise<object|undefined>

  getStartState():LaunchStepState | undefined

  getEndState(): LaunchStepState | undefined

  getDataKey():string | undefined

  getLog():string | undefined
}