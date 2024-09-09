import { OsRouterUrls } from '@learn/common_har/Index';
import { ITigerAppContext } from '../../core/ITigerAppContext';
import { ILaunchListener, ILaunchServer } from '../../core/launchexecute/ILaunchServer';
import { LaunchStepState } from '../../core/launchexecute/LaunchStepState';
import { TigerServerType } from '../../core/launchexecute/TigerServerType';
import { TigerGlobalThis } from '../../core/TigerGlobalThis';
import { LaunchLoadingView } from '../loading/LaunchLoadingView';

@Entry({routeName:OsRouterUrls.TIGER_APP})
@Component
export struct MainPage {
  @State message: string = 'Hello Tiger';

  @State isLoading: boolean = true
  private appContext: ITigerAppContext = TigerGlobalThis.getInstance().getAppContext()

  lauchListener:ILaunchListener = {
    onEntry:(async (state:LaunchStepState) =>{
      switch (state) {
        case LaunchStepState.onInit:
          console.debug("====== init on ===a")
          break;
        case LaunchStepState.onFinish:
          this.isLoading = false
          break;
      }
    })
  }

  build() {
    Row() {
      if (this.isLoading) {
        LaunchLoadingView()
      } else {
        Column() {
          Text(this.message)
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
      }

    }
    .height('100%')
  }

  aboutToAppear(): void {

    //启动任务
    let launchServer = this.appContext.onGetMainAppServer<ILaunchServer>(TigerServerType.launcher)
    launchServer.registerServer(this.lauchListener)

    launchServer.onStart()
  }

  aboutToDisappear(): void {
    // this.appContext.
  }
}
