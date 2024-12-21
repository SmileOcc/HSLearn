import { Logger } from '@yunkss/eftool';
import { IRouterInfo } from './IRouterInfo';
import { NavRouterPage } from './NavRouterPage';

const TAG = 'YWRouterNav';

// 在这个类中，我们统一管理所有的类似getAboutMeBuilder的@Builder的注册，
export class YWRouterNav {
  // 管理需要动态导入的模块，key是模块名，value是WrappedBuilder对象，动态调用创建页面的接口
  private static routerMap: Map<string, WrappedBuilder<[object]>> = new Map<string, WrappedBuilder<[object]>>();
  static navPathStack: NavPathStack = new NavPathStack();
  // 通过数组实现自定义栈的管理
  private static routerStack: Array<IRouterInfo> = new Array();

  /**
   * 获取组件
   * @param name
   * @returns
   */
  public static getBuilder(name: string): WrappedBuilder<[object]> {
    const builder = YWRouterNav.routerMap.get(name);
    const meth = builder as WrappedBuilder<[object]>
    return meth;
  }

  /**
   * 判断该组件是否包含：NavDestination
   * @param name
   * @returns
   */
  public static hasNavDest(name: string): boolean {
    const info = NavRouterPage.getInfo(name);
    if (info === undefined) {
      Logger.error(TAG, `${name} --> 没有注册路由！`)
      return false;
    }
    if (info.hasNavDest === undefined) {
      return false;
    }
    return info.hasNavDest;
  }

  /**
   * 页面跳转
   * @param info
   * @param parm    需要传递给下一个页面的参数
   * @param navPath
   */
  public static async push(info: IRouterInfo, parm: object | undefined = undefined,
    navPath: NavPathInfo = new NavPathInfo(NavRouterPage.getPath(info), parm)) {
    const moduleName: string = info.moduleName;
    const pageName: string = info.pageName;
    // 动态加载模块是否成功
    let isImportSucceed: boolean = false;
    // entry模块不需要动态加载源码
    if (moduleName === NavRouterPage.ENTRY_MODULE_NAME) {
      isImportSucceed = true;
    } else {
      // TODO：知识点：通过动态import的方式引入模块，在需要进入页面时才加载模块，可以减少主页面的初始化时间及占用的内存
      await import(moduleName).then((result: ESObject) => {
        // 动态加载模块成功时，通过模块中的harInit接口加载页面
        result.harInit(pageName); //然后在harInit函数中进行，动态 registerPage 页面
        isImportSucceed = true;
      }, (error: ESObject) => {
        // 动态加载模块失败时，打印错误日志
        Logger.debug(TAG, error)
      });
    }
    if (isImportSucceed) {
      YWRouterNav.routerStack.push(info);
      if (info.hasNavDest) {
        YWRouterNav.navPathStack.pushPath(navPath);
      } else {
        YWRouterNav.navPathStack.pushPath(navPath);
      }
    }
  }

  /**
   * 需要带返回结果的方式跳转下个页面
   * @param navPath
   */
  public static async pushCallback(navPath: NavPathInfo) {
    const info = NavRouterPage.getInfo(navPath.name);
    if (info === undefined) {
      return;
    }
    await YWRouterNav.push(info, undefined, navPath);
  }

  /**
   * 在当前页面打开下一个页面
   * @param info
   * @param parm
   * @param navPath
   */
  public static async replace(info: IRouterInfo, parm: object | undefined = undefined,
    navPath: NavPathInfo = new NavPathInfo(NavRouterPage.getPath(info), parm)) {
    const popInfo = YWRouterNav.routerStack.pop();
    if (popInfo !== undefined) {
      YWRouterNav.routerMap.delete(NavRouterPage.getPath(popInfo));
    }
    YWRouterNav.routerStack.push(info);
    YWRouterNav.navPathStack.replacePath(navPath, true);
  }

  /**
   * 返回
   * @param result 返回的结果
   */
  public static pop(result?: Object) {
    if (result !== undefined) {
      YWRouterNav.navPathStack.pop(result, true)
    } else {
      YWRouterNav.navPathStack.pop(true)
    }
  }

  /**
   * 注册页面
   * @param info
   * @param builder
   */
  public static registerPage(info: IRouterInfo, builder: WrappedBuilder<[object]>) {
    YWRouterNav.routerMap.set(NavRouterPage.getPath(info), builder);
  }
}
