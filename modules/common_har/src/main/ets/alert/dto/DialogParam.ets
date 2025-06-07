import { DialogBuilderParam } from '../dto/DialogBuilderParam';
import { DialogTypeEnum } from '../enum/DialogTypeEnum';

export interface DialogParam {
  dialogId?: string; // 弹窗id
  builder: WrappedBuilder<[DialogBuilderParam]>;
  dialogType: DialogTypeEnum;
  dialogBuilderParam?: DialogBuilderParam;
  isModalClosedByOverlayClick?: boolean; // 点击蒙层是否关闭弹窗,默认为true/点击蒙层关闭弹窗
  isSlideToClose?: boolean; // 控制侧滑是否关闭弹窗，默认为true/侧滑关闭弹窗
  slideCallback?: () => void; // 侧滑回调
}