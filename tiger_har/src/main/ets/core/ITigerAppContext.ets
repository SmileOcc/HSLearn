import { ITigerAppServer } from './ITigerAppServer'
import { TigerServerType } from './launchexecute/TigerServerType'

export interface ITigerAppContext extends ITigerAppServer {

  initAppContext(context?:UIContext, appId?:string):void

  getAppID():string

  getUIContext():UIContext | undefined

  // getMainServer()

  getAppConfig():Object


  registerAppServer(key:TigerServerType, context:ITigerAppServer):void

  unRegisterAppServer(key:TigerServerType, context:ITigerAppServer):void

  onGetMainAppServer<T extends ITigerAppServer>(key:TigerServerType):T

  onGetOtherAppServer<T extends ITigerAppServer>(key:TigerServerType):T | undefined

}