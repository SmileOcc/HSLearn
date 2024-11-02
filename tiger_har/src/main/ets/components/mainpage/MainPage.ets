import { OsRouterUrls } from '@learn/common_har/Index';
import { IUState } from '@learn/common_har/src/main/ets/model/YWBaseModel';
import { ITigerAppContext } from '../../core/ITigerAppContext';
import { ILaunchListener, ILaunchServer } from '../../core/launchexecute/ILaunchServer';
import { LaunchStepState } from '../../core/launchexecute/LaunchStepState';
import { TigerServerType } from '../../core/launchexecute/TigerServerType';
import { TigerGlobalThis } from '../../core/TigerGlobalThis';
import { LaunchLoadingView } from '../loading/LaunchLoadingView';
import { MainUIState, MainViewModel } from './MainViewModel';
import { promptAction } from '@kit.ArkUI';

@Entry({routeName:OsRouterUrls.TIGER_APP})
@Component
export struct MainPage {
  @State message: string = 'Hello Tiger';

  private appContext: ITigerAppContext = TigerGlobalThis.getInstance().getAppContext()

  private viewModel:MainViewModel = new MainViewModel(this.appContext)

  @State iuState: MainUIState = this.viewModel.iuState



  build() {
    Stack(){
      Row() {
        if (this.iuState.isLoading) {
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
      .width('100%')
      .height('100%')

      NodeContainer(this.viewModel.getMainNodeControl())
        .id('nodeContainer')
        .onClick(() => {
          promptAction.showToast({ message: '哎呦' })
        })
    }

  }

  aboutToAppear(): void {

  }

  aboutToDisappear(): void {
    // this.appContext.
  }
}
