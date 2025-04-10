import { DebuggerTool } from "@learn/debugger_har";

export namespace DebuggerApi {

  export function registerDebugger() {
    DebuggerTool.registerDebuggerApp()
  }

  export function debuggerOpen() {
    DebuggerTool.openDebugger()
  }
}
