import { CommonError } from '../../error/CommonError';
import { AppConfigModel } from '../model/AppConfigModel';
import { AppUserInfoModel } from '../model/AppUserInfoModel';
import { BaseStep, TaskType } from './BaseStep';

export type LaunchData = AppConfigModel | AppUserInfoModel


export interface ExecuteInfo {
  launchSetpData:LaunchStepData
}

export interface LaunchStepData {
  data?:LaunchData,
  error?:CommonError
}

export class LaunchStep extends BaseStep {

  async run():Promise<LaunchStepData| void> {

    await new Promise<LaunchStepData>((relo)=>{
      //测试请求完成任务
      setTimeout(() => {

        console.debug("======aaaaa BaseTask")
        relo({data: new AppConfigModel()})
      }, 4000)

    })
    console.debug("======aaaaa 222 BaseTask")

    return { error: { code:1001, msg:"error" }}
  }

  getDataKey(): TaskType | undefined {
    return undefined
  }
}