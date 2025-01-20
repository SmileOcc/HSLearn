import { ICatAppContext } from "./ICatAppContext";

export class CatAppContext implements ICatAppContext {

  extraNav: NavPathStack = new NavPathStack()
  mainNav: NavPathStack = new NavPathStack()

  extraBuilderMap:Map<string,WrappedBuilder<[object]>> = new Map<string,WrappedBuilder<[object]>>()
  mainBuilderMap:Map<string,WrappedBuilder<[object]>> = new Map<string,WrappedBuilder<[object]>>()

  getExtraNav(): NavPathStack {
    return this.extraNav
  }

  getMainNav(): NavPathStack {
    return this.mainNav
  }

  getBuilderPage(key:string, isExtra?:boolean):WrappedBuilder<[object]> | null {
    if (isExtra == true) {
      return this.extraBuilderMap.get(key) ?? null
    }
    return this.mainBuilderMap.get(key) ?? null
  }

  setBuilderPage(key:string, pageBuilder:WrappedBuilder<[object]>, isExtra?:boolean) {
    if (isExtra == true) {
      this.extraBuilderMap.set(key,pageBuilder)
      return
    }
    this.mainBuilderMap.set(key,pageBuilder)
  }

  removeBuilderPage(key:string, isExtra?:boolean) {
    if (isExtra == true) {
      return this.extraBuilderMap.delete(key)
    }
    return this.mainBuilderMap.delete(key)
  }


}