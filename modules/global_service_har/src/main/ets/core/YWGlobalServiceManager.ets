
export namespace GlobalService {

  // export function asyncLocalStage(storage:()=>LocalStorage) {
  //
  //   let currentStorage = storage()
  //   //TODO 可以添加数据
  //   currentStorage.setOrCreate("kk","value")
  //   return currentStorage
  // }
}

export function asyncLocalStage(storage:()=>LocalStorage) {

  let currentStorage = storage()
  //TODO 可以添加数据
  currentStorage.setOrCreate("kk","value")
  return currentStorage
}

export class YWGlobalServiceManager {

}