import { AbilityConstant, Want } from '@kit.AbilityKit'
import { window } from '@kit.ArkUI'
import { MainAbility } from '@learn/main_har'
import { YWAppUtils, globalThis } from '@learn/common_har'
import { MMKV } from '@tencent/mmkv';


export abstract  class LearnEntryAbility extends MainAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onCreate(want, launchParam)
    //ability 的context 与UI中取得Context一致 与stage不一致
    this.initGlobal()
    this.handWant(want)
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
    console.info('mmkv rootDir: ', mmkvRootDir);

    //初始化
    globalThis.init(this.context)
  }
}