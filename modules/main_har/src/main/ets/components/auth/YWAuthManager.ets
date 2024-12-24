import dataPreferences from '@ohos.data.preferences';

export class YWAuthManager {

  //用户是否首次授权使用APP
  static async checkUserPrivacy(context:Context):Promise<boolean> {
    const dataPre = await dataPreferences.getPreferences(context, "kISAgreed");
    const isAgreed = dataPre.getSync("kISAgreed",false) as boolean
    return isAgreed
  }

  static async setUserPrivacy(context:Context) {
    dataPreferences.getPreferences(context, "kISAgreed").then((value)=>{
      value.put("kISAgreed",true)
      value.flush()
    })
  }
}