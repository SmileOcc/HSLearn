
//单例模式
export class UserInfoManager {

  name:string = 'occ'
  


  private static delegate = new UserInfoManager();

  private constructor() {
  }

  static getInstance() {
    return UserInfoManager.delegate;
  }

}

// 使用： UserInfoManager.getInstance()
