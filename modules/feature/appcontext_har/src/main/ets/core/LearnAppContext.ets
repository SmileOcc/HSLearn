import { IAppContext, IAppInfo } from "../service";
import { HSAppInfo } from "./HSAppInfo";

export class LearnAppContext implements IAppContext {
  appInfo(): IAppInfo {
    return this._appInfo
  }
  private _appInfo: IAppInfo
  constructor() {
    this._appInfo = new HSAppInfo()
  }
}