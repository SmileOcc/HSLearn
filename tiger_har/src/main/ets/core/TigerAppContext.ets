import { ITigerAppContext } from './ITigerAppContext';

export class TigerAppContext implements ITigerAppContext {
  getAppID(): string {
    throw new Error('Method not implemented.');
  }

  getUIContext(): UIContext | undefined {
    throw new Error('Method not implemented.');
  }

  getAppConfig(): Object {
    throw new Error('Method not implemented.');
  }

}