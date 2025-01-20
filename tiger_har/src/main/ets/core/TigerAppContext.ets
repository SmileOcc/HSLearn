import { ITigerAppContext } from './ITigerAppContext';
import { ITigerAppServer } from './ITigerAppServer';
import { LaunchStoreDataManager } from './launchexecute/LaunchStoreDataManager';
import { TigerServerType } from './launchexecute/TigerServerType';
import { TigerAppServerManager } from './TigerAppServerManager';
import { TigerServerProvider } from './TigerServerProvider';
import App from '@system.app';

export class TigerAppContext implements ITigerAppContext {

  private serverManager = new TigerAppServerManager()

  private uiContext?:UIContext
  private appId:string = ""
  constructor() {

    TigerServerProvider.bundleAppService(this)
  }

  initAppContext(context?:UIContext, appId?:string) {
    this.appId = appId ?? ""
    this.uiContext = context

    this.serverManager.initAppContext(context,appId)
  }

  onStart(): void {
    this.serverManager.onStart()
  }

  onShow(): void {
    throw new Error('Method not implemented.');
  }



  getAppID(): string {
    return this.appId
  }

  getUIContext(): UIContext | undefined {

    return this.uiContext
  }

  getAppConfig(): Object {
    throw new Error('Method not implemented.');
  }


  registerAppServer(key:TigerServerType, context: ITigerAppServer): void {
    this.serverManager.registerAppServer(key,context)
  }

  unRegisterAppServer(key:TigerServerType, context: ITigerAppServer): void {
    this.serverManager.unRegisterAppServer(key,context)
  }


  onGetMainAppServer<T extends ITigerAppServer>(key:TigerServerType):T {
    return this.serverManager.onGetOtherAppServer(key) as T
  }

  onGetOtherAppServer<T extends ITigerAppServer>(key:TigerServerType):T | undefined {
    return this.serverManager.onGetOtherAppServer(key) as T
  }


  registerServer(key: string, server: ITigerAppServer): void {

  }

  unRegisterServer(key: string): void {
    throw new Error('Method not implemented.');
  }

  getLaunchStoreDataReader(): LaunchStoreDataManager {
    throw new Error('Method not implemented.');
  }

}
