/*
 * @Desc: 路由页面统一管理页面，所有的页面都应该在这里添加，方便管理和使用！
 */
import { IRouterInfo } from "./IRouterInfo";

export class NavRouterPage {
  //方便管理
  private static infos: Map<string, IRouterInfo> = new Map<string, IRouterInfo>();
  //TODO - 需要注意的是 moduleName 一定需要与 entry中build-profile.json5、oh-package.json5中dependencies导入定义的一致
  //moduleName和pageName并没有限制，唯一即可
  static readonly LOGIN: IRouterInfo = NavRouterPage.create("@module/login_har", "YWLoginPage", true);
  static readonly REGISTER: IRouterInfo = NavRouterPage.create("@module/login", "register");
  static readonly ENTRY_MODULE_NAME: string = "@module/entry";
  static readonly ABOUT_ME: IRouterInfo = NavRouterPage.create("@module/entry", "about_me", true);
  static readonly ABOUT_ME2: IRouterInfo = NavRouterPage.create("@module/entry", "about_me2");

  private static create(moduleName: string, pageName: string, hasNavDest?: boolean): IRouterInfo {
    const path = moduleName + "/" + pageName;
    let info = NavRouterPage.infos.get(path);
    if (info) {
      return info;
    }
    info = { moduleName: moduleName, pageName: pageName, hasNavDest: hasNavDest };
    NavRouterPage.infos.set(path, info);
    return info;
  }

  public static getInfo(path: string) {
    return NavRouterPage.infos.get(path);
  }

  public static getPath(info: IRouterInfo) {
    return info.moduleName + "/" + info.pageName;
  }
}