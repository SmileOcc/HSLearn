
// ================ 有问题

/**
 * 网络请求
 */
import axios, { AxiosError, AxiosResponse, AxiosRequestHeaders,InternalAxiosRequestConfig,
  AxiosRequestConfig } from '@ohos/axios'
import errorCode from '../requestConfig/RequestErrorCode'
import toast from '../../../../../common_har/src/main/ets/utils/ToastUtils'
import router from '../../../../../common_har/src/main/ets/utils/RouterUtils'
import HttpConfigManager from '../requestConfig/HttpConfigManager'
import {HttpConstants} from '../requestConfig/HttpConstants'
import RequestErrorCode from '../requestConfig/RequestErrorCode'
import { ResultResponse } from './ResultResponse'
import { TestInfo } from './TestInfo'
import KLogger from '../../../../../common_har/src/main/ets/common/KLogger'

// import { ApiResponse, ResultResponse } from './ResultResponse'

// import SPUtils from '../utils/SPUtils'
// import SpConstants from '../net/SpConstants'

axios.defaults.headers['Content-Type'] = 'application/json;charset=utf-8'
// 创建axios实例
const service = axios.create({
  baseURL:HttpConstants.baseUrl,
  timeout:2500
})


//定义接口响应包装类
export interface BaseResponse {
  errorCode:number
  errorMsg:string
}

/**
 接口实现类包装，例如有其他业务可以再次继承实现xxxResponse
 */
export interface ApiResponse<T = object, D = HttpRequestConfig> extends BaseResponse {
  //wanAndroid-API响应体
  data: T | null;
  //拓展xxx-API响应体
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
  // responseInterceptor?: (response: AxiosResponse) => AxiosResponse | Promise<object>;
  responseInterceptor?: (response: ApiResponse) => ApiResponse | Promise<object>;
  responseInterceptorCatch?: (error: AxiosError) => AxiosError;
}

///////////////// =============== 添加响应拦截器
// request拦截器
service.interceptors.request.use(async (config:HttpRequestConfig) => {
  // 是否需要设置 token
  const access_token = await HttpConfigManager.getToken(HttpConstants.authToken)
  if (access_token != "") {
    config.headers['Authorization'] = 'Bearer ' + access_token // 让每个请求携带自定义token 请根据实际情况自行修改
  }
  config.headers['xpt'] = 'occ-xpt'
  KLogger.debug(`==== ${JSON.stringify(config)}`)
  return config
}, (error:string) => {
  KLogger.debug(error)
  Promise.reject(error)
})

service.interceptors.response.use((response: AxiosResponse) => {
  // 对响应数据做点什么
  // response.data.code 存在且不为 200 时，返回错误结果
  if (response.data?.code && response.data.code !== 200) {
    AlertDialog.show({
      message: response.data?.msg
    })
    KLogger.error('3-code响应错误：' + JSON.stringify(response.data))
    return Promise.reject(response.data)
  }
  KLogger.warn('2-响应成功结果：' + JSON.stringify(response.data))
  // 简化数据返回
  return response.data?.data;
}, (error: AxiosError) => {
  AlertDialog.show({ message: error.response?.status + '：' + error.message })
  KLogger.error('3-http响应错误：' + JSON.stringify(error))
  // 对响应错误做点什么
  return Promise.reject(error);
});





// // request拦截器
// service.interceptors.request.use(async (config:InternalAxiosRequestConfig) => {
//   // 是否需要设置 token
//   const access_token = await HttpConfigManager.getToken(HttpConstants.authToken)
//   if (access_token != "") {
//     config.headers['Authorization'] = 'Bearer ' + access_token // 让每个请求携带自定义token 请根据实际情况自行修改
//   }
//   return config
// }, (error:string) => {
//   console.log(error)
//   Promise.reject(error)
// })

// 响应拦截器
// service.interceptors.response.use((response:AxiosResponse<TestInfo,TestInfo>) => {

service.interceptors.response.use((response:AxiosResponse) => {


  let responstData = response.data as ResultResponse<object>
  if (responstData && responstData.isSuccess()) {
    //return responstData.data ?? ''
  }

  let code = response.status

  if (code == 200) {
    return response
  } else {
    return response
  }

  // let cc = response as ApiResponse
  // if (response is)
  //未设置状态码则默认成功状态
  // const code = res.data.code || 200;
  // const code = res.status || 200;

  // 获取错误信息
  // const msg =  //errorCode[code]  || erroCoed['default']
  // if (code === 401) {
  //   toast.show("登录状态已过期，您可以继续留在该页面，或者重新登录")
  //   router.goNot('pages/Login')
  // } else if (code === 500) {
  //   toast.show(msg)
  //   return Promise.reject(new Error(msg))
  // } else if (code !== 200) {
  //   toast.show(msg)
  //   return Promise.reject('error')
  // } else {
  //   return response
  // }
  return response;

},
  (error:AxiosError) => {
    console.log('err' + error)
    // let { message } = error;
    // if (message == "Network Error") {
    //   message = "后端接口连接异常";
    // }
    // else if (message.includes("timeout")) {
    //   message = "系统接口请求超时";
    // }
    // else if (message.includes("Request failed with status code")) {
    //   message = "系统接口" + message.substr(message.length - 3) + "异常";
    // }
    // toast.show(message)
    return Promise.reject(error)
  }
)


// 封装请求方法
export function apiRequest<DataModel = null, DataParams = null>(config: AxiosRequestConfig<DataParams>) {
  return service<null, DataModel>(config)
}
export default service
