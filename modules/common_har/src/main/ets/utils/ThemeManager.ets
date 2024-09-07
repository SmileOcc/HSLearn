import { windowStage_ } from '../../../../../../learn/src/main/ets/entryability/EntryAbility'

export class ThemeManager {

  public static settingStatusBarWhite() {

    windowStage_.getMainWindowSync().setWindowBackgroundColor('#ffffff')
  }

  public static settingStatusBarBlack() {
    windowStage_.getMainWindowSync().setWindowBackgroundColor('#E92F4F')

  }

  public static settingStatusBarRed() {
    windowStage_.getMainWindowSync().setWindowBackgroundColor('#E92F4F')

  }
}