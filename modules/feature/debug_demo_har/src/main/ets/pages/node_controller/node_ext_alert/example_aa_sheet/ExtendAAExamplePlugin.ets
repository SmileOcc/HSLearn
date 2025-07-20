import { ExtendBaseContext, ExtenUIBaseViewModel } from "../ExtenUIViewModel"
import { NodeBasePlugApi } from "../NodeBasePlugApi"
import { NodeDataViewModel } from "../NodeDataViewModel"
import { extendAAExampleBuilder } from "./ExtendAAExampleSheet"

const K_SHOW_AA_EXAMPLE_SHEET: string = "extend.show_aa_example_sheet"
const K_CLOSE_AA_EXAMPLE_SHEET: string = "extend.close_aa_example_sheet"

export class ExtendAAExamplePlugin extends ExtenUIBaseViewModel {

  constructor(context?: ExtendBaseContext, userSession?: object) {
    super(context, userSession)

  }
  getWrapBuild():WrappedBuilder<[NodeDataViewModel]> {
    return wrapBuilder(extendAAExampleBuilder)
  }
  getNodeViewModel(): NodeDataViewModel {
    let viewModel = new NodeDataViewModel()
    return viewModel
  }

  getUILevel(): number {
    return 1
  }

  getFlagScene(): string {
    return "ExtendAAExamplePlugin"
  }

  getApiList(Api: Map<string, NodeBasePlugApi>): void {
    ExtendAAExampleApi.api.forEach((e)=>{
      Api.set(e,new ExtendAAExampleApi(this))
    })
    //在这处理，或manager处理
    this.apiList = Api
  }

}

class ExtendAAExampleApi extends NodeBasePlugApi {
  static api = [K_SHOW_AA_EXAMPLE_SHEET,K_CLOSE_AA_EXAMPLE_SHEET]


  onGetApiMap() {
    let apiMap: Map<string,string> = new Map()
    apiMap.set(K_SHOW_AA_EXAMPLE_SHEET,"showAAExample")
    apiMap.set(K_CLOSE_AA_EXAMPLE_SHEET,"closeAAExample")
    return apiMap
  }

  //K_SHOW_EXAMPLE_SHEET
  showAAExample(context?: object, data?: object, callBlack?:(params?: object)=>void) {
    let viewModel = this.getContext()?.onViewModel()
    viewModel?.show()

    let testParm: object = new Object
    testParm["aaa"] = "a11"
    testParm["bbb"] = "abb"
    //这个callBlack可以赋值到model上，在其他触发
    callBlack?.(testParm)
  }
  //K_CLOSE_EXAMPLE_SHEET
  closeAAExample(context?: object, data?: object, callBlack?:(params?: object)=>void) {
    let viewModel = this.getContext()?.onViewModel()
    viewModel?.hide()

    let testParm: object = new Object
    testParm["aaa"] = "a11"
    testParm["bbb"] = "abb"
    //这个callBlack可以赋值到model上，在其他触发
    callBlack?.(testParm)
  }
}