import { HashMap, util } from '@kit.ArkTS';
import BuildProfile from '../../../../BuildProfile';


//方式二
export class AppConfig {
  // 单例
  private static config: AppConfig;
  static getInstance(): AppConfig {
    if (AppConfig.config === undefined) {
      AppConfig.config = new AppConfig();
    }
    return AppConfig.config;
  }

  // 请求服务器地址
  public baseServerUrl: string = '';
  // 资源服务器地址
  public resourceServerUrl: string = '';
  // 是否为生产环境
  public isRelease: boolean = true;
  // 记录context，后面方法使用
  private context?: Context;

  /**
   * 初始化方法
   */
  init(context: Context, filePath?: string): void {
    try {
      this.context = context;
      // 配置文件路径（从环境配置中获取）
      let configFilePath: string = filePath ?? BuildProfile.APP_CONFIG;
      // 解析配置文件
      let bytes: Uint8Array = context.resourceManager.getRawFileContentSync(configFilePath);
      let content: string = AppConfig.bytesToString(bytes);
      let jsonObj: object = JSON.parse(content);
      // 重新组装map对象
      let configMap: HashMap<string, string|boolean> = new HashMap();
      let keys: string[] = Object.keys(jsonObj);
      keys.forEach(key => {
        let value: string|boolean = jsonObj[key];
        configMap.set(key, value);
      })
      // 获取配置文件字段值
      this.baseServerUrl = configMap.get("ServerUrl") as string;
      this.resourceServerUrl = configMap.get("ResourceUrl") as string;
      this.isRelease = configMap.get("release") as boolean;
    } catch (e) {

    }
  }

  /**
   * Uint8Array类型转换String
   * @param input bytes数据
   * @returns 返回字符串
   */
  public static bytesToString(input: Uint8Array): string {
    let output: string = '';
    try {
      let textDecoder = util.TextDecoder.create("utf-8",{ignoreBOM: true});
      output = textDecoder.decodeToString(input , {stream: false});
    } catch (err) {}
    return output;
  }
}
