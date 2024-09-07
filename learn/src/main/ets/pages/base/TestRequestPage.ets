import httpRequestModel from '../../model/HttpRequestModel'
import { BusinessError } from '@kit.BasicServicesKit'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct TestRequestPage {

  aboutToAppear(): void {
    let pagrms = router.getParams() as Map<string,Object>
    let list = pagrms['lis'] as Array<string>
    console.log(`===== ${JSON.stringify(pagrms)}`)
    console.log(`===== ${JSON.stringify(list)}`)
    console.log(`===== ${JSON.stringify(list[0])}`)
  }

  build() {
    Column() {
      Button('http 请求')
        .onClick(()=>{
          httpRequestModel.reqLogin<string>()
            .then((value)=>{
              console.log('==== req success:')
              AlertDialog.show({message:JSON.stringify(value)})
            })
            .catch((err:BusinessError)=>{
              console.log(`==== req fail:${JSON.stringify(err)}`)
              AlertDialog.show({message:JSON.stringify(err)})

            })

        })


    }
    .width('100%')
  }
}