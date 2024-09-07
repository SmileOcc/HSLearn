import router from '@ohos.router'

@Entry
@Component
export struct HWSuccessPage {
  @State message: string = 'Hello World HW';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button("<<back")
          .onClick(()=>{
            router.back()
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}