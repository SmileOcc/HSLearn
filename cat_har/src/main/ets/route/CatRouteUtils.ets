import { osRouter, OsRouterUrls } from '@learn/common_har/Index'
// import { RootPage, RootPageBuilder } from '../root/RootPage'
import { CatAppContext } from '../core/CatAppContext'


export class CatRouteUtils {

  static registerCatApp() {
    osRouter.bandRouterName(OsRouterUrls.CAT_APP,  (): Promise<Object> => {
      return import("../root/RootPage")
    })
  }

  // static wrappedCatApp():WrappedBuilder<[i]> {
  //   return RootPageBuilder
  // }
}
