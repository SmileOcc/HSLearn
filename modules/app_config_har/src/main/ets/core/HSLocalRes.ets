import { util } from "@kit.ArkTS";
import { hsLog } from "@learn/logger_har";

const TAG = "LearnConfig"

export class HSLocalConfig {
  private learnConfig?: ILearnConfig

  private constructor() {
  }

  private static instance: HSLocalConfig;

  static InitLocalRes(context: Context) {
    let localConfig = LocalRes(context)
    if (localConfig) {
      HSLocalConfig.setLearnConfig(localConfig)

    }
  }

  public static getInstance(): HSLocalConfig {
    if (!HSLocalConfig.instance) {
      HSLocalConfig.instance = new HSLocalConfig();
    }
    return HSLocalConfig.instance;
  }

  static setLearnConfig(config: ILearnConfig) {
    HSLocalConfig.getInstance().learnConfig = config
  }

  static getLearnConfig(): ILearnConfig | undefined {
    return HSLocalConfig.getInstance().learnConfig
  }

  static getEnv(): string {
    if (HSLocalConfig.getInstance()) {
      hsLog.i(TAG, 'config 配置 0: ' + HSLocalConfig.getInstance());

    }
    if (HSLocalConfig.getInstance().learnConfig) {
      let kkk: ILearnConfig = HSLocalConfig.getInstance().learnConfig!
      hsLog.i(TAG, 'config 配置 00: ' +JSON.stringify(kkk));
      hsLog.i(TAG, 'config 配置 00: ' +kkk);


    }
    let kkk = HSLocalConfig.getInstance().learnConfig?.evnName ?? ""
      hsLog.i(TAG, 'config 配置 1: ' + kkk);

    return HSLocalConfig.getInstance().learnConfig?.evnName ?? ""
  }
}

export function LocalRes(context: Context): ILearnConfig | undefined {
  // 获取配置文件
  try {
    let resourceManager = context.getApplicationContext().resourceManager;
    let rawFile = resourceManager.getRawFileContentSync("learn-config.json");
    let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    let jsonString = textDecoder.decodeToString(rawFile, { stream: false });
    let configObj = JSON.parse(jsonString) as ILearnConfig;
    hsLog.i(TAG, 'config 配置: ' + jsonString);
    // 使用configObj中的参数...
    return configObj
  } catch (e) {
    hsLog.e(TAG, "config 错误: " + e);
    return undefined
  }
}

export interface ILearnConfig {
  evnName: string
  sslkey: string
  qrkey: string
}
