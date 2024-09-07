
export interface ITigerAppContext {
  getAppID():string

  getUIContext():UIContext | undefined

  // getMainServer()

  getAppConfig():Object
}