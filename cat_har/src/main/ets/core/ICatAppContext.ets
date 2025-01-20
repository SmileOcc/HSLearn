
export interface ICatAppContext {

  getExtraNav():NavPathStack

  getMainNav():NavPathStack

  getBuilderPage(key:string, isExtra?:boolean):WrappedBuilder<[object]> | null

  setBuilderPage(key:string, pageBuilder:WrappedBuilder<[object]>, isExtra?:boolean):void

  removeBuilderPage(key:string, isExtra?:boolean):void
}