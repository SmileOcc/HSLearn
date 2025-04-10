import { systemDateTime } from "@kit.BasicServicesKit";
import { router } from "@kit.ArkUI";
import { osRouter, OsRouterUrls } from "@learn/common_har"

const miniTime:number = 200
const maxCount:number = 5

export class DebuggerTool {

  static lastTime:number = 0
  static lastCount:number = 0

  static registerDebuggerApp() {
    osRouter.bandRouterName(OsRouterUrls.DEBUGGER_APP,  (): Promise<Object> => {
      return import("./components/DebuggerPage")
    })
  }
  static openDebugger() {
    let currentTime: number = systemDateTime.getTime()
    if (currentTime > DebuggerTool.lastTime) {

      if ((currentTime - DebuggerTool.lastTime) < miniTime) {
        DebuggerTool.lastCount++

        if (DebuggerTool.lastCount >= maxCount) {
          //通过跨模块调整
          osRouter.open(OsRouterUrls.DEBUGGER_APP)
            .onWithWay("Push")
            .onWithMode("Standard")
            .go()
        }
      } else {
        DebuggerTool.lastCount = 0
      }
      DebuggerTool.lastTime = currentTime
    }
  }
}
