import { hsLog } from "@learn/logger_har";
import { ExtendAAExamplePlugin } from "./example_aa_sheet/ExtendAAExamplePlugin";
import { ExtendExamplePlugin } from "./example_sheet/ExtendExamplePlugin";
import { ExtenUIBaseViewModel } from "./ExtenUIViewModel";
import { NodeInvokeApi } from "./NodeApiInvoke";
import { NodeBasePlugApi } from "./NodeBasePlugApi";

export class ExtendNodeManager {
  static getExtendPlugins(context?: object, userSession?: object) {
    return [
      new ExtendExamplePlugin(context, userSession),
      new ExtendAAExamplePlugin(context, userSession)
    ]
  }
}

const TAG = 'ExtendNodeUIManager'
export class ExtendNodeUIManager {
  private list: ExtenUIBaseViewModel[] = []
  private apiMap:Map<string,ExtenUIBaseViewModel> = new Map()
  private modeApiMap:Map<ExtenUIBaseViewModel,Map<string,NodeBasePlugApi>> = new Map()

  private apiMeths:Map<string, string> = new Map()

  onInit(list:ExtenUIBaseViewModel[]) {
    //可以根据级别排序
    this.list =list
    this.list.forEach((e)=>{
      let tempApiMap: Map<string,NodeBasePlugApi> = new Map()
      e.getApiList(tempApiMap)
      tempApiMap.forEach((value,key)=>{

      })
      this.modeApiMap.set(e,tempApiMap)

    })
  }

  findViewModel(api: string): NodeBasePlugApi | undefined {

    let apiModel: NodeBasePlugApi | undefined
    let values = this.modeApiMap.values()
    for (let item of values) {
      if (item.has(api)) {
        apiModel = item.get(api)
        break
      }
    }
    return apiModel
  }

  invokeApiPlug(api: string, callBack?:(params?: object)=>void) {
    //相同，可以判断级别排序

    //根据api查找插件实体
    let plug = this.findViewModel(api)

    if (plug == undefined) {
      hsLog.e(TAG, "未查找的对应插件")
      return
    }
    //根据插件触发对应绑定的方法名
    // let methName = this.apiMeths.get(api)
    let methName = plug.getApiMap().get(api)
    if (methName == undefined) {
      hsLog.e(TAG, `未找到对应方法：${plug} : ${methName}`)
      return
    }

    let context: object = new Object

    let params: object = new Object()
    params['name'] = "aa"
    params['cs'] = "测试"
    //插件调用方法 通过TS转换调用
    NodeInvokeApi(methName, plug,context, params,(callParams: object)=>{
      //处理回调事件
      callBack?.(callParams)
    })
  }


}