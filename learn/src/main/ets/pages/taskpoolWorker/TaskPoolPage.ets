import taskpool from '@ohos.taskpool';


//在使用TaskPool时，执行的并发函数需要使用该装饰器修饰，否则无法通过相关校验
@Concurrent
function add(num1: number, num2: number) {
  return num1 + num2;
}

async function ConcurrentFunc(): Promise<void> {
  try {
    let task: taskpool.Task = new taskpool.Task(add, 1, 2);
    console.info("==== taskpool res is: " + await taskpool.execute(task));
  } catch (e) {
    console.error("==== taskpool execute error is: " + e);
  }
}

@Entry
@Component
struct TaskPoolPage {
  @State message: string = 'TaskPoolPage'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            ConcurrentFunc();
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
