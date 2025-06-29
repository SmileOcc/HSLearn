import { AbilityConstant, Want } from '@kit.AbilityKit'
import { window } from '@kit.ArkUI'
import { MainAbility } from '@learn/main_har'
import { YWAppUtils, hsGlobalThis, YWDeviceUtils } from '@learn/common_har'
import { MMKV } from '@tencent/mmkv';
import { YWLocalNavType, YWNavPath, ywNavRouter } from '@learn/nav_router_har';
import { RootSettingBuilder } from '../pages/setting/SettingPage';
import { webview } from '@kit.ArkWeb';
import { hsLog } from '@learn/logger_har';
import { HSLocalConfig } from '@learn/app_config_har';
import BuildProfile from 'BuildProfile';
import { hsMockManager } from '@learn/res_har';
import { ImageKnife } from '@ohos/imageknife';

const TAG = "LearnEntryAbility"
export abstract  class LearnEntryAbility extends MainAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onCreate(want, launchParam)
    //ability 的context 与UI中取得Context一致 与stage不一致
    HSLocalConfig.InitLocalRes(this.context)
    let envName: string = HSLocalConfig.getEnv()
    hsLog.i(TAG,`环境配置 envName: ${envName}`);

    this.initGlobal()
    this.handWant(want)

    //开发者可以在模块级的build-profile.json5文件中增加自定义参数
    let BUILD_TYPE =  BuildProfile.BUILD_TYPE


    // 案例一：如果要提前对应用的首页进行操作，
    // 可以通过initializeBrowserEngine()来提前初始化ArkWeb组件的内核，
    // 然后在初始化内核后调用prepareForPageLoad()对即将要加载的页面进行预连接。
    // 在prepareForPageLoad中，指定第二个参数为true，代表要进行预连接，如果为false，
    // 该接口只会对网址进行DNS预解析。具体代码如下所示

    webview.WebviewController.initializeWebEngine();
    // 预连接时，需要將'https://www.example.com'替换成真实要访问的网站地址。
    // 指定第二个参数为true，代表要进行预连接，如果为false该接口只会对网址进行DNS预解析
    webview.WebviewController.prepareForPageLoad('https://www.example.com/', true, 2);
    AppStorage.setOrCreate('abilityWant', want);
    hsLog.i(TAG,'EntryAbility onCreate done');

    // 判断是否模拟器  反调试检测
    YWDeviceUtils.isRunningOnEmulator().then((result) => {
      if (result) {
        hsLog.i(TAG,'The app is running on an emulator.');
      } else {
        hsLog.i(TAG,'The app is running on a real device.');
      }
    });

    //本地mock数据
    hsMockManager.setContext(this.context)

    // 如果需要用文件缓存，需要提前初始化文件缓存
    ImageKnife.getInstance().initFileCache(this.context, 256, 256 * 1024 * 1024)
 }


  onWindowStageCreate(windowStage: window.WindowStage): void {
    super.onWindowStageCreate(windowStage)
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onNewWant(want,launchParam)
    this.handWant(want)
  }
  flashPage() {
    return "pages/FlashPage"
  }

  handWant(want: Want) {

  }

  initGlobal() {

    //初始化MMKV
    let appCtx = this.context.getApplicationContext();
    let mmkvRootDir = MMKV.initialize(appCtx);
    hsLog.i(TAG,'mmkv rootDir: ', mmkvRootDir);

    //初始化
    hsGlobalThis.init(this.context)
  }
}