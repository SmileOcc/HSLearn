import { IUState, YWBaseModel } from "@learn/common_har"
import { ITigerAppContext } from "../../core/ITigerAppContext"

export class MainTabViewModel extends YWBaseModel<MainTabUIState> {
  iuState: MainTabUIState = new MainTabUIState()
  private appContext:ITigerAppContext

  constructor(context:ITigerAppContext) {
    super()
    this.appContext = context
  }

  loadConfig() {

  }

}

@Observed
export class MainTabUIState implements IUState {
  isLoading:boolean = true
  isShowTab:boolean = true
  isShowTitleBar:boolean = false

}