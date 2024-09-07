import { http } from '@kit.NetworkKit'
import { promptAction, router } from '@kit.ArkUI'
import { HttpConstants } from '../requestConfig/HttpConstants'

export class TestInfo{




}

export class Result<T> {
  code: number = 0
  msg: string = ""
  data: T | null = null
}


const httpRequest = http.createHttp()

async function requestHttp<T>(url: string = "", method: http.RequestMethod = http.RequestMethod.GET, data?: object): Promise<T> {
  let urlStr = HttpConstants.baseUrl + url
  // 手动拼接
  if (method === http.RequestMethod.GET) {
    if (data && Object.keys(data).length) {
      urlStr += "?" + Object.keys(data).map(key =>  {
        if(data[key]){
          return `${key}=${data[key]}`
        }
        return ""
      }).join('&')
    }
  }
  // 设置请求头
  const config: http.HttpRequestOptions = {
    header: {
      'Content-Type': 'application/json',
      // "Authorization": AppStorage.Get(TOKEN_KEY) || ""
    },
    method,
    readTimeout: 10000, // 超时时间
    extraData: method === http.RequestMethod.GET ? "" : data
  }
  try {
    const res = await httpRequest.request(urlStr, config)
    if (res.responseCode === 401) {
      promptAction.showToast({ message: 'token超时' })
      // AppStorage.Set(TOKEN_KEY, "") // 删除token
      // new UserSettingClass(getContext()).setUserToken("") // 清空首选项的token
      router.replaceUrl({
        url: 'pages/Login/Login'
      })
      return Promise.reject(new Error("token不存在或超时"))
    }else if(res.responseCode === 404) {
      promptAction.showToast({ message: '请求地址不正确' })
      return Promise.reject(new Error('请求地址不正确'))
    }
    else {
      const result = JSON.parse(res.result as string) as Result<T>
      if (result.code === 200) {
        // 执行成功
        return result.data as T // 直接返回数据
      }
      else {
        promptAction.showToast({ message: '服务器异常' })
        return Promise.reject(new Error(result.msg))
      }
    }
  } catch (error) {
    promptAction.showToast({ message: error.message })
    return Promise.reject(error)
  }
  finally {
    httpRequest.destroy(); // 销毁请求
  }
}

// 导出一个类的静态方法
export class Request {
  static get<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.GET, data)
  }

  static post<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.POST, data)
  }

  static delete<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.DELETE, data)
  }

  static put<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.PUT, data)
  }
}


export const getHomeData = (data?: object) => {
  return Request.post<TestInfo>("/home/homeData", data)
}


// 使用接口，这里我用async await回调，parmsReq是参数，也可以用then 看个人习惯！
// async getHomeData() {
//   try {
//     const homeData = await getHomeData()
//   } catch (error) {
//   } finally {
//   }
// }