import { YWNavRouterInfoConfig } from "../YWNavRouteInfoConfig";
import { YWBaseJumpIntercept } from "./YWBaseJumpIntercept";

export class YWJumpIntercept extends YWBaseJumpIntercept {
  back(config: YWNavRouterInfoConfig): void {

  }

  jump(config: YWNavRouterInfoConfig): Promise<void> {
    return Promise.resolve()
  }

  params(config: YWNavRouterInfoConfig): Map<string,object> {
    return new Map()
  }

  isIntercept(): boolean {
    return false
  }
}