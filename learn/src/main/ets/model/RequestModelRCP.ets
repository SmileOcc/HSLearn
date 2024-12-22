import { rcp } from '@kit.RemoteCommunicationKit';
import { YWConstants } from '@learn/constants_har';
// import UserAgentUtils from '@learn/common_har';

class RequestModelRCP {
  private header(url: string): rcp.RequestHeaders {
    return {
      'content-type': 'application/x-www-form-urlencoded',
      'provenance': 'native',
      // 'user-agent': UserAgentUtils.getUserAgent(),
      // 'cookie': CookieUtils.getCookieString('url'),
    };
  }

  private requestConfiguration(): rcp.Configuration {
    return {
      transfer: {
        timeout: {
          connectMs: YWConstants.HTTP_TIMEOUT,
          transferMs: YWConstants.HTTP_TIMEOUT,
        },
      },
      security: this.securityConfiguration()
    }
  }

  private securityConfiguration(): rcp.SecurityConfiguration {
    // if (QDCtxConfig.isProdEnv()) {
    if (YWConstants.isProdEnv()) {

      return {}
    } else {
      return {
        remoteValidation: 'skip' //测试环境时，跳过SSL验证
      }
    }
  }

  private static session = rcp.createSession();

  // async post(url: string, params: Record<string, string>): Promise<object> {
  //   return await this.req(url, 'POST', params)
  // }
  //
  // async get(url: string): Promise<object> {
  //   return await this.req(url, 'GET')
  // }

  // private async req(url: string, method: string = 'POST', params?: Record<string, string>): Promise<object> {
  //   try {
  //     let req = new rcp.Request(url);
  //     if (params) {
  //       let arr = Object.keys(params)
  //       if (arr.length > 0) {
  //         req.content = new rcp.Form(params)
  //         req.method = method.toUpperCase()
  //       }
  //     }
  //     req.headers = this.header(url)
  //     req.configuration = this.requestConfiguration()
  //     let resp: rcp.Response = await QDHttpRequest.session.fetch(req)
  //     return resp
  //   } catch (err) {
  //     hsLog.e(`req err = ${JSON.stringify(err)}`)
  //     return new Object()
  //   }
  // }
}