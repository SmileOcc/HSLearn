import { ywDebugGlobal } from "../../../core/DebugGlobal";
import { WebViewDemoComponent } from "./view/NativeEmbedView";

@Builder
export function  webViewDemoBuilder(name:string,params:Map<string,Object>){
  NavDestination(){
    WebViewDemo()
  }
  .hideTitleBar(true)
  .onBackPressed(()=>{
    ywDebugGlobal.getMainNav().pop(true)
    return true
  })
}

@AppRouter({ name: "nativeembed/WebViewDemo" })
@Component
export struct WebViewDemo {
  build() {
    WebViewDemoComponent()
  }
}

// 自定义装饰器
export function AppRouter(param: AppRouterParam) {
  return Object;
}

// 装饰器参数
export interface AppRouterParam {
  // 跳转的路由名
  name?: string;
  // 是否需要传递参数，需要的话设置为true，否则可不需要设置。
  hasParam?: boolean;
  // 路由跳转的常量文件路径和常量名
  routeLocation?: string;
}

