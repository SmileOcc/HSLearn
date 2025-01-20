import { YWNavRouterInfoConfig } from "../YWNavRouteInfoConfig"
import { YWNavParams } from "../YWNavType"

export abstract class YWBaseJumpIntercept {
  protected nextIntercept?:YWBaseJumpIntercept

  abstract isIntercept(config:YWNavRouterInfoConfig):boolean

  priority():number {
    return 101
  }

  abstract back(config:YWNavRouterInfoConfig)
  abstract jump(config:YWNavRouterInfoConfig):Promise<void>
  abstract params(config:YWNavRouterInfoConfig):Map<string,object>


  setNextIntercept(item:YWBaseJumpIntercept) {
    this.nextIntercept = item
  }

  clear() {
    this.nextIntercept = undefined
  }

  handleBack(config:YWNavRouterInfoConfig, block:(zeConfig:YWNavRouterInfoConfig)=>void) {
    if (this.isIntercept(config)) {
      this.back(config)
      return
    } else if(this.nextIntercept === undefined) {
      block(config)
      return
    }

    this.nextIntercept?.handleBack(config,block)
  }

  handleJump(config:YWNavRouterInfoConfig, block:(zeConfig:YWNavRouterInfoConfig)=>void) {
    if (this.isIntercept(config)) {
      this.jump(config)
      return
    } else if(this.nextIntercept === undefined) {
      block(config)
      return
    }

    this.nextIntercept?.handleJump(config,block)
  }

  handleParams(config:YWNavRouterInfoConfig, block:(zeConfig:YWNavRouterInfoConfig) => object) {
    if (this.isIntercept(config)) {
      this.params(config)
      return
    } else if(this.nextIntercept === undefined) {
      block(config)
      return
    }

    this.nextIntercept?.handleParams(config,block)
  }
}
