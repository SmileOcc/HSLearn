import distributedKVStore  from '@ohos.data.distributedKVStore'
import { BusinessError } from '@kit.BasicServicesKit';
import KLogger from '../common/KLogger'
/**
 * 数据持久化，缓存数据到本地（4M以下）
 * 分布式键值数据库 管理器
 * 使用 SingleKVStore, 数据不对设备进行区分
 * 数据库配置已固定, 后期如有需要再提供更多配置
 * 提供读写方法
 */

// 类型别名
type BooleanCallback = (flag:boolean) => string;

const TAG = 'YWKeyStoreManager'

export class YWKeyStoreManager {
  // 只能包含字母数字或者下划线, 否则会报错
  private storeId:string = "_storeId";

  private kvManager?: distributedKVStore.KVManager;
  private kvStore: distributedKVStore.SingleKVStore | undefined = undefined;
  private config?:distributedKVStore.KVManagerConfig;

  private options:distributedKVStore.Options = {
    createIfMissing: true, // 当数据库文件不存在时是否创建数据库，默认创建
    encrypt: false, // 设置数据库文件是否加密，默认不加密
    backup: false, // 设置数据库文件是否备份，默认备份
    autoSync: false,
    kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION, // 设置要创建的数据库类型，默认为多设备协同数据库
    securityLevel: distributedKVStore.SecurityLevel.S1 // 设置数据库安全级别 S2
  };


  public init(config: distributedKVStore.KVManagerConfig, storeId: string) {
    this.config = config;
    this.storeId = storeId;

    try {
      this.kvManager = distributedKVStore.createKVManager(this.config);
      this.createKVStore(()=>{})
    } catch (e) {
      let error = e as BusinessError;
      console.error(TAG, `Failed to create KVManager. Code:${error.code},message:${error.message}`)
    }
  }

  private createKVStore(callback: (success:boolean)=>void) {
    if (this.kvStore) {
      callback(true);
    } else {
      if (this.kvManager != null) {
        this.kvManager.getKVStore(this.storeId, this.options, (err:BusinessError,store:distributedKVStore.SingleKVStore) => {
          if (err) {
            callback(false);
            KLogger.error(TAG, `Failed to get KVStore: Code:${err.code},message:${err.message}`);
            return;
          }

          this.kvStore = store as distributedKVStore.SingleKVStore;
          KLogger.info(TAG, 'Succeeded in getting KVStore.');
          callback(true);
        });
      }

    }
  }

  async getData<T>(key: string, defaultValue: T): Promise<T> {

    try {
      const value = await this.kvStore?.get(key);
      if (value === undefined) {
        return defaultValue;
      }
      return value as T;
    } catch (e) {
      let error = e as BusinessError;
      KLogger.error(TAG, `Failed to get data. Code:${error.code},message:${error.message}`);
      return defaultValue;
    }


    // return value

    // return await new Promise((resolve: Function, reject: Function) => {
    //   this.createKVStore(async  (isSuccess) => {
    //     if (this.kvStore && isSuccess) {
    //
    //       this.kvStore.get(key).then((value) => {
    //         let strValue = value as string
    //
    //         if (strValue != null) {
    //           // let json = JSON.parse(strValue);
    //           resolve(strValue);
    //         }
    //         console.log(`==== get ${value}}`)
    //
    //       }).catch((e:BusinessError) => {
    //         console.error(`获取 value 失败. Code: ${e.code}, message: ${e.message}`)
    //         reject(e);
    //       })
    //     }
    //   })
    // });
  }

  putData(key: string, value: boolean | string | number | Uint8Array) {
    this.kvStore?.put(key, value, (err) => {
      if (err !== undefined) {
        KLogger.error(TAG, `Failed to put data. Code:${err.code},message:${err.message}`);
        return;
      }
      KLogger.info(TAG, 'Succeeded in putting data.');
    });
  }

  // putData(key: string, value: string): Promise<void> {
  //   return new Promise((resolve: Function, reject: Function) => {
  //     this.createKVStore((isSuccess) => {
  //       if (this.kvStore) {
  //         this.kvStore.put(key, value);
  //         console.log("===== save success")
  //         resolve();
  //       } else {
  //         reject(new Error("kvStorage 不存在"));
  //       }
  //     });
  //   });
  // }

  delete(key: string) {
    this.kvStore?.delete(key, (err) => {
      if (err !== undefined) {
        KLogger.error(TAG, `Failed to delete data. Code:${err.code},message:${err.message}`);
        return;
      }
      KLogger.info(TAG, 'Succeeded in deleting data.');
    });
  }

  closeStore(): Promise<void> {
    if (this.kvManager && this.config) {
      return this.kvManager.closeKVStore(this.config.bundleName, this.storeId);
    }

    return new Promise((reject: Function) => {
      reject(new Error("close kvStorage fail"));
    });
  }

  deleteStore(): Promise<void> {
    if (this.kvManager && this.config) {
      return this.kvManager.deleteKVStore(this.config.bundleName, this.storeId);
    }

    return new Promise((reject: Function) => {
      reject(new Error("delete kvStorage fail"));
    });
  }
}

export const kyStoreManger = new YWKeyStoreManager();

