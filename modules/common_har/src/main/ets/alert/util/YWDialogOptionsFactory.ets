import { promptAction } from "@kit.ArkUI";
import { DialogTypeEnum } from "../enum/DialogTypeEnum";

export class YWDialogOptionsFactory {
  /**
   * 工厂方法，拿到option
   * @param dialogType
   * @returns
   */
  public static getOptionsByDialogType(dialogType: DialogTypeEnum): promptAction.BaseDialogOptions {
    let options: promptAction.BaseDialogOptions = {
      maskColor: Color.Transparent,
      autoCancel: false
    };
    switch (dialogType) {
      case DialogTypeEnum.BOTTOM:
        YWDialogOptionsFactory.fillBottomOption(options);
        break;
      case DialogTypeEnum.CENTER:
        YWDialogOptionsFactory.fillCenterOption(options);
        break;
      case DialogTypeEnum.TOP:
        YWDialogOptionsFactory.fillTopOption(options);
        break;
    }
    return options;
  }

  private static fillTopOption(options: promptAction.BaseDialogOptions) {
    options.alignment = DialogAlignment.Top;
    options.transition = TransitionEffect.translate({ x: 0, y: -800 }).animation({ duration: 200 });
  }

  private static fillCenterOption(options: promptAction.BaseDialogOptions) {
    options.alignment = DialogAlignment.Center;
    options.transition = TransitionEffect.OPACITY.animation({ duration: 200 });
  }

  private static fillBottomOption(options: promptAction.BaseDialogOptions) {
    options.alignment = DialogAlignment.Bottom;
    options.transition = TransitionEffect.translate({ x: 0, y: 800 }).animation({ duration: 200 });
  }
}