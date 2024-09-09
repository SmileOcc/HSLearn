import { ITigerAppContext } from './ITigerAppContext';
import { ITigerAppServer } from './ITigerAppServer';
import { LaunchStoreDataManager } from './launchexecute/LaunchStoreDataManager';
import { TigerServerType } from './launchexecute/TigerServerType';
import { TigerAppServerManager } from './TigerAppServerManager';
import { TigerServerProvider } from './TigerServerProvider';

export class TigerAppContext implements ITigerAppContext {

  private serverManager = new TigerAppServerManager()
  constructor() {
    TigerServerProvider.bundleAppService(this)
  }

  onStart(): void {
    this.serverManager.onStart()
  }

  onShow(): void {
    throw new Error('Method not implemented.');
  }



  getAppID(): string {
    throw new Error('Method not implemented.');
  }

  getUIContext(): UIContext | undefined {
    throw new Error('Method not implemented.');
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
