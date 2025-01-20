import { YWNavRouterInfoConfig } from "../YWNavRouteInfoConfig";

export abstract class YWBaseIntercept {
  protected nextIntercept?: YWBaseIntercept

  abstract intercept(config:YWNavRouterInfoConfig):YWNavRouterInfoConfig

  isIntercept():boolean {
    return false
  }

  setNextIntercept(item:YWBaseIntercept) {
    this.nextIntercept = item
  }

  clear() {
    this.nextIntercept = undefined
  }

  doIntercept(item:YWNavRouterInfoConfig):YWNavRouterInfoConfig {
    let config = this.intercept(item)
    if (this.nextIntercept == undefined) {
      return config
    }
    return this.nextIntercept?.doIntercept(config)
  }
}