import { OsRoute } from './OsRoute'
import { osRouterManager } from './OsRouterManager'

export type RouterInvokePromise = () => Promise<Object>

export class OsRouter {

  bandRouterName(routeName:string,invoke:RouterInvokePromise) {
    osRouterManager.bandRouterName(routeName,invoke)
  }

  open(url:string):OsRoute {
    return new OsRoute(url)
  }
}

export const osRouter = new OsRouter()