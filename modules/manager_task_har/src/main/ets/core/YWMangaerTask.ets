import { IAppTask, TaskType } from "@learn/learn_task_har"

interface ILaunchTask {
  stageTask:((()=>IAppTask)[])
  abilityTask:((()=>IAppTask)[])
}

class YWManagerTask {
  launchTask?:ILaunchTask

  init(task:ILaunchTask) {

    this.launchTask = task
  }

  taskCount = 0
  async handTask(taskList:(()=>IAppTask)[]) {
    this.taskCount++

    for (const itemTask of taskList) {
      const task = itemTask()
      if (task.type() == TaskType.main) {
        await task.run()
      } else {
        task.run()
      }
    }
    this.taskCount--
  }

  isFinish():boolean {
    return this.taskCount == 0
  }
}

export const ywManagerTask = new YWManagerTask()