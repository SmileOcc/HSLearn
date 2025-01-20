import { osRouter, OsRouterUrls } from "@learn/common_har"
import { ICatOpenApi } from "./ICatOpenApi"

export class CatOpenImp implements ICatOpenApi {
  openCatApp(appID: string, params: Object): void {

    // bundleAppService()

    osRouter
      .open(OsRouterUrls.CAT_APP)
      .onWithWay("Push")
      .onWithMode("Standard")
      .onWithParams("appID",appID)
      .onWithParams("extra",params)
      .go()
  }

}