

@Observed
export class UserInfoModel {
  name:string | undefined
  userToken:string | undefined
  nickName:string |undefined
  img:string|undefined
  sex:string|undefined
  tel:string |undefined
  birthday:string|undefined
  desc:string|undefined
  isVip:boolean|undefined = false
  avatar:string|undefined = ''
  vipDesc:string|undefined = ''
}