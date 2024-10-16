import { ITigerAppContext } from '../ITigerAppContext';
import { ExecuteInfo, LaunchStep, LaunchStepData } from '../task/LaunchStep';
import { ILaunchStateMachine } from './ILaunchStateMachine';
import { LaunchDataWrite } from './LaunchDataWrite';

export class StepLauncherExecute {
  readonly appContext:ITigerAppContext
  private stateMachine:ILaunchStateMachine
  private dataWrite: LaunchDataWrite

  constructor(context:ITigerAppContext, machine:ILaunchStateMachine,dataWrite:LaunchDataWrite) {
    this.appContext = context
    this.stateMachine = machine
    this.dataWrite = dataWrite
  }

  async run(task:LaunchStep):Promise<void> {

    //任务状态开始 标识处理
    const startState = task.getStartState()
    if (startState) {
      this.stateMachine.onChangeState(startState)
    }

    const taskKey = task.getDataKey()
    const taskData = await task.run()

    if (taskData) {
      const resultData:ExecuteInfo = {launchSetpData:{data:taskData.data,error:taskData.error}}
      if (resultData.launchSetpData.error) {
        this.stateMachine.onChangeState(startState,resultData)
        throw Error("启动任务出错，终止：" + JSON.stringify(resultData))
      }

      if (resultData.launchSetpData.data) {
        if (taskKey) {
          //存储
          this.dataWrite.setData(taskKey,resultData.launchSetpData.data)
        }
      }

      //任务状态结束 标识处理
      const endState = task.getEndState()
      if (endState) {
        this.stateMachine.onChangeState(endState,resultData)
      }
    }

  }
}