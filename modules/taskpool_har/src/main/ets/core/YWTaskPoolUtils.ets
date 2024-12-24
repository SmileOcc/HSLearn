import { taskpool } from "@kit.ArkTS";

export class YWTaskPoolUtils {
  private static taskRunner?:taskpool.SequenceRunner

  static serialRun(task:taskpool.Task){
    if (YWTaskPoolUtils.taskRunner == undefined) {
      YWTaskPoolUtils.taskRunner = new taskpool.SequenceRunner()
    }
    YWTaskPoolUtils.taskRunner.execute(task)
  }

}