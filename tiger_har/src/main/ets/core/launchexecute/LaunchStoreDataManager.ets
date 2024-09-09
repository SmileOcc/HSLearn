import { TaskType } from '../task/BaseStep';
import { LaunchStepData } from '../task/LaunchStep';
import { TigerGlobalThis } from '../TigerGlobalThis';
import { LaunchDataReader, LaunchDataWrite } from './LaunchDataWrite';

export class LaunchStoreDataManager implements LaunchDataReader, LaunchDataWrite {
  private storeMap:Map<string,LaunchStepData> = new Map()

  getData<T extends LaunchStepData>(key: TaskType): T | undefined {

    if (this.storeMap.has(key)) {
      let data = this.storeMap.get(key)
      return data as T
    }

    //let data = TigerGlobalThis.readLaunchData(key)
    return undefined
  }

  setData<T extends LaunchStepData>(key: TaskType, data: T): boolean {
      let obj = data as LaunchStepData
      this.storeMap.set(key,obj)
      return true
      //TigerGlobalThis.saveLaunchData(key,obj)
  }

  onStart(): void {
    throw new Error('Method not implemented.');
  }

  onShow(): void {
    throw new Error('Method not implemented.');
  }



}