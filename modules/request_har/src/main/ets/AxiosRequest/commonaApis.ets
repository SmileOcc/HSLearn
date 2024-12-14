import { AxiosError } from "@ohos/axios"
import { axiosInstance, IApiParams, IApiResponse,IApiResultData, ApiRequestType, IApiBodyData } from "./AxiosRequest"
import { JSON } from "@kit.ArkTS"

export const getUserApi = async (params:IApiParams) => {
  try {
    const resData = await axiosInstance<IApiResultData, IApiParams>({
      url: '/user/login',
      method: ApiRequestType.post, params })
    return resData
  } catch (error) {
    let kkk = JSON.stringify(error)
    let  bb = ""
  }

  return null

}


export const getCommonApi = async (url:string,  params:IApiParams) => {
  const resData = await axiosInstance<IApiResultData, IApiParams>({
    url: url,
    method: ApiRequestType.get,
    params }) as IApiResponse<IApiResultData>

  return resData.data

}

export const axiosCommonApi = async (url:string, type?:ApiRequestType, params?:IApiParams, data?:IApiBodyData) => {
  try {
    const resData = await axiosInstance<IApiResultData, IApiParams>({
      url: url,
      method: type ? type : 'get',
      params,//参数
      data//请求体
    }) as IApiResponse<IApiResultData>

    return resData.data
  } catch (e) {

  }
  return null
}
