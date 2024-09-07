import { ITigerAppContext } from '../ITigerAppContext';
import { LaunchStep } from '../task/LaunchStep';
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

    const taskKey = task.getDataKey()
    const taskData = await task.run()

    if (taskKey && taskData) {
      //存储
      this.dataWrite.setData(taskKey,taskData)
    }


    //任务状态结束 标识处理
    const endState = task.getEndState()
  }
}