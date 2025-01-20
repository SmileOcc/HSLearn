
export interface IBaseTask {

  run():Promise<void>
}

export class BaseTask implements IBaseTask {
  run(): Promise<void> {
    return Promise.resolve()
  }

}