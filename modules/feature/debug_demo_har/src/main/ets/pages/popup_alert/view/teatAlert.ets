import { ComponentContent } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';


@Builder
function ComponentContentBuildText() {

  Column() {
    Text("测试数据")
      .fontSize(50)
      .fontWeight(FontWeight.Bold)
      .margin({ bottom: 36 })
  }.backgroundColor('#FFF0F0F0')
}


export class TestAlertModel {

  private context: UIContext
  private contentNode: ComponentContent<Object>
  constructor(context: UIContext) {
    this.context = context
    this.contentNode = new ComponentContent(this.context, wrapBuilder(ComponentContentBuildText));

  }
  // OpenCustomDialog - ComponentContent // 建议整体抽个单例

  showAlert() {

    this.context.getPromptAction().openCustomDialog(this.contentNode)
      .then(() => {
        console.info('UpdateCustomDialog complete.')
      })
      .catch((error: BusinessError) => {
        let message = (error as BusinessError).message;
        let code = (error as BusinessError).code;
        console.error(`onClickOpenCustomDialog args error code is ${code}, message is ${message}`);
      })
  }

}

