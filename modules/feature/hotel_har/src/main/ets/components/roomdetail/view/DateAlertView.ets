import { YWDateUtils } from '@learn/common_har'
@CustomDialog
export struct DateAlertView {
  dateController: CustomDialogController

  @State sourceDate: Date | undefined = new Date()
  minStartDate:Date = new Date()
  currentDate:Date = this.sourceDate ?? new Date()

  // selectDate: ()=> Date = () => {
  //   return this.sourceDate
  // }

  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  isCanConfirm(){

    let currentStr = JSON.stringify(this.currentDate)
    let minStr = JSON.stringify(this.minStartDate)

    if (currentStr > minStr) {
      return true
    }
    return false
  }


  build() {
    Column() {
      Text(YWDateUtils.dateYearMonthDayWeek(this.currentDate))
        .height(60)
      DatePicker({
        start: new Date(),
        end: new Date('2025-1-1'),
        selected: this.currentDate
      })
        .lunar(false)
        .onDateChange((value: Date) => {

          this.currentDate = value
          console.info('====== select current date is: ' + JSON.stringify(this.sourceDate))
          console.info('====== select current date is: ' + JSON.stringify(value))
          console.info('=======   ' + value.getFullYear() + " " + value.getMonth() + " " + value.getDay())

        })
      Row(){
        Button('取消')
          .fontColor(Color.Blue)
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .onClick(()=>{
            this.cancel()
            this.dateController.close()
          })
        Divider().height(15).width(1).backgroundColor($r('app.color.col_EEEEEE'))
        Button('确定')
          .fontColor(Color.Blue)
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .onClick(()=>{
            if (this.isCanConfirm()) {
              this.sourceDate = this.currentDate
              this.confirm()
              this.dateController.close()
            } else {
              AlertDialog.show({message:'截止日期不能早于起始日期'})
            }

          })
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .height(76)
      .padding({top:24,bottom:12})
      .width('100%')
      .backgroundColor(Color.White)

    }

    .width('100%')
  }
}