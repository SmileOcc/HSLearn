import { AbilityConstant, AbilityStage } from "@kit.AbilityKit";
import { kyStoreManger, PreferencesUtil, YWAppEvent, YWDeviceUtils } from "@learn/common_har";
import { distributedKVStore } from "@kit.ArkData";
import { axiosAddHeader } from "@learn/request_har/src/main/ets/AxiosRequest/AxiosRequest";
import { hsLog } from '@learn/logger_har';
import { YWAppUtils, globalThis, ENU_PREFS } from '@learn/common_har'
import { YWConstants } from "@learn/constants_har";
import { ywManagerTask } from "@learn/manager_task_har";
import { LauncherStage } from "@learn/hs_launcher_har";

/*
 * @Desc: 应用入口，初始化一些库和SDK，在module.json5配置路径。
 */
const TAG = 'LearnStage'

export default class LearnStage extends LauncherStage {
  onCreate(): void {
    hsLog.i(TAG,'onCreate')
    super.onCreate()
    let stageTask = ywManagerTask.launchTask?.stageTask
    if (stageTask) {
      //TODO 先合并在一起了
      ywManagerTask.handTask(this.context, stageTask)
    }

    this.initParams()
    //初始化一些库或三方sdk

    this.onThirdLibInit()
    this.onUIInit()
    this.onNetworkInit()
  }

  initParams() {
    //异步加载
    setTimeout(async () => {

      const statusBarHeight = Number(AppStorage.get(YWConstants.kStatusBarHeight))

      // const noiseValue = await pref.get<number>(Const.NOISE_VALUE, Const.DEF_NOISE_VALUE);
      // globalThis.setObject(Const.NOISE_VALUE, noiseValue);
    })
  }

  onMemoryLevel(level: AbilityConstant.MemoryLevel): void {
    // 根据系统可用内存的变化情况，释放不必要的内存
    hsLog.i(TAG, 'onMemoryLevel -> ' + level);
  }

  private onThirdLibInit() {


    //首选项本地数据 直接使用
    PreferencesUtil.getData(this.context)

    //数据持久化，缓存数据到本地
    let config:distributedKVStore.KVManagerConfig = {
      bundleName: 'com.example.hmos_learn',
      context: this.context
    }
    kyStoreManger.init(config,'myHMStore')

    //崩溃事件
    YWAppEvent.crashSubscribe()

  }

  private onUIInit(){

  }

  private async onNetworkInit(){

    const deviceId = await YWDeviceUtils.getDeviceId();
    // const localCookie = await loginService.getCookie();
    //
    // axiosAddHeader({
    //   'clientType': 'H',
    //   'deviceId': deviceId,
    //   'version': OsUtil.getVersionName(),
    //   'clientInfo': `${deviceInfo.brand}|${deviceInfo.marketName}|${deviceInfo.displayVersion}`,
    //   'Cookie': localCookie
    // })
  }

}