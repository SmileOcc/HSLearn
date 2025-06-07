import { DialogTypeEnum } from "../enum/DialogTypeEnum";
import { DialogBuilderParam } from "./DialogBuilderParam";

export interface LvDialogBuilderParam {
  builder: WrappedBuilder<[DialogBuilderParam]>;
  dialogType: DialogTypeEnum;
  closeDialog?: () => void;
  onConfirm?: (isCloseDialog?: boolean, data?: ESObject) => void;
  data?: ESObject;
  isModalClosedByOverlayClick: boolean; // 点击蒙层是否关闭弹窗
}
