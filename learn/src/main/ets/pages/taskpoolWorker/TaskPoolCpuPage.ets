import taskpool from '@ohos.taskpool';


@Concurrent
function imageProcessing(dataSlice: ArrayBuffer) {
  // 步骤1: 具体的图像处理操作及其他耗时操作

  setTimeout(() => {
    return dataSlice;
  }, Math.random()*20000)
}

function histogramStatistic(pixelBuffer: ArrayBuffer) {
  // 步骤2: 分成三段并发调度
  let number = pixelBuffer.byteLength / 3;
  let buffer1 = pixelBuffer.slice(0, number);
  let buffer2 = pixelBuffer.slice(number, number * 2);
  let buffer3 = pixelBuffer.slice(number * 2);

  let task1 = new taskpool.Task(imageProcessing, buffer1);
  let task2 = new taskpool.Task(imageProcessing, buffer2);
  let task3 = new taskpool.Task(imageProcessing, buffer3);

  taskpool.execute(task1).then((ret) =>{
    console.log(`========= 1 ${JSON.stringify(ret)}`)
  })
  taskpool.execute(task2).then((ret) => {
    // 步骤3: 结果处理
    console.log(`========= 2 ${JSON.stringify(ret)}`)

  });
  taskpool.execute(task3).then((ret) => {
    // 步骤3: 结果处理
    console.log(`========= 3 ${JSON.stringify(ret)}`)

  });
}

@Entry
@Component
struct TaskPoolCpuPage {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let data: ArrayBuffer = new ArrayBuffer(100);
            histogramStatistic(data);
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}