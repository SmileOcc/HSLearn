import { TaskType } from '../task/BaseStep';
import { LaunchStepData } from '../task/LaunchStep';
import { TigerGlobalThis } from '../TigerGlobalThis';

export class LaunchDataReader {

  //todo 可以限制T类型
  getData<T>(key:TaskType):T | undefined {
    let data = TigerGlobalThis.readLaunchData(key)
    return data as T
  }

}

export class LaunchDataWrite {

  //todo 可以限制T类型
  setData<T>(key:TaskType,data:T) {
    let obj = data as LaunchStepData
    TigerGlobalThis.saveLaunchData(key,obj)
  }
}