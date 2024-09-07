import axios, { AxiosError, AxiosProgressEvent, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { UserInfoModel } from '../pages/accountInfo/model/UserInfoModel';
import { FormData } from '@ohos/axios'
import fs from '@ohos.file.fs'; // 导入文件管理模块
import { HttpConstants } from '../../../../../modules/request_har/src/main/ets/requestConfig/HttpConstants';
import { HotelListItemModel } from '../../../../../modules/request_har/src/main/ets/AxiosRequest/TestViewModel';
import { OrderItemInfo } from '../pages/accountInfo/model/OrderItemInfo';
import { ReviewModel } from '../pages/accountInfo/model/ReviewModel';
import KLogger from '../../../../../modules/common_har/src/main/ets/common/KLogger';
import { taskpool } from '@kit.ArkTS';


// 创建实例时配置默认值
const instance = axios.create({
  baseURL: HttpConstants.baseUrl
});

// 创建实例后修改默认值
instance.defaults.headers.common['Authorization'] = 'auth_token';
instance.defaults.baseURL = HttpConstants.baseUrl
instance.defaults.headers.common['Authorization'] = 'auth_token'
instance.defaults.headers.patch['Content-Type'] = 'application/x-www-form-urlencoded'
// 现在，所有使用此实例的请求都将等待2.5秒，然后才会超时
instance.defaults.timeout = 2500;

// 添加请求拦截器
instance.interceptors.request.use((config:InternalAxiosRequestConfig) => {
  // 对请求数据做点什么
  KLogger.debug('=========0 添加请求拦截器')
  KLogger.debug(`========= ${JSON.stringify(config)}`)
  return config;
}, (error:AxiosError) => {
  // 对请求错误做些什么
  return Promise.reject(error);
});

// 添加响应拦截器
instance.interceptors.response.use((response:AxiosResponse)=> {
  // 对响应数据做点什么

  KLogger.debug('=========1 添加响应拦截器')
  KLogger.debug(`========= ${JSON.stringify(response.data)}`)
  AlertDialog.show({message:JSON.stringify(response.data)})
  return response;
}, (error:AxiosError)=> {
  // 对响应错误做点什么
  return Promise.reject(error);
});


class RequestModelAxios{
  // baseUrl:string = 'http://192.168.10.204:3000'
  baseUrl:string = 'http://172.20.10.12:3000'

  url = 'http://rap2api.taobao.org/app/mock/293606/api/chat/list';

  async reqLogin(){
    //全局 axios 默认值
    // axios.defaults.baseURL = ''
    // axios.defaults.headers.common['Authorization'] = 'auth_token'
    // axios.defaults.headers.patch['Content-Type'] = 'application/x-www-form-urlencoded'

    // // 添加请求拦截器
    // axios.interceptors.request.use((config:InternalAxiosRequestConfig) => {
    //   // 对请求数据做点什么
    //   return config;
    // }, (error:AxiosError) => {
    //   // 对请求错误做些什么
    //   return Promise.reject(error);
    // });
    //
    //
    // // 添加响应拦截器
    // axios.interceptors.response.use((response:AxiosResponse)=> {
    //   // 对响应数据做点什么
    //   return response;
    // }, (error:AxiosError)=> {
    //   // 对响应错误做点什么
    //   return Promise.reject(error);
    // });


    let resp:AxiosResponse = await instance.get(
      // `${this.baseUrl}/saas-api/user/login`,
      `${this.url}`,

      { params: { key: "value" } }
      // {
      //   headers:{
      //     'X-Tenant-ID':'1'
      //   }
      // }
    )

    if(resp.status === 200){
      KLogger.debug('=====cccd')
      KLogger.debug(resp.status + '')
      KLogger.debug(`==== axios--成功 ${JSON.stringify(resp.data)}`)
      return resp.data
    }
    //查询失败
    KLogger.debug('axios--失败',JSON.stringify(resp))
  }

  async reqHotelRoomList(){


    let resp:AxiosResponse = await instance.get(
      // `${this.baseUrl}/saas-api/user/login`,
      `/roomList`,

      { params: { key: "value" } }
      // {
      //   headers:{
      //     'X-Tenant-ID':'1'
      //   }
      // }
    )

    if(resp.status === 200){
      KLogger.debug('=====cccd')
      KLogger.debug(resp.status + '')
      KLogger.debug(`==== axios--成功 ${JSON.stringify(resp.data)}`)
      return resp.data
    }
    //查询失败
    KLogger.debug('axios--失败',JSON.stringify(resp))
  }

  async reqUserInfo(){
    let resp:AxiosResponse = await axios.get(
      `${this.baseUrl}/user`,

      // { params: { key: "value" } }
      // {
      //   headers:{
      //     'X-Tenant-ID':'1'
      //   }
      // }
    )

    if(resp.status === 200){
      KLogger.debug('===== success reqHotelList')
      KLogger.debug(`==== axios--成功 ${JSON.stringify(resp.data)}`)
      return resp.data
    }
    //查询失败
    KLogger.debug('===== failure reqHotelList')
    KLogger.debug('axios--失败',JSON.stringify(resp))
  }



  async  reqUserInfoTwo():Promise<UserInfoModel>{
    return await new Promise((resolve, reject) => {
      axios.get(
        `${this.baseUrl}/user`,
      )
        // .then((resp:AxiosResponse) => {
          .then((resp:AxiosResponse<UserInfoModel>) => {
        if (resp.status === 200) {
          KLogger.debug('===== success reqUserInfoTwo')
          resolve(resp.data)
        } else {
          KLogger.debug('===== failure reqUserInfoTwo')
          KLogger.debug('===== axios--失败',JSON.stringify(resp))
          reject({'msg':'查询失败user','code':'408'})
        }

      }).catch((err:AxiosError)=> {
        KLogger.debug('===== axios--失败 cat ',JSON.stringify(err))

        reject({'msg':'查询失败user','code':'408'})

      })


    })
  }

  async  reqUserInfoTaskPoolTwo():Promise<UserInfoModel>{
    return await new Promise((resolve, reject) => {
      axios.get(
        `${this.baseUrl}/user`,
      )
        // .then((resp:AxiosResponse) => {
        .then((resp:AxiosResponse<UserInfoModel>) => {
          if (resp.status === 200) {
            KLogger.debug('===== success reqUserInfoTwo')
            resolve(resp.data)
          } else {
            KLogger.debug('===== failure reqUserInfoTwo')
            KLogger.debug('===== axios--失败',JSON.stringify(resp))
            reject('查询失败')
          }

        }).catch((err:AxiosError)=> {
        KLogger.debug('===== axios--失败 cat ',JSON.stringify(err))

        reject('查询失败')

      })


    })
  }

  async testPromisAll():Promise<object> {
    let tas = this.reqUserInfoTwo()
    let tass = this.reqCommentsList()
    let tasss = this.reqUserOrderList()
    return Promise.all([tas,tass,tasss])
  }


  /*
     * 评论列表
     * */
  async reqCommentsList():Promise<ReviewModel[]>{
    return await new Promise((resolve, reject) => {
      axios.get(
        `${this.baseUrl}/comments`,
      )
        .then((resp:AxiosResponse<ReviewModel[]>) => {
          if (resp.status === 200) {
            KLogger.debug('===== success reqHotelRoomList')
            resolve(resp.data)
          } else {
            KLogger.debug('===== failure reqHotelRoomList')
            KLogger.debug('===== axios--失败',JSON.stringify(resp))
            reject({'msg':'查询失败comments','code':'408'})
          }

        }).catch((err:AxiosError)=> {
        KLogger.debug('===== axios--失败 cat ',JSON.stringify(err))

        reject({'msg':'查询失败comments','code':'408'})

      })
    })

  }

  /*
   * 提交评论
   * */
  async postComment(params:ReviewModel):Promise<Object>{
    return await new Promise((resolve, reject) => {
      axios.post<string,AxiosResponse<string>,ReviewModel>(
        `${this.baseUrl}/comments`,
        params
      )
        // .then((resp:AxiosResponse) => {
        .then((resp:AxiosResponse) => {
          if (resp.status === 201) {
            KLogger.debug('===== success postUserOrder')
            resolve(resp.data)
          } else {
            KLogger.debug('===== failure postUserOrder')
            KLogger.debug('===== axios--失败',JSON.stringify(resp))

            reject('查询失败')
          }

        }).catch((err:AxiosError)=> {
        KLogger.debug('===== axios--失败 cat ',JSON.stringify(err))

        reject('查询失败')

      })
    })

  }

  /*
   * 订单列表
   * */
  async reqUserOrderList():Promise<OrderItemInfo[]>{
    return await new Promise((resolve, reject) => {
      axios.get(
        `${this.baseUrl}/orderList`,
      )
        // .then((resp:AxiosResponse) => {
        .then((resp:AxiosResponse<OrderItemInfo[]>) => {
          if (resp.status === 200) {
            KLogger.debug('===== success reqUserOrderList')
            resolve(resp.data)
          } else {
            KLogger.debug('===== failure reqUserOrderList')
            KLogger.debug('===== axios--失败',JSON.stringify(resp))
            reject({'msg':'查询失败orderList','code':'408'})
          }

        }).catch((err:AxiosError)=> {
        KLogger.debug('===== axios--失败 cat ',JSON.stringify(err))

        reject({'msg':'查询失败orderList','code':'408'})

      })
    })

  }





  async reqGetLogin(){
    await axios.get<userInfo,AxiosResponse<userInfo>, null>(`${this.url}}`)
      .then((response: AxiosResponse<userInfo>) => {
        // 处理成功情况
        KLogger.debug('====== ccc')
        console.info(`===== ${JSON.stringify(response)}`);
        // AlertDialog.show({message:JSON.stringify(response.data)})
      })
      .catch((error:AxiosError)=> {
        AlertDialog.show({message:JSON.stringify(error)})
      })
  }

  async axiosGetData(){
    //2. 导入axios
    //3. axios发起请求
    axios.get(this.url)
      //4. axios获取结果
      .then((res:AxiosResponse)=>{ //与服务器通信成功
        // res.status 响应状态码 ， 200成功，非200（400,401,403）
        // KLogger.debug("wangdh:"+1)
        // KLogger.debug("wangdh:"+res.data)
        AlertDialog.show({message:JSON.stringify(res.data)})
      })
      .catch((error:AxiosError)=>{ //与服务器通信失败
        AlertDialog.show({message:JSON.stringify(error)})
      })

  }

  // 支持async/await用法

  async getUser() {

    // 发送一个get请求（默认请求方式）
    // axios.get<string, AxiosResponse<string>, null>(this.url, { params: { key: "value" } })
    //   .then((response: AxiosResponse) => {
    //     // console.info("result:" + JSON.stringify(response.data));
    //     AlertDialog.show({message:JSON.stringify(response.data)})
    //
    //   })
    //   .catch((error: AxiosError) => {
    //     console.error("result:" + error.message);
    //     AlertDialog.show({message:JSON.stringify(error.message)})
    //
    //   });

    try {
      const response:AxiosResponse = await axios.get<string, AxiosResponse<string>, null>(this.url);
      KLogger.debug(JSON.stringify(response));
      AlertDialog.show({message:JSON.stringify(response.data)})
      //返回这个，外面数据可以then
      return response.data
    } catch (error) {
      console.error(JSON.stringify(error));
      AlertDialog.show({message:JSON.stringify(error.message)})
    }
  }



  async updateImage() {
    let formData = new FormData()
    formData.append('file', 'internal://cache/blue.jpg')

    // 发送请求
    axios.post<string, AxiosResponse<string>, FormData>('https://www.xxx.com/upload', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
      context: getContext(this),
      onUploadProgress: (progressEvent: AxiosProgressEvent): void => {
        console.info(progressEvent && progressEvent.loaded && progressEvent.total ? Math.ceil(progressEvent.loaded / progressEvent.total * 100) + '%' : '0%');
      },
    // }).then((res: AxiosResponse<string>) => {
    }).then((res: AxiosResponse) => {
      console.info("result" + JSON.stringify(res.data));
    }).catch((err: AxiosError) => {
      console.error("error:" + JSON.stringify(err));
    })
  }

  async downFile() {
    let filePath = getContext(this).cacheDir + '/blue.jpg'
    // 下载。如果文件已存在，则先删除文件。
    try {
      fs.accessSync(filePath);
      fs.unlinkSync(filePath);
    } catch(err) {}

    axios({
      url: 'https://www.xxx.com/blue.jpg',
      method: 'get',
      context: getContext(this),
      filePath: filePath ,
      onDownloadProgress: (progressEvent: AxiosProgressEvent): void => {
        // console.info("progress: " + progressEvent && progressEvent.loaded && progressEvent.total ? Math.ceil(progressEvent.loaded / progressEvent.total * 100) : 0)
      }
    }).then((res:AxiosResponse)=>{
      console.info("result: " + JSON.stringify(res.data));
    }).catch((error:AxiosError)=>{
      console.error("error:" + JSON.stringify(error));
    })

  }

}
interface userInfo{
  id: number
  name: string,
  phone: number
}

const requestModelAxios = new RequestModelAxios()
export default requestModelAxios as RequestModelAxios

