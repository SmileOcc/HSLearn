import { ITigerAppServer } from '../ITigerAppServer';
import { TaskType } from '../task/BaseStep';
import { LaunchStepData } from '../task/LaunchStep';
import { TigerGlobalThis } from '../TigerGlobalThis';

export interface LaunchDataReader extends  ITigerAppServer {

  //todo 可以限制T类型
  getData<T extends LaunchStepData>(key:TaskType):T | undefined
  // {
  //   let data = TigerGlobalThis.readLaunchData(key)
  //   return data as T
  // }

}

export interface LaunchDataWrite {

  //todo 可以限制T类型
  setData<T extends LaunchStepData>(key:TaskType,data:T):boolean
  // {
  //   let obj = data as LaunchStepData
  //   TigerGlobalThis.saveLaunchData(key,obj)
  // }
}