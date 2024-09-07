@Entry
@Component
struct CalculatorPage {
  @State message: string = 'Hello World';

  Number:string[] = ["c","÷","×","7","8","9","4","5","6","1","2","3","%","0","."]

  @Builder ClItem(conttent:string,font_size:number,font_color:Color,backgroud_color:Color,border_radiu:number) {


  }

  build() {
    Text()
    // Flex({direction:FlexDirection.Row}){
    //   Grid() {
    //     ForEach(this.Number, (day: string,index:number) => {
    //       GridItem() {
    //         if (index == 0) {
    //           // ClItem({content:day,font_size:20,font_color:0xFFFFFF,background_color:0x363746,border_radiu:{topLeft:30}})
    //           //   .onClick(()=>{
    //           //     this.clearClick()
    //           //   })
    //         }else if(index == 1 || index == 2){
    //           ClItem({content:day,font_size:60,font_color:0xFFBB00,background_color:0x363746,border_radiu:{}})
    //             .onClick(()=>{
    //               this.calClick(day)
    //             })
    //         }
    //         else {
    //           if(day == '%'){
    //             ClItem({content:day,font_size:20,font_color:0xFFFFFF,background_color:0x2E2F3E,border_radiu:{}})
    //
    //           }else if(day == "."){
    //             ClItem({content:day,font_size:20,font_color:0xFFFFFF,background_color:0x2E2F3E,border_radiu:{}})
    //               .onClick(()=>{
    //                 this.numClick(day)
    //               })
    //
    //           }else {
    //             ClItem({content:day,font_size:20,font_color:0xFFFFFF,background_color:0x2E2F3E,border_radiu:{}})
    //               .onClick(()=>{
    //                 this.numClick(day)
    //               })
    //
    //           }
    //
    //         }
    //       }
    //     }, day => day)
    //   }
    //   .columnsTemplate('1fr 1fr 1fr')
    //   .rowsTemplate('1fr 1fr 1fr 1fr 1fr')
    //   .columnsGap(1)
    //   .rowsGap(1)
    //   .width('75%')
    //   .backgroundColor(0x242530)
    //   .height('100%')
    //
    //   Grid(){
    //     ForEach(this.Number2, (day: string,index:number) => {
    //       GridItem() {
    //         if (index == 0) {
    //           Flex({direction:FlexDirection.Row,alignItems:ItemAlign.Center,justifyContent:FlexAlign.Center}){
    //             Image("/images/del.png")
    //               .objectFit(ImageFit.Cover)
    //               .width(50)
    //               .height(28)
    //               .backgroundColor(0x363746)
    //               .fillColor(Color.Red)
    //           }
    //           .backgroundColor(0x363746)
    //           .width('100%')
    //           .height('100%')
    //           .borderRadius({topRight:30})
    //           .onClick(()=>{
    //             this.deleClick()
    //           })
    //
    //         }else if(index == 3){
    //           ClItem({content:day,font_size:60,font_color:0xFFFFFF,background_color:0xFFBB00,border_radiu:{}})
    //             .onClick(()=>{
    //               this.equalClick()
    //             })
    //         }
    //         else {
    //           ClItem({content:day,font_size:60,font_color:0xFFBB00,background_color:0x363746,border_radiu:{}})
    //             .onClick(()=>{
    //               this.calClick(day)
    //             })
    //         }
    //       }
    //     })
    //   }
    //   .columnsTemplate('1fr')
    //   .rowsTemplate('1fr 1fr 1fr 2fr')
    //   .columnsGap(1)
    //   .rowsGap(1)
    //   .width('25%')
    //   .backgroundColor(0x242530)
    //   .height('100%')
    //   .padding({left:1})
    // }
    // .width('100%')
    // .height('57%')
  }
}