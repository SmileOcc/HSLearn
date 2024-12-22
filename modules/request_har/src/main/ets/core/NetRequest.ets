/*
 * @Desc: 全局网络管理
 */
import axios, { AxiosError, AxiosInstance, AxiosProgressEvent, AxiosResponse } from '@ohos/axios';
import { API } from './API';
import { NetCallback } from './NetCallback';
import { NetMagicResp } from './NetMagicResp';
import { JSON } from '@kit.ArkTS';
import { YWFileUtils } from '@learn/common_har';
import { hsLog } from '@learn/logger_har';

const TAG = 'NetRequest';

const context = getContext(this);

class NetRequest {
  private instance: AxiosInstance;
  private responseInterceptFunc?: (response: AxiosResponse) => AxiosResponse;
  private errorInterceptFunc?: (error: AxiosError) => AxiosError;

  constructor() {
    this.instance = axios.create({
      baseURL: API.base_url,
      timeout: 10000,
      headers: {}
    });
    this.initIntercept(this.instance);
  }

  /**
   * 保存请求头
   * @param header
   */
  addHeader(header: Record<string, string | number | boolean>) {
    Object.keys(header).forEach((key: string) => {
      this.instance.defaults.headers.common[key] = header[key];
    })
    hsLog.i(TAG, 'after addHeader: ' + JSON.stringify(this.instance.defaults.headers));
  }

  axios(): AxiosInstance {
    return this.instance;
  }

  /**
   * 不需要参数的请求方式
   * @param url
   * @param callback
   */
  postNotBody<T>(url: string, callback?: NetCallback<T>) {
    this.post<T, undefined>(url, undefined, callback);
  }

  /**
   * 如：net.post<string, BulletinReq>(API.bulletin, { version: "1.0.0" }, {})
   * @param url
   * @param data D 为请求数据
   * @param callback T 为响应数据
   */
  post<T, D>(url: string, data?: D, callback?: NetCallback<T>) {
    hsLog.i(TAG, `[请求][${url}]: ${JSON.stringify(data)}`);
    this.instance
      .post<string, AxiosResponse<NetMagicResp<T>>, D>(url, data)
      .then((response: AxiosResponse<NetMagicResp<T>>) => {
        hsLog.i(TAG, `[响应][${url}]: ${JSON.stringify(response.data)}`);
        if (callback === undefined) {
          return;
        }
        if (response.status !== 200) {
          NetRequest.dealError<T>(response.status, response.statusText, callback);
          return;
        }

        const magic: NetMagicResp<T> = response.data;
        if (magic.code !== NetMagicResp.SUCCESS_CODE) {
          NetRequest.dealError<T>(magic.code, magic.message, callback);
          return;
        }
        NetRequest.dealSuccess(magic, callback);
      })
      .catch((error: Error) => {
        hsLog.e(TAG, `[异常][${url}]: ${JSON.stringify(error)}`);
        const obj: Record<string, string> = JSON.parse(error.message) as Record<string, string>;
        if (obj && obj['code'] !== undefined) {
          NetRequest.dealError<T>(Number(obj['code']), obj['message'], callback);
          return;
        }
        NetRequest.dealError<T>(-1, error.message, callback);
      })
      .finally(() => {
        if (callback && callback.onFinally) {
          callback.onFinally();
        }
      });
  }

  /**
   *
   * @param url
   * @param filePath
   * @param onResult (status: -1：下载失败；0：未下载；1：下载成功；2：正在下载)
   */
  download(url: string, filePath: string, onResult: (status: number, progress: number, msg: string) => void) {
    hsLog.i(TAG, `[下载][${url}]: ${filePath}`);
    YWFileUtils.delete(filePath);
    axios({
      url: url,
      method: 'get',
      context: context,
      filePath: filePath,
      onDownloadProgress: (progressEvent: AxiosProgressEvent): void => {
        if (progressEvent === undefined || progressEvent.total === undefined) {
          return;
        }
        const progress = progressEvent.total ? Math.ceil(progressEvent.loaded / progressEvent.total * 100) : 0;
        hsLog.i(TAG, `progress: ${progress} | ${JSON.stringify(progressEvent)}`);
        onResult(2, progress, '下载中');
      }
    }).then((response: AxiosResponse<string>) => {
      hsLog.i(TAG, `response: ${JSON.stringify(response)}`);
      if (response.status === 200) {
        onResult(1, 100, response.data);
      } else {
        YWFileUtils.delete(filePath);
        onResult(-1, 0, response.data);
      }
    }).catch((error: AxiosError) => {
      hsLog.e(TAG, `[异常][${url}]: ${JSON.stringify(error)}`);
      YWFileUtils.delete(filePath);
      onResult(-1, 0, error.message);
    })
  }

  private static dealError<T>(code: number, msg: string, callback?: NetCallback<T>) {
    if (callback && callback.onFail) {
      callback.onFail(code, msg);
    }
  }

  private static dealSuccess<T>(magic: NetMagicResp<T>, callback?: NetCallback<T>) {
    if (callback && callback.onSuccess) {
      callback.onSuccess(magic.data, magic);
    }
  }

  /**
   * 设置响应拦截器
   */
  private initIntercept(instance: AxiosInstance) {
    instance.interceptors.response.use((response: AxiosResponse) => {
      if (this.responseInterceptFunc) {
        return this.responseInterceptFunc(response);
      }
      return response;
    }, (error: AxiosError) => {
      // 对响应错误做点什么
      hsLog.i(TAG, 'initIntercept error: code=' + error.code + ' | message=' + error.message);
      if (this.errorInterceptFunc) {
        return this.errorInterceptFunc(error);
      }
      // return Promise.reject(error);
      return error;
    });
  }

  /**
   * 监听响应的
   * @param func
   */
  onResponseIntercept(func: (response: AxiosResponse) => AxiosResponse) {
    this.responseInterceptFunc = func;
  }

  /**
   * 监听响应的
   * @param func
   */
  onErrorIntercept(func: (error: AxiosError) => AxiosError) {
    this.errorInterceptFunc = func;
  }
}

export const netReq: NetRequest = new NetRequest();

