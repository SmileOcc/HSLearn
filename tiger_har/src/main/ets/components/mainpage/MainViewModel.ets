import YWBaseModel, { IUState } from '@learn/common_har/src/main/ets/model/YWBaseModel';
import { ITigerAppContext } from '../../core/ITigerAppContext';
import { ILaunchListener, ILaunchServer } from '../../core/launchexecute/ILaunchServer';
import { LaunchStepState } from '../../core/launchexecute/LaunchStepState';
import { TigerServerType } from '../../core/launchexecute/TigerServerType';
import { ExecuteInfo, LaunchStepData } from '../../core/task/LaunchStep';
import { DialogConfig, DialogShowType, DialogView } from '../dialog/DialogView';

export class MainViewModel extends YWBaseModel<MainUIState> {
  iuState: MainUIState = new MainUIState()
  private appContext:ITigerAppContext

  private lauchListener:ILaunchListener = {
    onEntry:(async (state:LaunchStepState,info?:LaunchStepData) =>{
      switch (state) {
        case LaunchStepState.onInit:
          console.debug("====== init on ===a")
          break;
        case LaunchStepState.onFinish:
          this.iuState.isLoading = false
          break;
        case LaunchStepState.onLoadError:
          console.debug("====== init on ===onLoadError")
          if (info?.error) {

          }
          this.showErrorAlert()
        break;
        case LaunchStepState.onCommonError:
          console.debug("====== init on ===onCommonError")
          break;
      }
    })
  }

  constructor(context:ITigerAppContext) {
    super()
    this.appContext = context

    //启动任务
    let launchServer = this.appContext.onGetMainAppServer<ILaunchServer>(TigerServerType.launcher)
    launchServer.registerServer(this.lauchListener)

    launchServer.onStart()
  }

  showErrorAlert() {
    let config:DialogConfig = {
      showType:DialogShowType.Ver,
      title:"title",
      content:"content"}
    let alert = new DialogView({config:config})
  }

}

@Observed
export class MainUIState implements IUState {
  isLoading:Boolean = true

}