import { LvDialogBuilderParam } from "../dto/LvDialogBuilderParam";
import { DialogTypeEnum } from "../enum/DialogTypeEnum";

@Builder
export function DialogBuilder(param: LvDialogBuilderParam) {
  Stack({ alignContent: getAlignment(param.dialogType) }) {
    Stack()
      .width('100%')
      .height('200%')
      .backgroundColor(0x33000000)
      .onClick(() => {
        if (param.isModalClosedByOverlayClick) {
          param.closeDialog!();
        }
      })
    param.builder.builder({ onConfirm: param.onConfirm, closeDialog: param.closeDialog, data: param.data })
  }
}

function getAlignment(dialogType: DialogTypeEnum): Alignment {
  switch (dialogType) {
    case DialogTypeEnum.BOTTOM:
      return Alignment.Bottom;
    case DialogTypeEnum.CENTER:
      return Alignment.Center;
    case DialogTypeEnum.TOP:
      return Alignment.Top;
    default:
      return Alignment.Center;
  }
}