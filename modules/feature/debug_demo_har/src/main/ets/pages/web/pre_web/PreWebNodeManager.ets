import { PreWebNodeController } from "./PreWebNodeController";
import { webview } from "@kit.ArkWeb";

// 创建Map保存所需要的NodeController
let NodeMap: Map<string, PreWebNodeController | undefined> = new Map();
// 创建Map保存所需要的WebViewController
let controllerMap: Map<string, WebviewController | undefined> = new Map();

// 初始化需要UIContext 需在Ability获取
export const createPreWeb = (url: string, uiContext: UIContext) => {
  // 创建NodeController
  let baseNode = new PreWebNodeController();
  let controller = new webview.WebviewController();
  // 初始化自定义web组件
  baseNode.initWeb(url, uiContext, controller);
  controllerMap.set(url, controller);
  NodeMap.set(url, baseNode);
}

// 自定义获取NodeController接口
export const getPreWeb = (url: string): PreWebNodeController | undefined => {
  // 加载新的Url时，建议复用预创建的Web组件
  if (!NodeMap.get(url) && NodeMap.get('about://blank')) {
    // 获取预创建的Web组件
    let webNode = NodeMap.get('about://blank') as PreWebNodeController;
    // 重新加载url
    webNode.loadUrl(url);
    return webNode;
  }
  return NodeMap.get(url);
}