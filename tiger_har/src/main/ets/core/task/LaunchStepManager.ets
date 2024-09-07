import { TigerGlobalThis } from '../TigerGlobalThis'
import { IBaseStep } from './IBaseStep'

export class TaskManager {

  taskList:Array<IBaseStep> = new Array()

  async commit():Promise<void> {
    for (let i=0; i<this.taskList.length; i++) {
      let task = this.taskList[i]

      let taskData = await task.run()

      if (taskData) {
        //持有
        // TigerGlobalThis.getInstance().setAttribute(task.getDataKey(),taskData)
      }
    }
  }


}