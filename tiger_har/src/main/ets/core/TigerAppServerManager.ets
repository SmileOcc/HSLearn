import { ITigerAppContext } from './ITigerAppContext'
import { ITigerAppServer } from './ITigerAppServer'
import { TigerServerType } from './launchexecute/TigerServerType'
import { LaunchStepData } from './task/LaunchStep'

export class TigerAppServerManager implements ITigerAppContext {

  private serverMap:Map<TigerServerType,ITigerAppServer> = new Map()

  getAppID(): string {
    throw new Error('Method not implemented.')
  }

  getUIContext(): UIContext | undefined {
    throw new Error('Method not implemented.')
  }

  getAppConfig(): Object {
    throw new Error('Method not implemented.')
  }

  registerAppServer(key:TigerServerType, context:ITigerAppServer):void {
    // let index = this.serverMap.indexOf(context)
    // if (index < 0) {
    //   this.serverList.push(context)
    // }
    if (!this.serverMap.has(key)) {
      this.serverMap.set(key, context)
    }
  }

  unRegisterAppServer(key:TigerServerType, context:ITigerAppServer):void {
    // let index = this.serverList.indexOf(context)
    // if (index >= 0) {
    //   this.serverList.splice(index,1)
    // }
    if (this.serverMap.has(key)) {
      this.serverMap.delete(key)
    }
  }

  onGetMainAppServer<T extends ITigerAppServer>(key:TigerServerType):T {
    let server = this.serverMap.get(key)
    if (server) {
      return server as T
    } else {
      throw  Error("主服务异常，终止程序")
    }
  }

  onGetOtherAppServer<T extends ITigerAppServer>(key:TigerServerType):T | undefined {
    let server = this.serverMap.get(key)
    return server as T
  }

  onStart(): void {
    for (const value of this.serverMap.values()) {
      value.onStart()
    }
  }

  onShow(): void {

  }

}