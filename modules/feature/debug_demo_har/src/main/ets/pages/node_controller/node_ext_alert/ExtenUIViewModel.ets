import { ExtendNodeController } from "./ExtenNodeController";
import { NodeDataViewModel } from "./NodeDataViewModel";
import { NodeController } from "@kit.ArkUI";
import { NodeBasePlugApi } from "./NodeBasePlugApi";

export class ExtendUINodeBaseService {
  apiList: Map<string, NodeBasePlugApi> = new Map()
}

export abstract class ExtenUIBaseViewModel extends ExtendUINodeBaseService {

  context?:ExtendBaseContext
  userSession?: object
  viewModel?: NodeDataViewModel

  constructor(context?: ExtendBaseContext, userSession?: object) {
    super();
    this.context = context
    this.userSession = userSession

  }

  onCreateNode(): NodeController {
    this.viewModel = this.getNodeViewModel()
    let build = this.getWrapBuild()
    let nodeCtrl = new  ExtendNodeController(this.viewModel,build)
    return nodeCtrl
  }

  onViewModel() {
    return this.viewModel
  }

  onWrapBuild() {
    let build = this.getWrapBuild()
    return build
  }
  //ets中没有根据类名创建类，ts中有
  // getApiList(Api: Map<string,string>) {
  //
  // }
  getApiList(Api: Map<string,NodeBasePlugApi>) {

  }

  getFlagScene() {
    return ""
  }
  abstract getWrapBuild():WrappedBuilder<[NodeDataViewModel]>
  abstract getNodeViewModel(): NodeDataViewModel
  abstract  getUILevel(): number


}

export class ExtendBaseContext {

}

