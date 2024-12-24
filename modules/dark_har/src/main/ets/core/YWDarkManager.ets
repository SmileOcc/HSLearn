import { ConfigurationConstant } from "@kit.AbilityKit"

//与ywConstants中定义一样
const kLocalColorModel = 'LocalColorModel'
const kUI_RootContext = 'UI_RootContext'

export class YWDarkManager {

  // //跟随系统
  // getContext(this)
  // .getApplicationContext()
  // .setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
  //
  // //深色模式
  // getContext(this)
  // .getApplicationContext()
  // .setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK)
  //
  // //浅色模式
  // getContext(this)
  // .getApplicationContext()
  // .setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)

  static async initConfigDark(context: Context) {
    const appContext = context.getApplicationContext()

    // let colorMode = AppStorage.get<ConfigurationConstant.ColorMode>(kLocalColorModel)
    //
    // if (colorMode == ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
    //   appContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
    //
    // } else if (colorMode == ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) {
    //   appContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    //
    // } else {
    //   appContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
    // }

    let config = await appContext.resourceManager.getConfiguration()
    let colorModel = config.colorMode
    AppStorage.set(kLocalColorModel, colorModel)

    appContext.on('environment',{
      onConfigurationUpdated(config){

        const ctx = AppStorage.get<Context>(kUI_RootContext)
        ctx?.getApplicationContext().setColorMode(config.colorMode)
        AppStorage.set(kLocalColorModel, config.colorMode)

      },
      onMemoryLevel(level){}
    })
  }

  static getDefaultTheme():ConfigurationConstant.ColorMode {
    return AppStorage.get(kLocalColorModel) ?? ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT
  }

  static isDark(context: Context):boolean {

    return false
  }

  static setTheme(mode: ConfigurationConstant.ColorMode) {
    const ctx = AppStorage.get<Context>(kLocalColorModel)
    ctx?.getApplicationContext().setColorMode(mode)
    AppStorage.set(kLocalColorModel, mode)
  }

  //设置浅色模式
  static setLight() {
    YWDarkManager.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
  }

  //设置深色模式
  static setDark() {
    YWDarkManager.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_DARK)
  }

  //设置跟随系统
  static setNot() {
    YWDarkManager.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
  }
}