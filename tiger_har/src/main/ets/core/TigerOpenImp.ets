import { osRouter, OsRouterUrls } from '@learn/common_har/Index';
import { bundleAppService } from './service';
import { TigerOpenApi } from './TigerOpenApi';

export class TigerOpenImp implements TigerOpenApi {
  openTigerApp(appID: string, params: Object): void {

    bundleAppService()

    osRouter
      .open(OsRouterUrls.TIGER_APP)
      .onWithWay("Push")
      .onWithMode("Standard")
      .onWithParams("appID",appID)
      .onWithParams("extra",params)
      .go()
  }

}