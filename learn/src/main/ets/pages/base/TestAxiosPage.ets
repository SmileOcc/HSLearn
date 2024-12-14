import { axiosCommonApi, axiosInstance, getUserApi, IApiResultData, IApiParams,
  IApiResponse,
  ApiRequestType,
  apiRequest} from '@learn/request_har';
import { AxiosError } from '@ohos/axios';
import loginModelAxios from '../../model/RequestModelAxios'
import { UserInfoModel } from '../accountInfo/model/UserInfoModel';

@Entry
@Component
struct TestAxiosPage {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Button('axios regqte 封装通用 OK')
          .onClick(()=>{
            this.testCommonApi()//ok

          })
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


            // reqModel.reqHotelList()
            //   .then((value:HotelListItemModel[])=>{
            //     console.log('==== req success:')
            //     AlertDialog.show({message:JSON.stringify(value)})
            //   })
            //   .catch((err:AxiosError)=>{
            //     console.log(`==== req fail:${JSON.stringify(err)}`)
            //     AlertDialog.show({message:JSON.stringify(err)})
            //
            //   })

            // reqModel.reqOther()
            //   .then((value:string)=>{
            //     console.log('==== req success:')
            //     AlertDialog.show({message:JSON.stringify(value)})
            //   })
            //   .catch((err:AxiosError)=>{
            //     console.log(`==== req fail:${JSON.stringify(err)}`)
            //     AlertDialog.show({message:JSON.stringify(err)})
            //
            //   })


          })
      }
      .width('100%')
    }
    .height('100%')
  }

  async testCommonApi() {

    //这种方式合适，给data定了类型 ok
    try {
      let resultData3 = await apiRequest<IUserInfo,ILoginParams>({
        url: '/user/login',
        method: 'post',
        params:{"username":"www12123","password":"123456"} as ILoginParams,
      }) as IApiResponse<IUserInfo>
    } catch (e) {
    }
    
    //
    // let userInfo:IUserInfo = resultData3.data as IUserInfo
    // let nickName = resultData3.data?.nickname
    // let nickName2 = userInfo.nickname



    //返回数据, 里面已经try catch了 ok
    let resultData6 = await axiosCommonApi("/roomList",ApiRequestType.get,undefined,undefined)




    let resultData7 = await apiRequest<HotelListInfo[],ILoginParams>({
      url: '/roomList',
      method: 'get'
    }) as IApiResponse<HotelListInfo[]>

    let list = resultData7.data
    for (let item of list ?? []) {

      let roomName: string = item.roomName ?? ""
      let img = item.imageUrl
    }

    let resultData = await getUserApi({"username":"www12123","password":"123456"} as ILoginParams)

    let str = JSON.stringify(resultData) as string

    let resultData2 = await axiosInstance<IUserInfo,ILoginParams>({
        url: '/user/login',
        method: 'post',
      params:{"username":"www12123","password":"123456"} as ILoginParams
    })



    //
    // let resultData4 = await apiRequest<IApiData,IApiParams>({
    //   url: '/user/login',
    //   method: 'post',
    //   params:{"username":"www12123","password":"123456"} as ILoginParams
    // }) as IApiResponse

  }
}

interface ILoginParams extends IApiParams {
  username:string
  password:string
}

interface IUserInfo extends  IApiResultData {
  admin: boolean;
  chapterTops: ESObject[];
  coinCount: number;
  collectIds: ESObject[];
  email: string;
  icon: string;
  id: number;
  nickname: string;
  password: string;
  publicName: string;
  token: string;
  type: number;
  username: string;
}

export class HotelListInfo implements IApiResultData{
  "id": number | undefined
  "name": string | undefined
  "roomName": string | undefined
  "totalReviewsNum": string | undefined
  "address": string | undefined
  "imageUrl": string | undefined
  "price": string | undefined
  "labelList": string[] = []
}