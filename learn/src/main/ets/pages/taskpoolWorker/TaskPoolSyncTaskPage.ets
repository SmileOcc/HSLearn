// Index.ets代码
import taskpool from '@ohos.taskpool';
import { hsLog } from '@learn/logger_har';
import requestModelAxios from '../../model/RequestModelAxios';
import { UserInfoModel } from '../accountInfo/model/UserInfoModel';
import Handle from './TaskPoolHand'; // 返回静态句柄
import { process } from '@kit.ArkTS';


// 步骤1: 定义并发函数，内部调用同步方法
@Concurrent
function func(num: number) {
  // 调用静态类对象中实现的同步等待调用
  Handle.syncSet(num);
  // 或者调用单例对象中实现的同步等待调用
  return true;
}

// 步骤2: 创建任务并执行
async function asyncGet() {
  // 创建task并传入函数func
  let task = new taskpool.Task(func, 1);
  // 执行task任务，获取结果res
  let res = await taskpool.execute(task);
  // 对同步逻辑后的结果进行操作
  console.info(String(res));
}

@Entry
@Component
struct TaskPoolSyncTaskPage {
  @State message: string = 'Hello World';

  aboutToAppear(): void {
    // requestModelAxios.reqUserInfoTwo()
    //   .then(value => {
    //     let localUseInf:UserInfoModel = value//JSON.parse(value.toString())
    //     AlertDialog.show({message:JSON.stringify(localUseInf)})
    //
    //   })
    //   .catch((error:string) => {
    //     AlertDialog.show({message:error})
    //
    //   })


  }

  multPromssAll() {

    process.isIsolatedProcess()
    let mainTid = process.tid

    //多个promiss.all请求, 成功按 请求顺序返回，失败返回最先失败的那一个
    requestModelAxios.testPromisAll()
      .then(value => {
        let arrList = value as []
        for (let i=0;i<arrList.length;i++) {
          let itmeValue = arrList[i]
          AlertDialog.show({message:JSON.stringify(itmeValue)})

        }

      })
      .catch((error:object) => {
        AlertDialog.show({message:JSON.stringify(error)})

      })
  }

  multRequest() {
    hsLog.d('===== taskpool taskpool')
    // let task: taskpool.Task = new taskpool.Task(requestModelAxios.reqUserInfoTwo);
    // let task2: taskpool.Task = new taskpool.Task(requestModelAxios.reqCommentsList);
    // let task3: taskpool.Task = new taskpool.Task(requestModelAxios.reqUserOrderList);

    // taskpool.execute(task).then((ret) =>{
    //   console.log(`========= 1:`)
    //   console.log(`========= 1 ${JSON.stringify(ret)}`)
    // }).catch((error:Error) =>{
    //   AlertDialog.show({message:JSON.stringify(error)})
    // });
    // hsLog.d('===== taskpool res1')
    //
    // taskpool.execute(task2).then((ret) =>{
    //   console.log(`========= 2:`)
    //   console.log(`========= 2 ${JSON.stringify(ret)}`)
    // });
    // hsLog.d('===== taskpool res2')
    //
    //
    // taskpool.execute(task3).then((ret) =>{
    //   console.log(`========= 3:`)
    //   console.log(`========= 3 ${JSON.stringify(ret)}`)
    // });
    // hsLog.d('===== taskpool res3')


  }
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            // 步骤3: 执行并发操作
            asyncGet();
          })
        Button('promiss.all 多请求 ok')
          .onClick(()=>{
            this.multPromssAll()
          })

        Button('taskpool 多请求 还不行')
          .onClick(()=>{
            this.multRequest()
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}



