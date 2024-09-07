/**
 * 日期工具类
 */

export class YWDateUtils {

  private constructor() {}

  /**
   * yyyyMMdd 格式年月日
   */
  static YMD: string = "yyyyMMdd";

  /**
   * HH:mm:ss 格式时间
   */
  static HMS: string = "HH:mm:ss";

  /**
   * HH:mm 格式时间
   */
  static HM: string = "HH:mm";

  /**
   *yyyy-MM-dd 格式年月日
   */
  static YMD_HLINE: string = "yyyy-MM-dd";

  /**
   *yyyy-MM-dd HH:mm:ss  格式日期时间
   */
  static YMD_HLINE_HMS: string = "yyyy-MM-dd HH:mm:ss";

  /**
   *yyyy-MM-dd HH:mm  格式日期时间
   */
  static YMD_HLINE_HM: string = "yyyy-MM-dd HH:mm";

  /**
   *yyyy/MM/dd 格式日期(注:官方bug对/兼容问题可能会有问题只显示yyyy格式日期)
   */
  static YMD_BLINE: string = "yyyy/MM/dd";

  /**
   *yyyy/MM/dd HH:mm:ss 格式日期(注:官方bug对/兼容问题可能会有问题只显示yyyy格式日期)
   */
  static YMD_BLINE_HMS: string = "yyyy/MM/dd HH:mm:ss";

  /**
   *yyyy/MM/dd HH:mm  格式日期(注:官方bug对/兼容问题可能会有问题只显示yyyy格式日期)
   */
  static YMD_BLINE_HM: string = "yyyy/MM/dd HH:mm";

  /**
   *将传入的日期字符串按照传入的format进行格式化输出,不传默认为yyyy-MM-dd,日期格式化年月日时分秒为y-M-d H:m:s
   * @param value
   * @param format  格式化字符串
   * @returns
   */
  static formatDate(value: string, format: string = 'yyyy-MM-dd'): string {
    const date = new Date(value);
    if (value.split(' ').length <= 1 && value.split('T').length <= 1) {
      date.setHours(0);
      date.setMinutes(0);
      date.setSeconds(0);
    }
    const year = date.getFullYear();
    const month = YWDateUtils.padZero(date.getMonth() + 1);
    const day = YWDateUtils.padZero(date.getDate());
    const hours = YWDateUtils.padZero(date.getHours());
    const minutes = YWDateUtils.padZero(date.getMinutes());
    const seconds = YWDateUtils.padZero(date.getSeconds());
    let formattedDate = format.replace("yyyy", year.toString());
    formattedDate = formattedDate.replace("MM", month);
    formattedDate = formattedDate.replace("dd", day);
    formattedDate = formattedDate.replace("HH", hours);
    formattedDate = formattedDate.replace("mm", minutes);
    formattedDate = formattedDate.replace("ss", seconds);
    return formattedDate;
  }

  /**
   *将日期类型的Date根据传入的format格式化成日期字符串(format必传)
   * @param date
   * @param formatString  格式化字符串
   * @returns
   */
  static format(date: Date, formatString: string): string {
    const year = date.getFullYear();
    const month = YWDateUtils.padZero(date.getMonth() + 1);
    const day = YWDateUtils.padZero(date.getDate());
    const hours = YWDateUtils.padZero(date.getHours());
    const minutes = YWDateUtils.padZero(date.getMinutes());
    const seconds = YWDateUtils.padZero(date.getSeconds());

    let formattedDate = formatString.replace("yyyy", year.toString());
    formattedDate = formattedDate.replace("MM", month);
    formattedDate = formattedDate.replace("dd", day);
    formattedDate = formattedDate.replace("HH", hours);
    formattedDate = formattedDate.replace("mm", minutes);
    formattedDate = formattedDate.replace("ss", seconds);

    return formattedDate;
  }

  /**
   * 计算两个Date的日期差单位为天
   * @param startDate  开始日期
   * @param endDate  结束日期
   * @returns
   */
  static dateDiff(startDate: Date, endDate: Date): number {
    const oneDay = 24 * 60 * 60 * 1000; // 一天的毫秒数
    // 将时间戳转换为整数天数
    const start = Math.floor(startDate.getTime() / oneDay);
    const end = Math.floor(endDate.getTime() / oneDay);
    const difference = end - start; // 计算差值天数
    return difference;
  }

  /**
   *计算两个字符串日期的差单位为天
   * @param startDateStr 开始日期字符串
   * @param endDateStr   结束日期字符串
   * @returns
   */
  static strDateDiff(startDateStr: string, endDateStr: string): number {
    let startDate = new Date(startDateStr);
    let endDate = new Date(endDateStr);
    const oneDay = 24 * 60 * 60 * 1000; // 一天的毫秒数
    const difference = Math.floor((endDate.getTime() - startDate.getTime()) / oneDay); // 计算差值天数
    return difference;
  }


  /**
   * 获取今天的日期
   * @returns
   */
  static getToday(): Date {
    return new Date();
  }

  /**
   * 获取今天的时间戳
   * @returns
   */
  static getTodayTime(): number {
    return new Date().getTime();
  }

  /**
   * 获取今天的时间，字符串类型
   * @param formatStr 格式化字符串
   * @returns
   */
  static getTodayStr(formatStr?: string): string {
    return YWDateUtils.getFormatDateStr(new Date(), formatStr)
  }

  /**
   * 获取格式化日期，将传入的日期格式化为Date
   * @param date
   * @returns
   */
  static getFormatDate(date: number | string | Date | undefined): Date {
    if (date == undefined) { //无参数
      date = new Date();
    } else if (typeof (date) == "string") { //字符串日期
      if (date.length == 0) {
        date = new Date();
      } else {
        let dateStr = date.replace("-", '/')
          .replace("年", '/').replace("月", '/').replace("日", ' ')
          .replace("时", ':').replace("分", ':').replace("秒", '')
        date = new Date(dateStr);
      }
    } else if (typeof (date) == "number") { //时间戳
      date = new Date(date);
    } else {
      date = new Date(date);
    }
    return date;
  }

  /**
   * 获取格式化日期，将传入的日期格式化为指定格式的字符串
   * @param date
   * @param formatStr 格式化字符串
   * @returns
   */
  static getFormatDateStr(date: number | string | Date, formatStr?: string): string {
    date = YWDateUtils.getFormatDate(date)
    if (formatStr === undefined || formatStr == '') {
      formatStr = "yyyy-MM-dd HH:mm:ss"; //yyyy-MM-dd HH:mm:ss.fff
    }
    const year = date.getFullYear();
    const month = YWDateUtils.padZero(date.getMonth() + 1);
    const day = YWDateUtils.padZero(date.getDate());
    const hours = YWDateUtils.padZero(date.getHours());
    const minutes = YWDateUtils.padZero(date.getMinutes());
    const seconds = YWDateUtils.padZero(date.getSeconds());
    let formattedDate = formatStr.replace("yyyy", year.toString());
    formattedDate = formattedDate.replace("MM", month);
    formattedDate = formattedDate.replace("dd", day);
    formattedDate = formattedDate.replace("HH", hours);
    formattedDate = formattedDate.replace("mm", minutes);
    formattedDate = formattedDate.replace("ss", seconds);
    return formattedDate;
  }

  /**
   * 格式化时间戳，获取提示性时间字符串
   * @param timeStamp
   *   时间戳：10位时间戳:表示从1970年1月1日00:00:00 GMT开始计算的秒数，精度为秒。
   *          13位时间戳:表示从1970年1月1日00:00:00 GMT开始计算的毫秒数，精度为毫秒。
   * @returns
   */
  static getTipDateStr(timeStamp: number): string {
    let timeMs = timeStamp;
    if (timeStamp.toString().length == 10) {
      timeMs = timeStamp * 1000 //如果是10位的时间戳转化为13位的
    }
    let dateNow = new Date();
    let dateUp = new Date(timeMs);
    if (dateNow.getTime() - timeMs < 60 * 1000) {
      return "刚刚";
    } else if (dateNow.getTime() - timeMs < 60 * 60 * 1000) {
      return ((dateNow.getTime() - timeMs) / (60 * 1000)).toFixed() + "分钟前";
    } else if (dateNow.getTime() - timeMs < 24 * 60 * 60 * 1000) {
      return ((dateNow.getTime() - timeMs) / (60 * 60 * 1000)).toFixed() + "小时前";
    } else if (dateNow.getTime() - timeMs < 360 * 24 * 60 * 60 * 1000) {
      return YWDateUtils.getFormatDateStr(dateUp, "MM月dd日");
    } else {
      return YWDateUtils.getFormatDateStr(dateUp, "yyyy-MM-dd");
    }
  }


  /**
   * 获取两个Date的日期差单位为天
   * @param startDate  开始日期
   * @param endDate  结束日期
   * @returns
   */
  static getDateDiff(startDate: number | string | Date, endDate: number | string | Date): number {
    const oneDay = 24 * 3600 * 1000; //一天的毫秒数
    let startDateTime = YWDateUtils.getFormatDate(startDate).getTime();
    let endDateTime = YWDateUtils.getFormatDate(endDate).getTime();
    const difference = Math.floor((endDateTime - startDateTime) / oneDay); //计算差值天数
    return difference;
  }


  /**
   * 判断传入字符串是否是日期字符串
   * @param value 待验证的字符串
   * @returns
   */
  static isDate(value: string): boolean {
    //需要循环常量中的时间格式看看是否符合，符合极为日期类型
    const dateTimeRegex = /^(?:(?:\d{4}(?:\/|-)\d{1,2}(?:\/|-)\d{1,2})|(?:\d{1,2}:\d{1,2}(:\d{1,2})?))(\s(?:\d{1,2}:\d{1,2}:\d{1,2}))?$/;
    return dateTimeRegex.test(value);
  }


  /**
   * 补零操作
   * @param num
   * @returns
   */
  private static padZero(num: number): string {
    return num.toString().padStart(2, "0");
  }

}