export interface DialogBuilderParam {
  closeDialog?: () => void;
  onConfirm?: (isCloseDialog?: boolean, data?: ESObject) => void;
  data?: ESObject;
}