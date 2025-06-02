import { kyStoreManger } from "@learn/common_har";
import { YWConstants, YWStorageConstants } from "@learn/constants_har";
import { HSAccountModel } from "./HSAccountModel"
import { HSLoginThirdModel } from "./HSLoginThirdModel"
import { HSSysInitModel } from "./HSSysInitModel";
import { PersistenceV2 } from "@kit.ArkUI";

@ObservedV2
export class HSUserInfoManager {
  static userInfoManager = new HSUserInfoManager()
  private constructor() {
  }

  static getInstance() {
    return HSUserInfoManager.userInfoManager;
  }

  account?:HSAccountModel

  @Trace
  isSignIn: boolean = false

  appUnreadMessageNum: number = 0; //未读消息数

  device_id: string = ""
  ////第三方登录显示
  loginThirdList?:HSLoginThirdModel[]

  sysInitModel?:HSSysInitModel

  async mockUserInfo(): Promise<HSAccountModel | undefined> {
    return await new Promise((resolve, reject) => {

      let userInfo: HSAccountModel = new HSAccountModel("odd_cid","odd","ccToken")
      userInfo.desc = "风中有朵雨做的云，一朵雨做的云"

      setTimeout(()=>{
        this.saveLocalUserInfo(userInfo)
        resolve(userInfo)
      },1000)
    })
  }

  getLocalUserInfo() {

  }

  updateUserInfo(account:HSAccountModel) {

    this.saveLocalUserInfo(account)
  }

  private saveLocalUserInfo(account:HSAccountModel) {
    this.account = account
    this.isSignIn = true
    this.saveUserToken(account.token)
    // PersistentStorage.persistProp(YWStorageConstants.kAccountInfo,account);
    // PersistenceV2.save("account");

  }

  saveUserToken(token:string|undefined) {
    if (token) {
      kyStoreManger.putData(YWStorageConstants.kAccountToken,token)
    } else {
      kyStoreManger.delete(YWStorageConstants.kAccountToken)
    }

  }


  clearUserInfo() {
    this.isSignIn = false
    this.account = undefined
    PersistentStorage.deleteProp(YWStorageConstants.kAccountInfo)
    this.saveUserToken(undefined)

  }

  getUserId() {
    return this.account?.userId
  }
  getUserToken() {
    return kyStoreManger.getData<string>(YWStorageConstants.kAccountToken, '')
  }

  logout() {
    this.clearUserInfo()
  }

  reLogin() {

  }


}

// export let hsUserInfoManager = new HSUserInfoManager()
