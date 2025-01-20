import { YWHeadIntercept } from "./YWHeadIntercept";
import { YWJumpIntercept } from "./YWJumpIntercept";
import { List } from "@kit.ArkTS";
import { YWBaseIntercept } from "./YWBaseIntercept";
import { YWBaseJumpIntercept } from "./YWBaseJumpIntercept";
import { YWNavRouterInfo } from "../YWNavRouteInfo";
import { YWNavRouterInfoConfig } from "../YWNavRouteInfoConfig";

export class YWInterManager {
  head:YWBaseIntercept = new YWHeadIntercept()
  jump:YWBaseJumpIntercept = new YWJumpIntercept()

  headList:List<YWBaseIntercept> = new List()
  jumpList:List<YWBaseJumpIntercept> = new List()


  addGeneral(item:YWBaseIntercept) {
    this.headList.add(item)
  }
  removeGeneral(item:YWBaseIntercept) {
    this.headList.remove(item)
  }

  addJump(item:YWBaseJumpIntercept){
    this.jumpList.add(item)
  }

  removeJump(item:YWBaseJumpIntercept) {
    this.jumpList.remove(item)
  }

  transformGeneral(config:YWNavRouterInfoConfig):YWNavRouterInfoConfig {
    this.clearGenerateState()

    let temp = this.head
    this.headList.forEach((item)=>{
      temp.setNextIntercept(item)
      temp = item
    })

    return this.head.doIntercept(config)
  }

  findTransformJump(config:YWNavRouterInfoConfig):YWBaseJumpIntercept | undefined {
    this.clearJumpState()

    this.jumpList.sort((f,s)=>{
      return s.priority() - f.priority()
    })

    let temp = this.jump
    this.jumpList.forEach((item)=>{
      temp.setNextIntercept(item)
      temp = item
    })


    for (let i=0; i<this.jumpList.length;i++) {
      const item = this.jumpList[i] as YWBaseJumpIntercept
      if (item.isIntercept(config) == false) {
        return item
      }
    }
    return undefined
  }

  transformJump(config:YWNavRouterInfoConfig, invoke:(ezRoute:YWNavRouterInfoConfig) => void) {
    this.clearJumpState()

    this.jumpList.sort((f,s)=>{
      return s.priority() - f.priority()
    })

    let temp = this.jump
    this.jumpList.forEach((item)=>{
      temp.setNextIntercept(item)
      temp = item
    })
   this.jump.handleJump(config,invoke)
  }

  transformBack(config:YWNavRouterInfoConfig, invoke:(ezRoute:YWNavRouterInfoConfig) => void) {
    this.clearJumpState()

    this.jumpList.sort((f,s)=>{
      return s.priority() - f.priority()
    })

    let temp = this.jump
    this.jumpList.forEach((item)=>{
      temp.setNextIntercept(item)
      temp = item
    })
    this.jump.handleBack(config,invoke)
  }

  transformParams(config:YWNavRouterInfoConfig, invoke:(ezRoute:YWNavRouterInfoConfig) => Object) {
    this.clearJumpState()

    this.jumpList.sort((f,s)=>{
      return s.priority() - f.priority()
    })

    let temp = this.jump
    this.jumpList.forEach((item)=>{
      temp.setNextIntercept(item)
      temp = item
    })
    this.jump.handleParams(config,invoke)
  }

  clearGenerateState() {
    this.head.clear()
    this.headList.forEach((item)=>{
      item.clear()
    })
  }

  clearJumpState() {
    this.jump.clear()
    this.jumpList.forEach((item)=>{
      item.clear()
    })
  }

  handleResult(result:InterceptResult) {

  }
}

export enum InterceptResult {
  success = "success",
  fail = "fail",
  unknown = "unknown"
}


export const ywInterManager = new YWInterManager()