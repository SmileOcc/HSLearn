import { YWShowToast } from '@learn/YWRandomUtils'

/**
 * 网络请求
 */
import axios, { AxiosError, AxiosResponse, AxiosRequestHeaders,InternalAxiosRequestConfig,
  AxiosRequestConfig } from '@ohos/axios'
import KLogger from '../../../../../common_har/src/main/ets/common/KLogger'
import { HttpConstants } from '../requestConfig/HttpConstants'


axios.defaults.headers['Content-Type'] = 'application/json;charset=utf-8'
// 创建axios实例
const axiosInstance = axios.create({
  baseURL:HttpConstants.baseUrl,//odd测试数据
  // baseURL:"https://www.wanandroid.com",

  timeout:2500,
  headers: { 'Content-Type': 'application/json' },

})

enum ApiRequestType {
  get = "get",
  post = "post",
}
//请求参数
interface IApiParams {}
//请求结果数据
interface IApiResultData {}
//请求body
interface IApiBodyData {}


//定义接口响应包装类
interface BaseResponse {
  errorCode:number
  errorMsg:string
}

/**
 接口实现类包装，例如有其他业务可以再次继承实现xxxResponse
 */
interface IApiResponse<T = IApiResultData> extends BaseResponse {
  data: T | null;
}



interface HttpRequestConfig extends InternalAxiosRequestConfig {
  showLoading?: boolean; //是否展示请求loading
  checkResultCode?: boolean; //是否检验响应结果码
  checkLoginState?: boolean //校验用户登陆状态
  needJumpToLogin?: boolean //是否需要跳转到登陆页面
  interceptorHooks?: InterceptorHooks;
  // headers?: AxiosRequestHeaders
}


/**

 封装后，不支持传入拦截器
 需要自己定义接口继承 AxiosRequestConfig类型
 从而支持传入拦截器，但拦截器选项应为可选属性
 之后请求实例传入的options为继承了AxiosRequestConfig的自定义类型
 */

interface InterceptorHooks {
  requestInterceptor?: (config: HttpRequestConfig) => Promise<object>;
  requestInterceptorCatch?: (error: AxiosError) => AxiosError;
  responseInterceptor?: (response: AxiosResponse<IApiResponse<object>>) => AxiosResponse | Promise<object>;
  // responseInterceptor?: (response: IApiResponse) => IApiResponse | Promise<object>;
  responseInterceptorCatch?: (error: AxiosError) => AxiosError;
}

///////////////// =============== 添加响应拦截器
// request拦截器
axiosInstance.interceptors.request.use(async (config:HttpRequestConfig) => {
  // 是否需要设置 token
  // const access_token = await HttpConfigManager.getToken(HttpConstants.authToken)
  // if (access_token != "") {
  //   config.headers['Authorization'] = 'Bearer ' + access_token // 让每个请求携带自定义token 请根据实际情况自行修改
  // }
  // config.headers['xpt'] = 'occ-xpt'
  KLogger.debug(`==== ${JSON.stringify(config)}`)
  return config
}, (error:string) => {
  KLogger.debug(error)
  return Promise.reject(error)
})

//第一次拦截简化，直接返回data 或在拦截处理（一般拦截一次）
axiosInstance.interceptors.response.use((response: AxiosResponse) => {
  // 对响应数据做点什么
  // response.data.code 存在且不为 200 时，返回错误结果
  if (response.status !== 200) {
    AlertDialog.show({
      message: response.statusText
    })
    KLogger.error('3-code响应错误：' + JSON.stringify(response.data))
    return Promise.reject(response.data)
  }
  KLogger.warn('2-响应成功结果：' + JSON.stringify(response.data))
  // 简化数据返回,可以根据自己需要，返回对应设置的层级数据
  // return response
  //返回数组
  if (response.data instanceof Array) {
    return response
  }
  //返回字符串
  if (response.data instanceof  String) {
    return response
  }
  //返回数据data.data的，可以根据后台返回数据统一处理
  return response.data

}, (error: AxiosError) => {
  YWShowToast(error.response?.status + '：' + error.message)
  KLogger.error('3-http响应错误：' + JSON.stringify(error))
  // 对响应错误做点什么
  return Promise.reject(error);
});



// 使用示例
// let resultData4 = await apiRequest<IApiData,IApiParams>({
//   url: '/user/login',
//   method: 'post',
//   params:{"username":"www12123","password":"123456"} as ILoginParams,
//   data:{}
// }) as IApiResponse

// 封装请求方法，直接返回第二层data
function apiRequest<T, D = null>(config: AxiosRequestConfig<D>):Promise<IApiResponse<T>> {
  return axiosInstance<null, IApiResponse<T>, D>(config)
}

// 封装请求方法，直接返回第一层data
// function apiRequest2<T, D = null>(config: AxiosRequestConfig<D>):Promise<AxiosResponse<IApiResponse<T>>> {
//   return axiosInstance<null, AxiosResponse<IApiResponse<T>>, D>(config)
// }

export { axiosInstance, IApiResponse, IApiParams,IApiBodyData, IApiResultData, apiRequest, ApiRequestType}









// 响应拦截器 第二次 会得到第一次处理后的数据
// service.interceptors.response.use((response:AxiosResponse<TestInfo,TestInfo>) => {

// service.interceptors.response.use((response:AxiosResponse) => {
//
//
//   // let responstData = response as ApiResponse<object>
//   // if (responstData && responstData.isSuccess()) {
//   //   //return responstData.data ?? ''
//   // }
//
//   //第一次拦截已经判断数据逻辑了 或第一次直接返回，把这个第二次拦截注释掉
//   return response.data
//
//   // let cc = response as ApiResponse
//   // if (response is)
//   //未设置状态码则默认成功状态
//   // const code = res.data.code || 200;
//   // const code = res.status || 200;
//
//   // 获取错误信息
//   // const msg =  //errorCode[code]  || erroCoed['default']
//   // if (code === 401) {
//   //   toast.show("登录状态已过期，您可以继续留在该页面，或者重新登录")
//   //   router.goNot('pages/Login')
//   // } else if (code === 500) {
//   //   toast.show(msg)
//   //   return Promise.reject(new Error(msg))
//   // } else if (code !== 200) {
//   //   toast.show(msg)
//   //   return Promise.reject('error')
//   // } else {
//   //   return response
//   // }
//   return response;
//
// },
//   (error:AxiosError) => {
//     console.log('err' + error)
//     // let { message } = error;
//     // if (message == "Network Error") {
//     //   message = "后端接口连接异常";
//     // }
//     // else if (message.includes("timeout")) {
//     //   message = "系统接口请求超时";
//     // }
//     // else if (message.includes("Request failed with status code")) {
//     //   message = "系统接口" + message.substr(message.length - 3) + "异常";
//     // }
//     // toast.show(message)
//     return Promise.reject(error)
//   }
// )
