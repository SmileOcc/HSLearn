import { MapToStringTS } from "./YWMapUtilsTS";

export class YWMapUtils {
  //Map set不能支持json转成字符串
  //Map转字符串 entries也只能转一层，嵌套的还是[object object]
  //感觉是鸿蒙的bug
  static mapToString(data: Map<string, Object>): string {
    return MapToStringTS(data)
  }
}