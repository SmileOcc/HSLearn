import { IOSRouterListener } from './IOSRouterListener';
import { OSRouteConfig } from './OsRouteConfig';

export class OsRouterListener implements IOSRouterListener {
  routerListenerSuccess(config: OSRouteConfig): void {
    throw new Error('Method not implemented.');
  }

  routerListenerFail(config: OSRouteConfig, error: Error): void {
    throw new Error('Method not implemented.');
  }



}