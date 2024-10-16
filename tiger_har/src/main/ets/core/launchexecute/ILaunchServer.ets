import { ITigerAppServer } from '../ITigerAppServer'
import { ExecuteInfo, LaunchStepData } from '../task/LaunchStep'
import { LaunchStepState } from './LaunchStepState'
import { LaunchStoreDataManager } from './LaunchStoreDataManager'

export interface ILaunchServer extends ITigerAppServer{

  registerServer(server:ILaunchListener):void

  unRegisterServer(server:ILaunchListener): void

  getLaunchStoreDataReader():LaunchStoreDataManager
}

export interface ILaunchListener {
  onEntry:(state:LaunchStepState,info?:LaunchStepData) => Promise<void>
}