import { http } from "@kit.NetworkKit"
import { promptAction, router } from "@kit.ArkUI"

// 一、提取所有请求的url中的域名当做一个基本地址
const httpBaseUrl = 'https://api-harmony-teach.itheima.net/hm/'

export class HdHttp {
  // 1.统一封装post请求方法
  static async post<T>(url: string, extraData?: Object) {
    try {
      // 1.0 创建http请求对象，并将请求对象命名为options
      const httpReq = http.createHttp()
      let options: http.HttpRequestOptions = {
        method: http.RequestMethod.POST,
        header: {
          "Content-Type": "application/json"
        },
        expectDataType: http.HttpDataType.OBJECT
      }
      // 1.1 判断extraData可选参数如果不为空，则要将其追加到options对象中
      if (extraData) {
        options.extraData = extraData
      }
      // 1.2从AppStorage('user')中获取数据token，如果有值则追加到options.header中的Authorization
      //let user = AppStorage.get('user') as iLoginUserModel
      // 使用user?写法，就能规避bug：在undefined上点出token这个属性报错
      //let token = user?.token
      let token = ""
      if (token && options.header) {
        options.header['Authorization'] = `Bearer ${token}`
      }

      // 1.3 将动态构建好的options参数和url传给request->发请求获取服务器的响应数据
      url = httpBaseUrl + url
      let res = await httpReq.request(url, options)

      AlertDialog.show({message:JSON.stringify(res.result,null,2)})

      // 1.5 优化功能:增加对登录是否成功的校验
      // 增加服务器响应的code如果为401,是token失效，则重新登录获取新的有效token
      let resdata = res.result as iResponseModel

      // 如果服务器响应回来的数据不为10000，则表示有错误，则提示出错误信息
      if (resdata.code !== 10000) {
        // 如果服务器响应回来的code为401表示token失效，应该重新登录
        if (resdata.code === 401) {
          //   token失效，重新登录
          promptAction.showToast({ message: 'token失效，请重新登录' })
          router.replaceUrl({ url: 'pages/LoginPage' })
        } else {
          promptAction.showToast({ message: resdata.message })
        }
      }

      // 1.4 将服务器的数据返回
      return resdata
    } catch (err) {
      promptAction.showToast({ message: '网络请求错误' })
      return Promise.reject(err)
    }
  }
}

interface iResponseModel {
  code?:number
  message?:string
}

