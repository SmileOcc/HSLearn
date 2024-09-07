@Entry
@Component
struct DistributedSoftBusPage {
  @State message: string = 'Hello World';


  //使用跨设备通信时，
  // 必须添加权限ohos.permission.DISTRIBUTED_DATASYNC
  // 和ohos.permission.DISTRIBUTED_SOFTBUS_CENTER，
  // 该权限类型为 dangerous
  aboutToAppear(): void {


  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}