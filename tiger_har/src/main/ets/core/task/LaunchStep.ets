import { AppConfigModel } from '../model/AppConfigModel';
import { AppUserInfoModel } from '../model/AppUserInfoModel';
import { BaseStep, TaskType } from './BaseStep';

export type LaunchStepData = AppConfigModel | AppUserInfoModel

export class LaunchStep extends BaseStep {

  async run():Promise<LaunchStepData | undefined> {

    await new Promise<void>((relo)=>{
      //测试请求完成任务
      setTimeout(() => {

        console.debug("======aaaaa BaseTask")
        relo()
      }, 4000)

    })
    console.debug("======aaaaa 222 BaseTask")

    return undefined
  }

  getDataKey(): TaskType | undefined {
    return undefined
  }
}