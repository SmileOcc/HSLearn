@Component
export struct BuilderParamBlackView {

  header:string = 'aa'

  @BuilderParam closer:()=>void
  build() {
    Column(){
      Text(this.header)
        .fontSize(30)
      this.closer
    }
  }

  @Builder specificParam(str:string){
    Column(){

    }
  }
}

@Entry
@Component
struct TestBuilderParamPage {
  @State message: string = 'Hello BuilderParam';

  @Builder componentBuilder() {
    Text(`Parent builder `)
  }

  @Builder specificParam():void{
    Column(){

    }
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        BuilderChild({ customBuilderParam: this.componentBuilder })


        //closer 有问题
        // BuilderParamBlackView({header:this.message,closer: ()=>{
        //   Text('YYY')
        //
        // }})
          // .padding(12)
          // .backgroundColor(Color.Red)
      }
      .width('100%')
    }
    .height('100%')
  }
}



@Component
struct BuilderChild {
  @Builder customBuilder() {}
  // 使⽤⽗组件@Builder装饰的⽅法初始化⼦组件@BuilderParam
  @BuilderParam customBuilderParam: () => void = this.customBuilder;
  build() {
    Column() {
      this.customBuilderParam()
    }
  }
}