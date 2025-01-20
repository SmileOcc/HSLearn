// import { IUState } from "@learn/common_har"
import { IUState, YWBaseModel } from "@learn/common_har"
import { ICatAppContext } from "../core/ICatAppContext"
import { util } from "@kit.ArkTS"

export class RootViewModel extends YWBaseModel<IUState> {
  iuState: IUState = new RootUIState()
  private  lazyAppContext: ICatAppContext

  // constructor(lazyContext: ()=>ICatAppContext) {
  constructor(lazyContext: ICatAppContext) {
    super()

    this.lazyAppContext = lazyContext
  }

  openPage<T extends object>(pageBuilder:WrappedBuilder<[T]>, parm?:Map<string,object>) {
    this.push(pageBuilder as WrappedBuilder<[object]>,parm)
  }

  push = (pageBuilder:WrappedBuilder<[object]>, parm?:Map<string,object>) => {
    const key = util.generateRandomUUID()

    this.lazyAppContext.setBuilderPage(key,pageBuilder,true)
    this.lazyAppContext.getExtraNav().pushPath({name:key,param:parm},true)
  }

  removePage(key:string, isExtra?:boolean) {
    if (isExtra == true) {
      this.lazyAppContext.removeBuilderPage(key,true)
      return
    }
    this.lazyAppContext.removeBuilderPage(key)
  }
}

@Observed
export class RootUIState implements IUState {
  isLoading: boolean = true
  isShowTab: boolean = true
  isShowTitleBar: boolean = false
}