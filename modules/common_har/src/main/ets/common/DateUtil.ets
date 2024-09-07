
export class  DateUtil {
  static dateYearMonthDayWeek(tDate:Date){
    let year = tDate.getFullYear();

    let month = tDate.getMonth() + 1
    //几号
    let day = tDate.getDate()
    //使用当地时间获取一周中的哪一天
    let wday = tDate.getDay()

    let weekDay = DateUtil.dayNumberToUpNumber(wday)

    return year+'年'+month+'月'+day+'日'+' 星期'+weekDay
  }

  static dateMonthDay(tDate:Date){
    let month = tDate.getMonth() + 1
    //几号
    let day = tDate.getDate()
    //使用当地时间获取一周中的哪一天
    // let wday = tDate.getDay()
    // let weekDay = DateUtil.dayNumberToUpNumber(wday)

    return month+'月'+day+'日'
  }

  static dayNumberToUpNumber(wday:number) {
    let weekDay = wday + ''
    if (wday == 0) {
      weekDay = '日'
    } else if(wday == 1) {
      weekDay = '一'
    } else if(wday == 2) {
      weekDay = '二'
    } else if(wday == 3) {
      weekDay = '三'
    } else if(wday == 4) {
      weekDay = '四'
    } else if(wday == 5) {
      weekDay = '五'
    } else if(wday == 6) {
      weekDay = '六'
    }
    return weekDay
  }

  static dateNumberYearMonthDay(tDate:Date){
    let year = tDate.getFullYear();

    let month = tDate.getMonth() + 1
    //几号
    let day = tDate.getDate()

    return year+'-'+month+'-'+day
  }
}