import { BaseEntryAbility } from '@learn/base_har'
import { AbilityConstant, Want } from '@kit.AbilityKit'
import { window } from '@kit.ArkUI'
import { MainAbility } from '@learn/main_har'
import { YWAppUtils, globalThis, ENU_PREFS } from '@learn/common_har'
import { TigerRouteUtils } from '@learn/tiger_har'
import dataPreferences from '@ohos.data.preferences';
import { BusinessError } from '@kit.BasicServicesKit'
import { MMKV } from '@tencent/mmkv';

const KEY_APP_PRIVACY = 'nutsusKey';
const PREFERENCES_NAME = 'nutsusPreferences';

export abstract  class LearnEntryAbility extends MainAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onCreate(want, launchParam)

    //初始化MMKV
    let appCtx = this.context.getApplicationContext();
    let mmkvRootDir = MMKV.initialize(appCtx);
    console.info('mmkv rootDir: ', mmkvRootDir);


    AppStorage.setOrCreate('isLoginGG', "12333");

    //初始化
    globalThis.init(this.context)
    //全局持有
    globalThis.setContext("MainContext", this.context);
    // 缓存context
    globalThis.setContext("context", this.context);


    // 缓存作者属性值
    globalThis.setAttribute("author", "狼哥");
    // 缓存组织属性值
    globalThis.setAttribute("org", "坚果派");

    let preferences: Promise<dataPreferences.Preferences> = dataPreferences.getPreferences(this.context, PREFERENCES_NAME);
    // 缓存首选项Promise
    globalThis.setPref(ENU_PREFS.Global, preferences);

    preferences.then((result: dataPreferences.Preferences) => {
      // 存储文本到nutsusKey主键
      result.putSync(KEY_APP_PRIVACY, "坚果派由坚果创建，团队拥有8个华为HDE，3个HSD，以及若干其他领域的三十余位万粉博主运营。");
      console.log('xxx')
    }).catch((err: BusinessError) => {
      console.error('xx put the preferences failed, err: ' + err);
    });

    //使用
    //let context: common.UIAbilityContext | undefined = GlobalThis.getInstance().getContext("MainContext");

    this.handWant(want)
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    super.onWindowStageCreate(windowStage)

    //初始化
    YWAppUtils.init(this.context,windowStage)
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
}