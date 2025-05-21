import { IUState, YWBaseModel } from "@learn/common_har"

export class HomeViewModel extends YWBaseModel<HomeUIState> {
  iuState: HomeUIState = new HomeUIState()
  constructor(context:UIContext) {
    super()
  }

}

@Observed
export class HomeUIState implements IUState {
  isLoading:boolean = true
  isShowTab:boolean = true
  isShowTitleBar:boolean = false

}