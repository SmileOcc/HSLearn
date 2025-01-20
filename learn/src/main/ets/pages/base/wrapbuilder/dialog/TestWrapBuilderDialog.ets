import { ComponentContent } from "@kit.ArkUI";
import { hsLog } from "@learn/logger_har/src/main/ets/core/YWLogger";
import { DialogAComponent } from "./DialogAComponent";

export class TTParams {
  text: string = ""
  constructor(text: string) {
    this.text = text;
  }
}

export interface testParams {
  info?:info
  title?:string
}

export interface info {
  text?:string
  desc?:string
}

//方式一
@Builder
function buildText(data: testParams) {
  Column() {
    Text(data.info?.text)
      .fontSize(50)
      .fontWeight(FontWeight.Bold)
      .margin({bottom: 36})
    Text(data.title)
      .fontSize(50)
      .fontWeight(FontWeight.Bold)
      .margin({bottom: 36})

  }.backgroundColor('#FFF0F0F0')
}

//方式二 自定义组件
@Builder function BuilderTextComponent(data:testParams) {
  DialogAComponent({dataInfo:data})
}

@Builder function BuilderTextComponent22(dataa:TTParams) {
  DialogAComponent({data:dataa})
}



@Entry
@Component
struct TestWrapBuilderDialog {
  @State message: string = 'Hello World';

  private componentDialog?:ComponentContent<TTParams>
  private componentBuilder?: WrappedBuilder<TTParams[]>

  build() {
    Row() {
      Column() {
        Button("click me")
          .onClick(() => {

            let testPP:testParams = {title:"12333",info: {text:'abb333',desc:"yyy333"}}
            let kkkk = new TTParams("mmmm0000")

            let uiContext = this.getUIContext();
            let promptAction = uiContext.getPromptAction();

            this.componentBuilder = wrapBuilder(BuilderTextComponent22)
            // this.componentDialog = new ComponentContent(uiContext, this.componentBuilder, testPP);

            this.componentDialog = new ComponentContent(uiContext, this.componentBuilder, kkkk);

            // this.componentDialog = new ComponentContent(uiContext, wrapBuilder(BuilderTextComponent), testPP);
            promptAction.openCustomDialog(this.componentDialog);

            setTimeout(() => {
              let testPP:testParams = {title:"12311",info: {text:'abb11',desc:"yyy11"}}
              let kkkk = new TTParams("mmmm11111")

              // this.componentDialog?.update(testPP);

              this.componentDialog?.update(kkkk);

              // this.componentDialog?.reuse(kkkk);
              // this.componentDialog?.recycle();

              // this.componentBuilder?.builder(testPP)
            }, 2000);    //2秒后自动更新弹窗内容文本
          })

        Button("click me")
          .onClick(() => {

            // let testPP:testParams = {title:"123",info: {text:'abb',desc:"yyy"}}
            // let uiContext = this.getUIContext();
            // let promptAction = uiContext.getPromptAction();
            // let contentNode = new ComponentContent(uiContext, wrapBuilder(buildText), testPP);
            // promptAction.openCustomDialog(contentNode);
            let kkkk = new TTParams("mmmm11111")

            let testPP:testParams = {title:"12311",info: {text:'abb11',desc:"yyy11"}}
            this.componentDialog?.update(kkkk);
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
    .height('100%')
  }
}


// import { ComponentContent } from '@kit.ArkUI';
// import { ReusableChildComponent2 } from './ReusableChildComponent2';
//
// class Params {
//   text: string = ""
//
//   constructor(text: string) {
//     this.text = text;
//   }
// }
//
// @Builder
// function buildText(params: Params) {
//   ReusableChildComponent2({ text: params.text });
// }
//
//
//
// @Entry
// @Component
// struct Index {
//   @State message: string = "hello"
//
//   build() {
//     Row() {
//       Column() {
//         Button("click me")
//           .onClick(() => {
//             let uiContext = this.getUIContext();
//             let promptAction = uiContext.getPromptAction();
//             let contentNode = new ComponentContent(uiContext, wrapBuilder(buildText), new Params(this.message));
//             promptAction.openCustomDialog(contentNode);
//
//             setTimeout(() => {
//               contentNode.reuse(new Params("new message"));
//               contentNode.recycle();
//             }, 2000); //2秒后自动更新弹窗内容文本
//           })
//       }
//       .justifyContent(FlexAlign.Center)
//       .width('100%')
//       .height('100%')
//     }
//     .height('100%')
//   }
// }
