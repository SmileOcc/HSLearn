import { common, Want } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';

export default class RouterUtils {

  //日志过滤器
  static readonly LOG: string = "====RouterUtils"

  //普通页面跳转
  public static async jumpRouter(url: string,params?:object, routerMode?:router.RouterMode) {
    router.pushUrl({url:url,params},routerMode?routerMode:router.RouterMode.Standard)
  }

    /**
   * 鸿蒙APP跳转到手机浏览器并打开网页
   * @param url 打开网页后展示的url地址
   */
  public static async openBrowser(context: common.UIAbilityContext, url: string) {
    try {
      let want:Want = {
        "action": "ohos.want.action.viewData",
        "entities": ["entity.system.browsable"],
        "uri": url,
        "type": "text/plain"
      }
      //let context = getContext(this) as common.UIAbilityContext;
      await context.startAbility(want)
      console.info(RouterUtils.LOG, 'openBrowser', url)
    } catch (error) {
      console.error(RouterUtils.LOG, 'openBrowser', `${error.code},url：${url}`)
    }
  }

  public static backPage() {
    router.back()
    console.info(RouterUtils.LOG, 'backPage', '判断栈内页面数：', router.getLength())
  }


  //在鸿蒙APP内打开网页 常用来打开隐私声明、用户协议等
  public static async openWeb(url: string) {
    try {
      await router.pushUrl({
        url: 'pages/web/WebPage', //这个页面是我自己创建的，用于展示网页。里面可根据url的参数决定是否显示原生的标题栏。
        params: {
          launchWebview: url
        }
      }, router.RouterMode.Standard)
      console.info(RouterUtils.LOG, 'openWeb', url)
    } catch (e) {
      console.error(RouterUtils.LOG, 'openWeb', JSON.stringify(e), 'url:', url)
    }
  }

  //获取当前内存中，跑转到web页时保存的参数
  public static getParamsByWeb():object {
    let params = router.getParams()
    let jsonStr = JSON.stringify(params)
    // let url = JSON.parse(jsonStr).launchWebview
    //let url = JSON.parse(jsonStr)
    console.info(RouterUtils.LOG, 'getParamsByWeb', jsonStr)
    return params
  }

  //跳转到首页，需要在首页Index中
  public static async openIndex() {
    try {
      await router.pushUrl({
        url: 'pages/Index'
      }, router.RouterMode.Single)
      console.info(RouterUtils.LOG, 'openIndex', 'occ')
      router.clear()
    } catch (e) {
      console.error(RouterUtils.LOG, 'openIndex', JSON.stringify(e))
    }
  }


  public static async openLogin() {
    try {
      await router.pushUrl({
        url: 'pages/login/LoginPage'
      }, router.RouterMode.Standard)
      console.info(RouterUtils.LOG, 'openLogin', 'succ')
    } catch (e) {
      console.error(RouterUtils.LOG, 'openLogin', JSON.stringify(e))
    }
  }

}