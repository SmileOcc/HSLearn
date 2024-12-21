import { BusinessError } from '@kit.BasicServicesKit';
import { getCurrentTime, kyStoreManger } from '@learn/common_har';

@Entry
@Component
struct TestKVStorePage {
  @State message: string = '分布式键值数据库 distributedKVStore';

  aboutToAppear(): void {

    let timestr = getCurrentTime()
    kyStoreManger.putData("ksKey_name",`{\"msg\":\"${timestr}\",\"code\":200}`)

    setTimeout(() => {
      kyStoreManger.getData<string>("ksKey_name","").then((value:string)=> {
        console.debug(`===== ${value}`)

        this.message = value
      }).catch((err:BusinessError)=> {

      })


    }, 2000)
  }
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}