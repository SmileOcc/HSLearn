import { YWAppUtils } from "@learn/common_har";
import { promptAction } from "@kit.ArkUI";

@Builder
export function customDialogBuilder(content: string | Resource) {
  Column() {
    LoadingProgress()
      .width("80vp")
      .height("80vp")
    Text(content)
      .fontSize("16vp")
  }
  .backgroundColor(Color.Transparent)
  .justifyContent(FlexAlign.Center)
}

/**
 * 加载loading
 * @param msg
 * @returns number
 */
export function loading(msg: string | Resource): Promise<number> {
  const that = YWAppUtils.getUIContext() as UIContext;
  let result = promptAction.openCustomDialog({
    backgroundColor: Color.Transparent,
    maskColor: $r('app.color.col_00000'),
    autoCancel: false,
    builder: customDialogBuilder.bind(that, msg),
  });
  return result;
}

/**
 * 消除loading
 * @param loadingId
 */
export function clearLoading(loadingId: number) {
  promptAction.closeCustomDialog(loadingId);
}