import { YWNavRouterInfoConfig } from "../YWNavRouteInfoConfig";
import { YWBaseIntercept } from "./YWBaseIntercept";

export class YWHeadIntercept extends  YWBaseIntercept {

  intercept(config: YWNavRouterInfoConfig): YWNavRouterInfoConfig {
    return config
  }
}