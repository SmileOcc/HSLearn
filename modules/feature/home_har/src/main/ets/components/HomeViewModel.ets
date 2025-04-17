import { IUState } from "@learn/common_har";

export class HomeViewModel {
  homeState: IUState = new HomeIUState()
  private context: UIContext
  constructor(context:UIContext) {
    this.context = context
  }

}

export class HomeIUState implements IUState {

}