import { YWRouterLifecycleImp, YWRouterLifeCycleProxy, YWRouterNavParams } from "@learn/nav_router_har";

@Builder
export function messageBuilder(name:string,params:YWRouterNavParams) {
  NavDestination(){
    MessagePage({lifecycleProxy:params.pageLifecycle})
  }
  .onShown(()=>{
    params.pageLifecycle?.onShow?.()
  })
  .onHidden(()=>{
    params.pageLifecycle?.onHide?.()
  })
  .hideTitleBar(true)
}

@Component
export struct MessagePage {
  @State message: string = 'Hello World';

  //TODO 生命周期
  @Require lifecycleProxy?: YWRouterLifecycleImp


  aboutToAppear(): void {
    this.lifecycleProxy!.onShow = ()=> {

    }
    this.lifecycleProxy!.onHide = ()=> {

    }
  }
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.message = 'Welcome';
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
