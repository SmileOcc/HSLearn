import { IAppTask, TaskType } from "@learn/learn_task_har"

interface ILaunchTask {
  stageTask:(context:Context) => (()=>IAppTask)[]
  abilityTask:(context:Context) => (()=>IAppTask)[]

  // abilityTask:((()=>IAppTask)[])
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


  //测试
  async handTaskTest(taskList:((context:Context) => (()=>IAppTask))[]) {
    this.taskCount++

    let contexxt:Context = globalThis.getContext()
    for (const itemTask of taskList) {
      const task = itemTask(contexxt)()
      if (task.type() == TaskType.main) {
        await task.run()
      } else {
        task.run()
      }
    }
    this.taskCount--
  }

  //测试2
  async handTask2(context:Context, taskList:(context:Context) => (()=>IAppTask)[]) {
    this.taskCount++

    // let contexxt:Context = globalThis.getContext()
    for (const itemTask of taskList(context)) {
      const task = itemTask()
      if (task.type() == TaskType.main) {
        await task.run()
      } else {
        task.run()
      }
    }
    this.taskCount--
  }
}

export const ywManagerTask = new YWManagerTask()