// PromptActionClass.ets
import { BusinessError } from '@kit.BasicServicesKit';
import { ComponentContent, promptAction } from '@kit.ArkUI';
import { PromptAction, UIContext } from '@ohos.arkui.UIContext';

@Builder
export function TestPromptAlertBuilder() {

  NavDestination() {
    PromptAlertTestPage()
  }
}

/**
 * 自定义弹框封装
 */
export class PromptActionClass {
  static ctx: UIContext;
  static contentNode: ComponentContent<Object>;
  static options: promptAction.BaseDialogOptions;


  static setContext(context: UIContext) {
    PromptActionClass.ctx = context;
  }

  static setContentNode(node: ComponentContent<Object>) {
    PromptActionClass.contentNode = node;
  }

  static setOptions(options: promptAction.BaseDialogOptions) {
    PromptActionClass.options = options;
  }

  static openDialog() {
    if (PromptActionClass.contentNode !== null) {
      PromptActionClass.ctx.getPromptAction()
        .openCustomDialog(PromptActionClass.contentNode, PromptActionClass.options)
        .then(() => {
          console.info('OpenCustomDialog complete.')
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`OpenCustomDialog args error code is ${code}, message is ${message}`);
        })
    }
  }

  static closeDialog() {
    if (PromptActionClass.contentNode !== null) {
      PromptActionClass.ctx.getPromptAction()
        .closeCustomDialog(PromptActionClass.contentNode)
        .then(() => {
          console.info('CloseCustomDialog complete.')
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`CloseCustomDialog args error code is ${code}, message is ${message}`);
        })
    }
  }

  static updateDialog(options: promptAction.BaseDialogOptions) {
    if (PromptActionClass.contentNode !== null) {
      PromptActionClass.ctx.getPromptAction()
        .updateCustomDialog(PromptActionClass.contentNode, options)
        .then(() => {
          console.info('UpdateCustomDialog complete.')
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`UpdateCustomDialog args error code is ${code}, message is ${message}`);
        })
    }
  }
}


class Params {
  text: string = ""

  constructor(text: string) {
    this.text = text;
  }
}

/**
 * 自定义弹框布局
 * @param params
 */
@Builder
function buildText(params: Params) {
  Column() {
    Text(params.text)
      .fontSize(50)
      .fontWeight(FontWeight.Bold)
      .margin({ bottom: 36 })
    Button('Close')
      .onClick(() => {
        PromptActionClass.closeDialog()
      })
  }.backgroundColor('#FFF0F0F0')
}

@Entry
@Component
struct PromptAlertTestPage {
  @State message: string = "hello"
  private ctx: UIContext = this.getUIContext();
  private selectedDate: Date = new Date('2024-04-23')
  private contentNode: ComponentContent<Object> =
    new ComponentContent(this.ctx, wrapBuilder(buildText), new Params(this.message));
  @State handlePopup: boolean = false

  aboutToAppear(): void {
    PromptActionClass.setContext(this.ctx);
    PromptActionClass.setContentNode(this.contentNode);
    PromptActionClass.setOptions({ alignment: DialogAlignment.Top, offset: { dx: 0, dy: 50 } });
  }

  build() {
    Row() {
      Column() {
        /**
         * 显示自定义气泡 更新样式
         */
        Button("open dialog and update options")
          .margin({ top: 50 })
          .onClick(() => {
            PromptActionClass.openDialog()

            setTimeout(() => {
              PromptActionClass.updateDialog({
                alignment: DialogAlignment.Bottom,
                offset: { dx: 0, dy: -50 }
              })
            }, 1500)
          })

        /**
         * 显示自定义气泡 更新内容数据
         */
        Button("open dialog and update content")
          .margin({ top: 50 })
          .onClick(() => {
            PromptActionClass.openDialog()

            setTimeout(() => {
              this.contentNode.update(new Params('update'))
            }, 1500)
          })

        /**
         * 气泡菜单
         */
        Button('PopupOptions')
          .onClick(() => {
            this.handlePopup = !this.handlePopup
          })
          .bindPopup(this.handlePopup, {
            message: 'This is a popup with PopupOptions',
          })

        /**
         * 提示气泡
         */
        Button('show Toast')
          .onClick(() => {
            let promptAction: PromptAction = this.ctx.getPromptAction();
            try {
              promptAction.showToast({
                message: 'Message Info',
                duration: 2000
              });
            } catch (error) {
              let message = (error as BusinessError).message;
              let code = (error as BusinessError).code;
              console.error(`showToast args error code is ${code}, message is ${message}`);
            }
            ;
          })

        /**
         * 系统弹框
         */
        Button('show Toast')
          .onClick(() => {
            let promptAction: PromptAction = this.ctx.getPromptAction();
            try {
              promptAction.showToast({
                message: 'Message Info',
                duration: 2000
              });
            } catch (error) {
              let message = (error as BusinessError).message;
              let code = (error as BusinessError).code;
              console.error(`showToast args error code is ${code}, message is ${message}`);
            }
            ;
          })

        Divider().height(2).width('100%')

        Button('showAlertDialog')
          .margin(30)
          .onClick(() => {
            this.getUIContext().showAlertDialog(
              {
                title: 'title',
                message: 'text',
                autoCancel: true,
                alignment: DialogAlignment.Center,
                buttons: [{
                  value: 'cancel',
                  action: () => {
                    console.info('cancel')
                  }
                },
                  {
                    enabled: true,
                    defaultFocus: true,
                    style: DialogButtonStyle.HIGHLIGHT,
                    value: 'ok',
                    action: () => {
                      console.info('ok')
                    }
                  }],
              }
            )
          })

        // 日历选择器弹窗示例 (CalendarPickerDialog)
        Button("Show CalendarPicker Dialog")
          .margin(20)
          .onClick(() => {
            console.info("CalendarDialog.show")
            CalendarPickerDialog.show({
              selected: this.selectedDate,
              acceptButtonStyle: {
                fontColor: '#2787d9',
                fontSize: '16fp',
                backgroundColor: '#f7f7f7',
                borderRadius: 10
              },
              cancelButtonStyle: {
                fontColor: Color.Red,
                fontSize: '16fp',
                backgroundColor: '#f7f7f7',
                borderRadius: 10
              },
              onAccept: (date: Date) => {
                // 当弹出框再次弹出时显示选中的是上一次确定的日期
                this.selectedDate = date
              }
            })
          })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}



