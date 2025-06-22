import { Province } from "../components/model/HSAddressModel";
import { util } from "@kit.ArkTS";

/**
 * rawfile下json文件数据读取工具类
 */
export class JsonUtils {
  /**
   * 获取省市区信息的json文件数据
   * @param mockFileDir 要传入的json文件。这里指存放在rawfile下的address.json
   * @returns 返回json中省信息数组
   */
  static getAddressJson(mockFileDir: string): Array<Province> {
    const jsonObj: JsonObject = new JsonObject(mockFileDir);
    const modelMockData: Array<Province> = jsonObj.getAddressData();
    return modelMockData;
  }
}

/**
 * json对象类型
 */
class JsonObjType {
  // addressList必须和json文件里的一级键名保持一致
  addressList: Array<Province> = [];
}

/**
 * 读取json对象数据类
 */
class JsonObject {
  private jsonFileDir: string = '';

  constructor(jsonFileDir: string) {
    this.jsonFileDir = jsonFileDir;
  }

  /**
   * 获取rawfile下指定json文件的数据
   * @returns 返回省数据的数组
   */
  getAddressData(): Array<Province> {
    // TODO 知识点：使用getRawFileContentSync从rawfile目录下读取省市区json文件数据，使用util.TextDecoder进行解码。
    // 从rawfile本地json文件中获取数据
    const value = getContext().resourceManager.getRawFileContentSync(this.jsonFileDir);
    // 解码为utf-8格式
    const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    const textDecoderResult = textDecoder.decodeToString(new Uint8Array(value.buffer));
    const jsonObj: JsonObjType = JSON.parse(textDecoderResult) as JsonObjType;
    const modelBuckets: Array<Province> = [];
    // 映射json数据为model对象
    const modelObj = jsonObj.addressList;
    for (let i = 0; i < modelObj.length; i++) {
      const contactTemp = new Province(modelObj[i].code, modelObj[i].name, modelObj[i].children);
      // 从json中读取每个省数据写入modelBuckets
      modelBuckets.push(contactTemp);
    }
    return modelBuckets;
  }
}