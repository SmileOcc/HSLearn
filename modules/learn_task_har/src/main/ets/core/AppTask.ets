
export enum TaskType {
  main,
  async,
}

export interface IAppTask {
  run():Promise<void>

  priority():number

  type():TaskType

  name():string

}

export class AppTask implements IAppTask {
  priority(): number {
    return 0
  }

  type(): TaskType {
    return TaskType.async
  }

  name(): string {
    return ""
  }

  run(): Promise<void> {

    return Promise.resolve()
  }
}