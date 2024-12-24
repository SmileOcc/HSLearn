import util from '@ohos.util';
import { buffer } from '@kit.ArkTS';


/**
 * 字符串工具类
 */
export class YWStrUtils {

  private constructor() {}


  /**
   * 检测字符串的版本更新
   * @param verOld 0.0.11
   * @param verNew 1.11.1
   * @returns true需要更新
   */
  static checkVersionUpdate(verOld: string, verNew: string): boolean {
    const olds = verOld.split('\.');
    const news = verNew.split('\.');
    if (olds.length !== news.length && olds.length !== 3) {
      return false; //数据异常
    }
    const addValue = (num: string): number => {
      let newNum: string;
      if (num.length === 1) {
        newNum = `100${num}`
      } else if (num.length === 2) {
        newNum = `10${num}`
      } else if (num.length === 3) {
        newNum = `1${num}`
      } else {
        newNum = num;
      }
      return Number.parseInt(newNum);
    }
    for (let index = 0; index < olds.length; index++) {
      const o = addValue(olds[index]);
      const n = addValue(news[index]);
      if (n > o) {
        return true;
      } else if (n < o) {
        return false;
      }
    }
    return false;
  }

  /**
   * 判断是否是String
   * @param source
   * @returns
   */
  static isString(source: string | Object | ArrayBuffer | undefined | null) {
    return typeof source === 'string' || source instanceof String;
  }

  /**
   * 字符串是否为空(undefined、null)
   * @param str 被检测的字符串
   * @returns 是否为空
   */
  static isNull(str: string | undefined | null): boolean {
    return str == undefined || str == null;
  }

  /**
   * 判断字符串是否为非空。true为非空空，否则false
   * @param str
   * @returns
   */
  static isNotNull(str: string | undefined | null) {
    return false == YWStrUtils.isNull(str);
  }


  /**
   * 字符串是否为空(undefined、null、字符串长度为0)
   * @param str 被检测的字符串
   * @return 是否为空
   */
  static isEmpty(str: string | undefined | null): boolean {
    return str == undefined || str == null || str.length == 0;
  }

  /**
   * 判断字符串是否为非空。true为非空空，否则false
   * @param str
   * @returns
   */
  static isNotEmpty(str: string | undefined | null) {
    return false == YWStrUtils.isEmpty(str);
  }


  /**
   * 判断字符串是否为空和空白符(空白符包括空格、制表符、全角空格和不间断空格)。true为空，否则false
   * @param str
   * @returns
   */
  static isBlank(str: string | undefined | null): boolean {
    let length: number;
    if ((str == undefined) || (str == null) || ((length = str.length) == 0)) {
      return true;
    }
    for (let i = 0; i < length; i++) {
      // 只要有一个非空字符即为非空字符串
      if (false == YWStrUtils.isBlankChar(str.charCodeAt(i))) {
        return false;
      }
    }
    return true;
  }

  /**
   * 判断字符串是否为非空和空白符(空白符包括空格、制表符、全角空格和不间断空格)true为非空，否则false
   * @param str
   * @returns
   */
  static isNotBlank(str: string | undefined | null): boolean {
    return false == YWStrUtils.isBlank(str);
  }


  /**
   * 格式化字符串
   * @param source
   * @param defaultValue
   * @returns
   */
  static toStr(source: string | null | undefined, defaultValue = "") {
    if (source == null || source == undefined) {
      return defaultValue;
    }
    return String(source);
  }


  /**
   * 替换字符串中匹配的正则为给定的字符串
   * @param str   待替换的字符串
   * @param pattern  要匹配的内容正则或字符串
   * @param replacement 替换的内容
   * @returns 返回替换后的字符串
   */
  static replace(str: string = '', pattern: RegExp | string, replacement: string): string {
    return str.replace(pattern, replacement);
  }


  /**
   * 检查字符串是否以给定的字符串开头
   * @param string 要检索的字符串
   * @param target 要检索字符
   * @param position 检索的位置
   * @returns 如果字符串以字符串开头，那么返回 true，否则返回 false
   */
  static startsWith(string: string = '', target: string, position: number = 0): boolean {
    return string.startsWith(target, position);
  }


  /**
   * 检查字符串是否以给定的字符串结尾
   * @param str 要检索的字符串
   * @param target 要检索字符
   * @param position 检索的位置
   * @returns 如果字符串以字符串结尾，那么返回 true，否则返回 false
   */
  static endsWith(str: string = '', target: string, position: number = str.length): boolean {
    return str.endsWith(target, position);
  }


  /**
   * 将字符串重复指定次数
   * @param str  要重复的字符串
   * @param n  重复的次数
   * @returns
   */
  static repeat(str: string = '', n: number = 1): string {
    return str.repeat(n);
  }


  /**
   * 转换整个字符串的字符为小写
   * @param str 要转换的字符串
   * @returns 返回小写的字符串
   */
  static toLower(str: string = ''): string {
    return str.toLowerCase();
  }


  /**
   * 转换整个字符串的字符为大写
   * @param str 要转换的字符串
   * @returns 返回小写的字符串
   */
  static toUpper(str: string = ''): string {
    return str.toUpperCase();
  }


  /**
   * 转换字符串首字母为大写，剩下为小写
   * @param str 待转换的字符串
   * @returns 转换后的
   */
  static capitalize(str: string = ''): string {
    if (!str) {
      return '';
    }
    const firstChar = str.charAt(0).toUpperCase();
    const restChars = str.slice(1).toLowerCase();
    return firstChar + restChars;
  }


  /**
   * 判断两个传入的数值或者是字符串是否相等
   * @param source
   * @param target
   * @returns
   */
  static equal(source: string | number, target: string | number): boolean {
    return source === target;
  }

  /**
   * 判断两个传入的数值或者是字符串是否不相等
   * @param source
   * @param target
   * @returns
   */
  static notEqual(source: string | number, target: string | number): boolean {
    return false == YWStrUtils.equal(source, target);
  }


  /**
   * 字符串转Uint8Array
   * @param src 字符串
   * @returns Uint8Array
   */
  public static strToUint8Array(src: string, encoding: buffer.BufferEncoding = 'utf-8'): Uint8Array {
    let textEncoder = new util.TextEncoder(encoding);
    let result = textEncoder.encodeInto(src);
    return result;
  }

  /**
   * Uint8Array转字符串
   * @param src Uint8Array
   * @returns 字符串
   */
  static unit8ArrayToStr(src: Uint8Array, encoding: buffer.BufferEncoding = 'utf-8'): string {
    let textDecoder = util.TextDecoder.create(encoding, { ignoreBOM: true })
    let result = textDecoder.decodeWithStream(src, { stream: true });
    return result;
  }


  /**
   * 是否空白符 空白符包括空格、制表符、全角空格和不间断空格
   * @param c
   * @returns
   */
  static isBlankChar(c: number): boolean {
    return YWStrUtils.isWhitespace(c)
      || YWStrUtils.isSpaceChar(c)
      || c == 0xFEFF
      || c == 0x202A
      || c == 0x0000;
  }

  /**
   * 检查字符是否位于ASCII范围内（0~127）
   * @param ch 被检查的字符
   * @returns `true`表示为ASCII字符，否则为`false`
   */
  static isAscii(ch: string): boolean {
    // 确保输入的是单个字符
    if (ch.length !== 1) throw new Error("Input must be a single character");
    return ch.charCodeAt(0) < 128;
  }

  /**
   * 判断是否为emoji表情符
   * @param c 字符
   * @returns 是否为emoji
   */
  static isEmoji(c: number): boolean {
    // 使用 TypeScript 类型断言来告诉编译器我们已知这个条件不会是null或undefined
    const isNotEmoji = (c === 0x0) ||
      (c === 0x9) ||
      (c === 0xA) ||
      (c === 0xD) ||
      ((c >= 0x20 && c == 0xD7FF)) ||
      ((c >= 0xE000 && c == 0xFFFD)) ||
      ((c >= 0x100000 && c == 0x10FFFF));
    return !isNotEmoji;
  }


  private static isWhitespace(codePoint: number): boolean {
    const whitespaceRegex = /^\s$/;
    const character = String.fromCodePoint(codePoint);
    return whitespaceRegex.test(character);
  }

  private static isSpaceChar(codePoint: number): boolean {
    const spaceCategories = [
      "Zs", // Space separator
      "Zl", // Line separator
      "Zp"// Paragraph separator
    ];
    const character = String.fromCodePoint(codePoint);
    const category = character.charCodeAt(0).toString(16);
    return spaceCategories.includes(category);
  }




  /**
   * 判断是否是数值
   * @param value 需要判断的参数
   */
  // static isNumber(value: any): boolean {
  //   return typeof (value) === "number" && !isNaN(value);
  // }


  /**
   * 将字符串转换为整数。
   * @param value
   * @param defaultValue
   * @returns
   */
  static toInt(value: string, defaultValue: number = 0): number {
    try {
      const parsedValue = parseInt(value);
      if (isNaN(parsedValue)) {
        return defaultValue;
      }
      return parsedValue;
    } catch (e) {
      return defaultValue
    }
  }


  /**
   * 将字符串转换为浮点数。
   * @param value
   * @param defaultValue
   * @returns
   */
  static toFloat(value: string, defaultValue: number = 0): number {
    try {
      const parsedValue = parseFloat(value);
      if (isNaN(parsedValue)) {
        return defaultValue;
      }
      return parsedValue;
    } catch (e) {
      return defaultValue
    }
  }




  //手机号
  static validatePhoneNumber(phoneNumber: string): boolean {
    const pattern: string = '^1[3-9]\\d{9}$';
    const regexObj = new RegExp(pattern);
    return regexObj.test(phoneNumber);
  }

  /*正则校验: 密码*/
  static  regTestPassword(value: string): boolean {
    // const reg: RegExp = new RegExp('^\\d{8}$')
    const reg: RegExp = new RegExp('^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$')
    const res = reg.test(value)
    console.info('[正则校验] - pwd:', res)
    return res
  }




  //========base64

  /**
   * 字符串转Base64字符串
   * @param src 字符串
   * @returns
   */
  static strToBase64(src: string): string {
    let uint8Array = YWStrUtils.strToUint8Array(src);
    let result = YWStrUtils.encodeToStrSync(uint8Array);
    return result;
  }


  /**
   * Base64字符串转字符串
   * @param base64Str Base64字符串
   * @returns
   */
  static base64ToStr(base64Str: string): string {
    let uint8Array = YWStrUtils.decodeSync(base64Str)
    let result = YWStrUtils.unit8ArrayToStr(uint8Array)
    return result;
  }


  /**
   * 字符串转ArrayBuffer
   * @param str
   * @returns
   */
  static strToBuffer(src: string, encoding: buffer.BufferEncoding = 'utf-8'): ArrayBuffer {
    let buf = buffer.from(src, encoding);
    return buf.buffer
  }

  /**
   * ArrayBuffer转字符串
   * @param str
   * @returns
   */
  static bufferToStr(src: ArrayBuffer, encoding: buffer.BufferEncoding = 'utf-8'): string {
    let buf = buffer.from(src);
    let result = buf.toString(encoding);
    return result;
  }


  /**
   * ArrayBuffer转Uint8Array
   * @param str
   * @returns
   */
  static bufferToUint8Array(src: ArrayBuffer): Uint8Array {
    return new Uint8Array(src)
  }

  /**
   * Uint8Array转ArrayBuffer
   * @param str
   * @returns
   */
  static unit8ArrayToBuffer(src: Uint8Array): ArrayBuffer {
    return buffer.from(src).buffer;
  }



  /**
   * 编码，通过输入参数编码后输出Uint8Array对象。
   * @param array
   * @returns
   */
  static encodeSync(array: Uint8Array): Uint8Array {
    let base64 = new util.Base64Helper();
    let result = base64.encodeSync(array);
    return result;
  }


  /**
   * 编码，通过输入参数编码后输出对应文本。
   * @param array
   * @returns
   */
  static encodeToStrSync(array: Uint8Array, options?: util.Type): string {
    let base64 = new util.Base64Helper();
    let result = base64.encodeToStringSync(array, options);
    return result;
  }

  /**
   * 解码，通过输入参数解码后输出对应Uint8Array对象。
   * @param array
   * @returns
   */
  static decodeSync(array: Uint8Array | string, options?: util.Type): Uint8Array {
    let base64 = new util.Base64Helper();
    let result = base64.decodeSync(array, options);
    return result;
  }


  /**
   * 编码，通过输入参数编码后输出Uint8Array对象。
   * @param array
   * @returns
   */
  static encode(array: Uint8Array): Promise<Uint8Array> {
    let base64 = new util.Base64Helper();
    return base64.encode(array);
  }


  /**
   * 编码，通过输入参数编码后输出对应文本。
   * @param array
   * @returns
   */
  static encodeToStr(array: Uint8Array, options?: util.Type): Promise<string> {
    let base64 = new util.Base64Helper();
    return base64.encodeToString(array, options);
  }

  /**
   * 解码，通过输入参数解码后输出对应Uint8Array对象。
   * @param array
   * @returns
   */
  static decode(array: Uint8Array | string, options?: util.Type): Promise<Uint8Array> {
    let base64 = new util.Base64Helper();
    return base64.decode(array, options);
  }

}
