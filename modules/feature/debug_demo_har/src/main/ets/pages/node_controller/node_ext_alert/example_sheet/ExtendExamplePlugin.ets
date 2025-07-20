import { ExtendBaseContext, ExtenUIBaseViewModel } from "../ExtenUIViewModel"
import { NodeBasePlugApi } from "../NodeBasePlugApi"
import { NodeDataViewModel } from "../NodeDataViewModel"
import { extendExampleBuilder } from "./ExtenExampleSheet"

const K_SHOW_EXAMPLE_SHEET: string = "extend.show_example_sheet"
const K_CLOSE_EXAMPLE_SHEET: string = "extend.close_example_sheet"

export class ExtendExamplePlugin extends ExtenUIBaseViewModel {

  constructor(context?: ExtendBaseContext, userSession?: object) {
    super(context, userSession)

  }
  getWrapBuild():WrappedBuilder<[NodeDataViewModel]> {
    return wrapBuilder(extendExampleBuilder)
  }
  getNodeViewModel(): NodeDataViewModel {
    let viewModel = new NodeDataViewModel()
    return viewModel
  }

  getUILevel(): number {//级别越大，在上层显示
    return 100
  }

  getFlagScene(): string {
    return "ExtendExamplePlugin"
  }

  getApiList(Api: Map<string, NodeBasePlugApi>): void {
    ExtendExampleApi.api.forEach((e)=>{
      Api.set(e,new ExtendExampleApi(this))
    })
    //在这处理，或manager处理
    this.apiList = Api
  }

}

class ExtendExampleApi extends NodeBasePlugApi {
  static api = [K_SHOW_EXAMPLE_SHEET,K_CLOSE_EXAMPLE_SHEET]


  onGetApiMap() {
    let apiMap: Map<string,string> = new Map()
    apiMap.set(K_SHOW_EXAMPLE_SHEET,"showExample")
    apiMap.set(K_CLOSE_EXAMPLE_SHEET,"closeExample")
    return apiMap
  }

  //K_SHOW_EXAMPLE_SHEET
  showExample(context?: object, data?: object, callBlack?:(params?: object)=>void) {
    let viewModel = this.getContext()?.onViewModel()
    viewModel?.show()
  }
  //K_CLOSE_EXAMPLE_SHEET
  closeExample(context?: object, data?: object, callBlack?:(params?: object)=>void) {
    let viewModel = this.getContext()?.onViewModel()
    viewModel?.hide()
  }
}