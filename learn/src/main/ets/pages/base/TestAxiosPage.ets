import { AxiosError } from '@ohos/axios';
import { HotelListItemModel, TestViewModel } from '../../../../../../modules/request_har/src/main/ets/AxiosRequest/TestViewModel';
import loginModelAxios from '../../model/RequestModelAxios'

@Entry
@Component
struct TestAxiosPage {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Button('http 请求')
          .onClick(()=>{
            loginModelAxios.reqLogin()
              .then((value:Object)=>{
                console.log('==== req success:')
                AlertDialog.show({message:JSON.stringify(value)})
              })
              .catch((err:AxiosError)=>{
                console.log(`==== req fail:${JSON.stringify(err)}`)
                AlertDialog.show({message:JSON.stringify(err)})

              })

          })

        Button('http 请求 全局')
          .onClick(()=>{
            loginModelAxios.reqHotelRoomList()
              .then((value:Object)=>{
                console.log('==== req success:')
                AlertDialog.show({message:JSON.stringify(value)})
              })
              .catch((err:AxiosError)=>{
                console.log(`==== req fail:${JSON.stringify(err)}`)
                AlertDialog.show({message:JSON.stringify(err)})

              })

          })

        Button('http 请求 未实现')
          .onClick(()=>{
            loginModelAxios.reqGetLogin()
              // .then((value)=>{
              //   console.log('==== req success: gg')
              //   AlertDialog.show({message:JSON.stringify(value)})
              // })
              // .catch((err:AxiosError)=>{
              //   console.log(`==== req fail:${JSON.stringify(err)}`)
              //   AlertDialog.show({message:JSON.stringify(err)})
              //
              // })

          })

        Button('axiosGetData 请求')
          .onClick(()=>{
            loginModelAxios.axiosGetData()
              // .then((value)=>{
              //   console.log('==== req success:')
              //   AlertDialog.show({message:JSON.stringify(value)})
              // })
              // .catch((err:AxiosError)=>{
              //   console.log(`==== req fail:${JSON.stringify(err)}`)
              //   AlertDialog.show({message:JSON.stringify(err)})
              //
              // })

          })

        Button('http 请求')
          .onClick(()=>{
            loginModelAxios.getUser()
              .then((value:string)=>{
                console.log('==== req success:')
                AlertDialog.show({message:JSON.stringify(value)})
              })
              .catch((err:AxiosError)=>{
                console.log(`==== req fail:${JSON.stringify(err)}`)
                AlertDialog.show({message:JSON.stringify(err)})

              })

          })

        Button('axios regqte 有问题')
          .onClick(()=>{

            let reqModel = new TestViewModel()

            reqModel.reqHotelList()
              .then((value:HotelListItemModel[])=>{
                console.log('==== req success:')
                AlertDialog.show({message:JSON.stringify(value)})
              })
              .catch((err:AxiosError)=>{
                console.log(`==== req fail:${JSON.stringify(err)}`)
                AlertDialog.show({message:JSON.stringify(err)})

              })

          })
      }
      .width('100%')
    }
    .height('100%')
  }
}