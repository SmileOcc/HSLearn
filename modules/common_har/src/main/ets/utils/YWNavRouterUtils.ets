
const TAG = "YWNavRouterUtils"

export class YWNavRouterUtils {

  static navPathStack: NavPathStack = new NavPathStack()
  static routerStack:Array<string> = new Array()

  //参数默认在info上 这种跳转需要PagesMap中实现目标类
  public static navPush(info: NavPathInfo, parm: object | undefined = undefined,
    callback: Callback<PopInfo> | undefined = undefined): void {
    if(parm != undefined) {
      info.param = parm
    }
    YWNavRouterUtils.routerStack.push(info.name)
    YWNavRouterUtils.navPathStack.pushPath(info)
    // YWNavRouterUtils.navPathStack.pushPathByName()
  }

  public static navReplace(info: NavPathInfo, parm: object | undefined = undefined) {
    if(parm != undefined) {
      info.param = parm
    }
    YWNavRouterUtils.routerStack.pop()
    YWNavRouterUtils.routerStack.push(info.name)
    YWNavRouterUtils.navPathStack.replacePath(info,true)
  }

  public static navPop(result?:object) {
    if (result !== undefined) {
      YWNavRouterUtils.navPathStack.pop(result,true)
    } else {
      YWNavRouterUtils.navPathStack.pop(true)
    }
  }

  public static navFinishPage(info: NavPathInfo) {
    YWNavRouterUtils.navPathStack.removeByName(info.name)
  }

  public static nvaPopHome(){
    YWNavRouterUtils.routerStack.length = 0
    YWNavRouterUtils.navPathStack.clear()
  }

  public static navPushOnTopSingleton(info: NavPathInfo) {
    const options:NavigationOptions = {launchMode:LaunchMode.MOVE_TO_TOP_SINGLETON,animated:false}
    YWNavRouterUtils.navPathStack.pushPath(info)
  }


  // 直接使用路径 需要 在route_map.json中注册 对应页面RegisterBuilder

  public static push(name: string, parm: object | undefined = undefined,
    callback: Callback<PopInfo> | undefined = undefined) {
    YWNavRouterUtils.routerStack.push(name);
    YWNavRouterUtils.navPathStack.pushPathByName(name, parm, callback, true)
  }

  public static replace(name: string, parm: object | undefined = undefined) {
    YWNavRouterUtils.routerStack.pop();
    YWNavRouterUtils.routerStack.push(name);
    YWNavRouterUtils.navPathStack.replacePathByName(name, parm, true)
  }

  public static pop(result?: Object) {
    if (result !== undefined) {
      YWNavRouterUtils.navPathStack.pop(result, true)
    } else {
      YWNavRouterUtils.navPathStack.pop(true)
    }
  }

  public static finishPage(name: string) {
    YWNavRouterUtils.navPathStack.removeByName(name)
  }

  public static popHome() {
    YWNavRouterUtils.routerStack.length = 0;
    YWNavRouterUtils.navPathStack.clear()
  }
}