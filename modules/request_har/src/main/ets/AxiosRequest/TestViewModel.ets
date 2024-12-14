import { axiosInstance } from './AxiosRequest'

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
    const resData = await axiosInstance<User, LoginParams>({ url: '/login', method: 'post', data })
    return resData
  }

  async reqHotelList():Promise<HotelListItemModel[]>{
    return await new Promise((resolve, reject) =>{
      axiosInstance<HotelListItemModel[]>({ url: '/roomList', method: 'get' })
    })

  }


}

export interface IServerResponse {
  data: User;
  errorCode: number;
  errorMsg: string;
}