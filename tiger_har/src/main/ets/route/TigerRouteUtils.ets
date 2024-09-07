import { osRouter, OsRouterUrls } from '@learn/common_har/Index'

export class TigerRouteUtils {

  static registerTigerApp() {
    osRouter.bandRouterName(OsRouterUrls.TIGER_APP,  (): Promise<Object> => {
      return import("../components/mainpage/MainPage")
    })
  }

}
