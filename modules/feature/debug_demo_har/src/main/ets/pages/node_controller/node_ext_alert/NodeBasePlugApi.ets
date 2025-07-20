import { ExtenUIBaseViewModel } from "./ExtenUIViewModel";

export abstract class NodeBasePlugApi {
  private context?: ExtenUIBaseViewModel
  private apiMap:Map<string,string> = new Map()

  constructor(context: ExtenUIBaseViewModel) {
    this.context = context
    this.apiMap = this.onGetApiMap()
  }
  getContext() {
    return this.context
  }
  getApiMap() {
    return this.apiMap
  }

  abstract onGetApiMap(): Map<string,string>
}