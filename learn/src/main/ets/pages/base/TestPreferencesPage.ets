import { getCurrentTime } from '@learn/common_har';
import {StorageUtils,StorageKeys} from '../../../../../../modules/common_har/src/main/ets/utils/PreferenceStorageUtils'
@Entry
@Component
struct TestPreferencesPage {
  @State message: string = 'Hello preferenceName';

  aboutToAppear(): void {

    StorageUtils.put(StorageKeys.USER_LOGIN,true)
    StorageUtils.put(StorageKeys.USER_INFO_KEY,getCurrentTime())

    setTimeout(() => {
      StorageUtils.get(StorageKeys.USER_INFO_KEY).then((result) => {
        //showToast(result.toString())
        console.debug(`===== ${result}`)
        this.message = result as string
      })


    }, 2000)

    let isLogin = this.getUserLogin
  }
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }

  async getUserLogin() {
    let hasLogin = await StorageUtils.get(StorageKeys.USER_LOGIN, false)
    console.debug(`===== ${hasLogin}`)
    AlertDialog.show({message:hasLogin + ''})
    return hasLogin
    //LogUtils.debug('网络请求Request 登录状态校验>>>', `${hasLogin.toString()}`);
  }
}