import { apiRequest } from './AxiosRequest'

interface User {
  /** token令牌 */
  token: string
  /** 用户ID */
  id: string
  /** 用户名称 */
  account: string
  /** 手机号 */
  mobile: string
  /** 头像 */
  avatar: string
}

interface LoginParams {
  /** 手机号 */
  mobile: string,
  /** 密码 */
  password: string
}

export class HotelListItemModel {
  "id": number | undefined
  "name": string | undefined
  "totalReviewsNum": string | undefined
  "address": string | undefined
  "imageUrl": string | undefined
  "price": string | undefined
  "labelList": string[] = []
}


export class TestViewModel {

  // 登录并返回用户数据
  async login(data: LoginParams) {
    const resData = await apiRequest<User, LoginParams>({ url: '/login', method: 'post', data })
    return resData
  }

  async reqHotelList():Promise<HotelListItemModel[]>{
    return await new Promise((resolve, reject) =>{
      apiRequest<HotelListItemModel[]>({ url: '/roomList', method: 'get' })
    })

    // return await new Promise((resolve, reject) => {
    //   axios.get(
    //     `${this.baseUrl}/hotelList`,
    //   )
    //     // .then((resp:AxiosResponse) => {
    //     .then((resp:AxiosResponse<HotelListItemModel[]>) => {
    //       if (resp.status === 200) {
    //         console.log('===== success reqHotelRoomList')
    //         resolve(resp.data)
    //       } else {
    //         console.log('===== failure reqHotelRoomList')
    //         console.log('===== axios--失败',JSON.stringify(resp))
    //         reject('查询失败')
    //       }
    //
    //     }).catch((err:AxiosError)=> {
    //     console.log('===== axios--失败 cat ',JSON.stringify(err))
    //
    //     reject('查询失败')
    //
    //   })
    // })
  }
}