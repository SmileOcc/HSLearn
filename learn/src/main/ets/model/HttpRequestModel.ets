
import http from '@ohos.net.http'
import { BusinessError, request } from '@kit.BasicServicesKit';
import { TestInfo } from '../../../../../modules/request_har/src/main/ets/AxiosRequest/TestInfo';
import { FileConstants } from '../../../../../modules/common_har/src/main/ets/common/FileConstants';
import fs from '@ohos.file.fs';
import { YWConstants } from '@learn/constants_har';
import { FileUtils } from '../../../../../modules/common_har/src/main/ets/utils/FileUtils';
import { hsLog } from '@learn/logger_har';


class HttpRequestModel{
  baseUrl:string = 'http://127.0.0.1:8000'

  stestUrl = 'http://rap2api.taobao.org/app/mock/293606/api/chat/list';
  reqLogin<T>():Promise<T>{

    console.log('====开始请求')
    return new Promise((resolve: Function, reject: Function)=> {
        //1.创建http请求
        let httpRequest = http.createHttp()
        //2.发送请求
        httpRequest.request(
          // `${this.baseUrl}/saas-api/user/login`,
          `${this.stestUrl}`,
          {
            method:http.RequestMethod.GET,
            extraData:{'username':'admin','password':'admin'},
            header:{
              'X-Tenant-ID':'1',
              'Content-Type': 'application/json'
            },
            //expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
            usingCache: true, // 可选，默认为true
            priority: 1, // 可选，默认为1
            connectTimeout: 60000, // 可选，默认为60000ms
            readTimeout: 60000, // 可选，默认为60000ms
            //usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
          },
        ).then(resp => {
          if(resp.responseCode === 200){
            //查询成功
            console.log('==== http--成功')
            resolve(JSON.parse(resp.result.toString()))

          }else{
            console.log('==== http--失败',resp.result)
            reject('查询失败')
          }
        })
          .catch((error:BusinessError) => {
            console.info('==== error:'+JSON.stringify(error))
            reject('查询失败')
          })
    })
  }

  aaaaa() {
    // request.uploadFile()
  }

  /**
   * 下载文件(验证码使用)
   */
  static httpFileDownload(url: string, params?: object): Promise<object> {
    hsLog.d("下载文件URL：" + url + "\n请求参数:" + (params != undefined ? "\n请求参数:" + JSON.stringify(params) : "无参数"));
    //
    let httpRequest = http.createHttp();
    httpRequest.on('headersReceive', (header) => {
      //用于订阅HTTP响应头，此接口会比request请求先返回。可以根据业务需要订阅此消息
    });
    //
    let responseResult = httpRequest.request(url, {
      method: http.RequestMethod.GET,
      readTimeout: 3000,
      connectTimeout: 2500,
      header: {
        'Content-Type': 'application/json'
      },
      expectDataType: http.HttpDataType.ARRAY_BUFFER, // 可选，指定返回数据的类型
      extraData: params
    });

    // let responseResultJson = new ResponseResultJson();
    return responseResult.then(async (responseResult: http.HttpResponse) => {
      hsLog.d("文件下载请求响应URL：" + url + "\n响应结果:" + "\n" + JSON.stringify(responseResult));
      if (responseResult.responseCode === 200) {
        let header = responseResult.header
        hsLog.d('解析响应 header \n' + JSON.stringify(header));

        let headerJson = JSON.stringify(header)
        let headerObj:TestInfo = JSON.parse(headerJson)
        // let sessionId = headerObj.sessionid as string
        // let serverModel = headerObj.servermodel as string
        // let encryptType = headerObj.encrypttype as string
        //保存 header
        // await AppHelper.commitSessionId(sessionId);
        // await AppHelper.commitServerModel(serverModel);
        // await AppHelper.commitEncryptType(encryptType);
        //解析文件
        let result = responseResult.result as ArrayBuffer
        // let filePath = FileYWConstants.rootFile + "/verifyCode_" + TimeExUtils.getNowYMDHMS1() + '.jpg'
        let isHave = fs.accessSync(FileConstants.pathFile) //检查文件目录是否存在
        if (!isHave) fs.mkdirSync(FileConstants.pathFile) //创建目录
        //
        let filePath = FileConstants.pathFile + "verifyCode_" + YWConstants.RandomColor() + '.jpg'
        let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        fs.writeSync(file.fd, result); //将数据写入文件
        fs.closeSync(file); //关闭文件
        //
        hsLog.d("保存文件成功:\n" + filePath + "\t" + await FileUtils.getPathSize(filePath));
        //结果
        // responseResultJson.code = ResponseYWConstants.CODE_SUCCESS
        // responseResultJson.isSuccess = true
        // responseResultJson.status = responseResult.responseCode
        // responseResultJson.serverModel = serverModel
        // responseResultJson.filePath = filePath
      } else {
        // responseResultJson.code = ResponseYWConstants.CODE_ERROR;
        // responseResultJson.message = "业务异常:" + JSON.stringify(responseResult)
        // responseResultJson.isSuccess = false
      }
      return responseResult;
    })

    //   .catch(((error:BusinessError)) => {
    //   hsLog.d("文件下载请求响应URL：" + url + "\n请求异常:\n" + JSON.stringify(error))
    //   // responseResultJson.code = ResponseYWConstants.CODE_ERROR;
    //   // responseResultJson.message = "请求异常:\n" + JSON.stringify(error)
    //   // responseResultJson.isSuccess = false
    //   // return responseResultJson;
    //   return error
    // });
  }

}

const httpRequestModel = new HttpRequestModel()
export default httpRequestModel as HttpRequestModel

