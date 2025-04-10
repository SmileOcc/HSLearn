import { IAppInfo } from "../service";


export class HSAppInfo implements IAppInfo {

  private appName?: string

  getAppName(): string {
    throw new Error("Method not implemented.");
  }

  getVersion(): string {
    throw new Error("Method not implemented.");
  }

  getAppID(): number {
    throw new Error("Method not implemented.");
  }

  getBoundId(): string {
    throw new Error("Method not implemented.");
  }

}