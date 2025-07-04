import { ComponentContent, PromptAction, promptAction } from "@kit.ArkUI";
import { dateSlideSelectorBuilder } from "./builder/CustomDialogBuilder";
import { DialogBuilder } from "./builder/DialogBuilder";
import { DateSlideSelector } from "./component/DateSlideSelector";
import { DateSlideSelectorParam } from "./dto/DateSlideSelectorParam";
import { DialogParam } from "./dto/DialogParam";
import { LvDialogBuilderParam } from "./dto/LvDialogBuilderParam";
import { DialogTypeEnum } from "./enum/DialogTypeEnum";
import { YWDialogOptionsFactory } from "./util/YWDialogOptionsFactory";

const DIALOG_TITLE: string = '温馨提示'; //标题
const DIALOG_CONFIRM: string = '确定'; //确定文字
const DIALOG_CANCEL: string = '取消'; //取消文字
const DIALOG_BUTTON_COLOR: string = '#666666' //按钮颜色

/**
 * 弹窗工具类（AlertDialog）
 */


export class YWDialogUtils {
  private static uiContext?: UIContext;
  private static compContMap: Map<string, ComponentContent<object>> = new Map();

  public static init(uiContext: UIContext) {
    YWDialogUtils.uiContext = uiContext;
  }

  private constructor() {}

  /**
   * 弹出自定义弹窗
   *
   * @param param
   */
  public static showCustomDialog(param: DialogParam): void {
    if (!YWDialogUtils.uiContext) {
      return;
    }
    let promptAction = YWDialogUtils.uiContext.getPromptAction();
    let lvParam: LvDialogBuilderParam = YWDialogUtils.transformDialogParamToLvDialogBuilderParam(param)
    let compCont = new ComponentContent(YWDialogUtils.uiContext, wrapBuilder(DialogBuilder), lvParam);
    // 设置了弹窗id即可将其与弹窗关联起来，后续可凭据弹窗id关闭弹窗
    if (param.dialogId) {
      YWDialogUtils.compContMap.set(param.dialogId, compCont);
    }
    YWDialogUtils.fillCancelMethod(lvParam, promptAction, compCont, param.dialogId);
    YWDialogUtils.fillConfirmMethod(lvParam, promptAction, compCont, param.dialogId);
    compCont.update(lvParam);
    let options: promptAction.BaseDialogOptions = YWDialogUtils.dealSlideToClose(param);
    promptAction.openCustomDialog(compCont, options);
  }

  /**
   * 根据弹窗id关闭弹窗
   * @param dialogId
   */
  public static closeCustomDialogById(dialogId: string) {
    if (!YWDialogUtils.uiContext) {
      return;
    }
    let promptAction = YWDialogUtils.uiContext.getPromptAction();
    let compCont = YWDialogUtils.compContMap.get(dialogId);
    if (compCont) {
      YWDialogUtils.compContMap.delete(dialogId);
      promptAction.closeCustomDialog(compCont);
      // 关闭弹框之后释放对应的ComponentContent
      compCont.dispose();
    }
  }

  private static dealSlideToClose(param: DialogParam) {
    param.isSlideToClose = param.isSlideToClose ?? true;
    let options: promptAction.BaseDialogOptions = YWDialogOptionsFactory.getOptionsByDialogType(param.dialogType);
    options.onWillDismiss = (action: DismissDialogAction) => {
      if (action.reason == DismissReason.PRESS_BACK) {
        if (param.slideCallback) {
          param.slideCallback();
        }
        if (param.isSlideToClose) {
          action.dismiss();
        }
      }
    };
    return options;
  }

  private static transformDialogParamToLvDialogBuilderParam(param: DialogParam): LvDialogBuilderParam {
    return {
      dialogType: param.dialogType,
      builder: param.builder,
      closeDialog: param.dialogBuilderParam?.closeDialog,
      onConfirm: param.dialogBuilderParam?.onConfirm,
      data: param.dialogBuilderParam?.data,
      isModalClosedByOverlayClick: param.isModalClosedByOverlayClick ?? true
    };
  }

  private static fillConfirmMethod(param: LvDialogBuilderParam, promptAction: PromptAction,
    compCont: ComponentContent<DialogParam>, dialogId: string | undefined) {
    let confirm = param.onConfirm;
    let confirmDialog = (isCloseDialog?: boolean, data?: ESObject) => {
      if (confirm) {
        confirm(isCloseDialog, data);
      }
      if (isCloseDialog) {
        if (dialogId) {
          YWDialogUtils.compContMap.delete(dialogId);
        }
        promptAction.closeCustomDialog(compCont);
        compCont.dispose();
      }
    };
    param.onConfirm = confirmDialog;
  }

  private static fillCancelMethod(param: LvDialogBuilderParam, promptAction: PromptAction,
    compCont: ComponentContent<DialogParam>, dialogId: string | undefined) {
    let customCancel = param.closeDialog;
    let cancelDialog = () => {
      if (customCancel) {
        customCancel();
      }
      if (dialogId) {
        YWDialogUtils.compContMap.delete(dialogId);
      }
      promptAction.closeCustomDialog(compCont);
      // 关闭弹框之后释放对应的ComponentContent
      compCont.dispose();
    };
    param.closeDialog = cancelDialog;
  }

  /**
   * 时间滑动选择弹窗
   *
   * @param getSelectTime 获取选择时间的回调函数
   * @param param         定义时间滑动选择弹窗的当前选择时间以及最大时间最小时间，非必填，不填则默认
   */
  public static showDateSlideSelector(getSelectTime: (selectTime: number) => void,
    param?: DateSlideSelectorParam): void {
    YWDialogUtils.showCustomDialog({
      builder: wrapBuilder(dateSlideSelectorBuilder),
      dialogType: DialogTypeEnum.BOTTOM,
      dialogBuilderParam: {
        onConfirm: (isCloseDialog?: boolean, data?: ESObject) => {
          getSelectTime(data);
        },
        data: param
      }
    });
  }


  /**
   * 显示弹框（一个按钮的）
   * @param options
   */
  static showConfirmDialog(options: ConfirmDialogOptions) {
    if (options.message == undefined) {
      options.title = '';
    }
    if (options.autoCancel == undefined) {
      options.autoCancel = false;
    }
    if (!options.gridCount) {
      options.gridCount = 4
    }
    if (!options.backgroundColor) {
      options.backgroundColor = Color.Transparent
    }
    if (!options.backgroundBlurStyle) {
      options.backgroundBlurStyle = BlurStyle.COMPONENT_ULTRA_THICK
    }
    if (!options.maskRect) {
      options.maskRect = { x: 0, y: 0, width: '100%', height: '100%' };
    }
    if (!options.alignment) {
      options.alignment = DialogAlignment.Bottom;
    }
    if (!options.offset) {
      if (options.alignment == DialogAlignment.Bottom || options.alignment == DialogAlignment.BottomStart || options.alignment == DialogAlignment.BottomEnd) {
        options.offset = { dx: 0, dy: -20 };
      } else if (options.alignment == DialogAlignment.Top || options.alignment == DialogAlignment.TopStart || options.alignment == DialogAlignment.TopEnd) {
        options.offset = { dx: 0, dy: 20 };
      } else {
        options.offset = { dx: 0, dy: 0 };
      }
    }
    if (options.showInSubWindow == undefined) {
      options.showInSubWindow = false;
    }
    if (options.isModal == undefined) {
      options.isModal = true;
    }
    if (!options.confirm) {
      options.confirm = new ButtonOptions()
    }
    AlertDialog.show({
      title: options.title,
      subtitle: options.subtitle,
      message: options.message,
      autoCancel: options.autoCancel,
      alignment: options.alignment,
      offset: options.offset,
      gridCount: options.gridCount,
      maskRect: options.maskRect,
      showInSubWindow: options.showInSubWindow,
      isModal: options.isModal,
      backgroundColor: options.backgroundColor,
      backgroundBlurStyle: options.backgroundBlurStyle,
      confirm: options.confirm,
      cancel: () => {
        if (options.cancel) {
          options.cancel()
        }
      }
    })
  }


  /**
   * 两个按钮的AlertDialog（AlertDialogParamWithButtons）
   * @param options
   */
  static showPrimaryDialog(options: PrimaryDialogOptions) {
    if (options.message == undefined) {
      options.title = '';
    }
    if (options.autoCancel == undefined) {
      options.autoCancel = false;
    }
    if (!options.gridCount) {
      options.gridCount = 4
    }
    if (!options.backgroundColor) {
      options.backgroundColor = Color.Transparent
    }
    if (!options.backgroundBlurStyle) {
      options.backgroundBlurStyle = BlurStyle.COMPONENT_ULTRA_THICK
    }
    if (!options.maskRect) {
      options.maskRect = { x: 0, y: 0, width: '100%', height: '100%' };
    }
    if (!options.alignment) {
      options.alignment = DialogAlignment.Bottom;
    }
    if (!options.offset) {
      if (options.alignment == DialogAlignment.Bottom || options.alignment == DialogAlignment.BottomStart || options.alignment == DialogAlignment.BottomEnd) {
        options.offset = { dx: 0, dy: -20 };
      } else if (options.alignment == DialogAlignment.Top || options.alignment == DialogAlignment.TopStart || options.alignment == DialogAlignment.TopEnd) {
        options.offset = { dx: 0, dy: 20 };
      } else {
        options.offset = { dx: 0, dy: 0 };
      }
    }
    if (options.showInSubWindow == undefined) {
      options.showInSubWindow = false;
    }
    if (options.isModal == undefined) {
      options.isModal = true;
    }
    if (!options.primaryButton) {
      options.primaryButton = new ButtonOptions()
    }
    if(!options.secondaryButton){
      options.secondaryButton = new ButtonOptions()
    }
    AlertDialog.show({
      title: options.title,
      subtitle: options.subtitle,
      message: options.message,
      autoCancel: options.autoCancel,
      alignment: options.alignment,
      offset: options.offset,
      gridCount: options.gridCount,
      maskRect: options.maskRect,
      showInSubWindow: options.showInSubWindow,
      isModal: options.isModal,
      backgroundColor: options.backgroundColor,
      backgroundBlurStyle: options.backgroundBlurStyle,
      primaryButton:options.primaryButton,
      secondaryButton:options.secondaryButton,
      cancel: () => {
        if (options.cancel) {
          options.cancel()
        }
      }
    })
  }

  /**
   * 多个按钮的AlertDialog（AlertDialogParamWithOptions）
   * @param options
   */
  static showDialog(options: OptionDialogOptions) {
    if (options.message == undefined) {
      options.title = '';
    }
    if (options.autoCancel == undefined) {
      options.autoCancel = false;
    }
    if (!options.gridCount) {
      options.gridCount = 4
    }
    if (!options.backgroundColor) {
      options.backgroundColor = Color.Transparent
    }
    if (!options.backgroundBlurStyle) {
      options.backgroundBlurStyle = BlurStyle.COMPONENT_ULTRA_THICK
    }
    if (!options.maskRect) {
      options.maskRect = { x: 0, y: 0, width: '100%', height: '100%' };
    }
    if (!options.alignment) {
      options.alignment = DialogAlignment.Bottom;
    }
    if (!options.offset) {
      if (options.alignment == DialogAlignment.Bottom || options.alignment == DialogAlignment.BottomStart || options.alignment == DialogAlignment.BottomEnd) {
        options.offset = { dx: 0, dy: -20 };
      } else if (options.alignment == DialogAlignment.Top || options.alignment == DialogAlignment.TopStart || options.alignment == DialogAlignment.TopEnd) {
        options.offset = { dx: 0, dy: 20 };
      } else {
        options.offset = { dx: 0, dy: 0 };
      }
    }
    if (options.showInSubWindow == undefined) {
      options.showInSubWindow = false;
    }
    if (options.isModal == undefined) {
      options.isModal = true;
    }
    if (options.buttonDirection == undefined) {
      options.buttonDirection = DialogButtonDirection.AUTO
    }
    let btns = new Array<AlertDialogButtonOptions>()
    if (options.buttons && options.buttons.length > 0) {
      options.buttons.forEach(item => {
        btns.push({
          enabled: item.enabled,
          defaultFocus: item.defaultFocus,
          style: item.style,
          value: item.value,
          fontColor: item.fontColor,
          backgroundColor: item.backgroundColor,
          action: item.action
        })
      })
    }
    AlertDialog.show({
      title: options.title,
      subtitle: options.subtitle,
      message: options.message,
      autoCancel: options.autoCancel,
      alignment: options.alignment,
      offset: options.offset,
      gridCount: options.gridCount,
      maskRect: options.maskRect,
      showInSubWindow: options.showInSubWindow,
      isModal: options.isModal,
      backgroundColor: options.backgroundColor,
      backgroundBlurStyle: options.backgroundBlurStyle,
      buttons: btns,
      cancel: () => {
        if (options.cancel) {
          options.cancel()
        }
      }
    })
  }

  /**
   * 多个按钮的AlertDialog（AlertDialogParamWithOptions）
   * @param options
   */
  static showDialogEasy(options: EasyDialogOptions) {
    if (options.message == undefined) {
      options.title = '';
    }
    if (options.autoCancel == undefined) {
      options.autoCancel = false;
    }
    if (!options.gridCount) {
      options.gridCount = 4
    }
    if (!options.backgroundColor) {
      options.backgroundColor = Color.Transparent
    }
    if (!options.backgroundBlurStyle) {
      options.backgroundBlurStyle = BlurStyle.COMPONENT_ULTRA_THICK
    }
    if (!options.maskRect) {
      options.maskRect = { x: 0, y: 0, width: '100%', height: '100%' };
    }
    if (!options.alignment) {
      options.alignment = DialogAlignment.Bottom;
    }
    if (!options.offset) {
      if (options.alignment == DialogAlignment.Bottom || options.alignment == DialogAlignment.BottomStart || options.alignment == DialogAlignment.BottomEnd) {
        options.offset = { dx: 0, dy: -20 };
      } else if (options.alignment == DialogAlignment.Top || options.alignment == DialogAlignment.TopStart || options.alignment == DialogAlignment.TopEnd) {
        options.offset = { dx: 0, dy: 20 };
      } else {
        options.offset = { dx: 0, dy: 0 };
      }
    }
    if (options.showInSubWindow == undefined) {
      options.showInSubWindow = false;
    }
    if (options.isModal == undefined) {
      options.isModal = true;
    }
    if (options.buttonDirection == undefined) {
      options.buttonDirection = DialogButtonDirection.AUTO
    }
    let btns = new Array<AlertDialogButtonOptions>()
    if (options.buttons && options.buttons.length > 0) {
      options.buttons.forEach((item, index) => {
        btns.push({
          value: item,
          action: () => {
            if (options.callBack) {
              options.callBack(index)
            }
          }
        })
      })
    }
    AlertDialog.show({
      title: options.title,
      subtitle: options.subtitle,
      message: options.message,
      autoCancel: options.autoCancel,
      alignment: options.alignment,
      offset: options.offset,
      gridCount: options.gridCount,
      maskRect: options.maskRect,
      showInSubWindow: options.showInSubWindow,
      isModal: options.isModal,
      backgroundColor: options.backgroundColor,
      backgroundBlurStyle: options.backgroundBlurStyle,
      buttons: btns,
      cancel: () => {
        if (options.cancel) {
          options.cancel()
        }
      }
    })
  }


  /**
   * 列表选择弹窗 (ActionSheet)
   * @param options
   */
  static showActionSheet(options: ActionSheetOptions) {
    if (options.message == undefined) {
      options.title = '';
    }
    if (options.autoCancel == undefined) {
      options.autoCancel = false;
    }
    if (!options.backgroundColor) {
      options.backgroundColor = Color.Transparent
    }
    if (!options.backgroundBlurStyle) {
      options.backgroundBlurStyle = BlurStyle.COMPONENT_ULTRA_THICK
    }
    if (!options.maskRect) {
      options.maskRect = { x: 0, y: 0, width: '100%', height: '100%' };
    }
    if (!options.alignment) {
      options.alignment = DialogAlignment.Bottom;
    }
    if (!options.offset) {
      if (options.alignment == DialogAlignment.Bottom || options.alignment == DialogAlignment.BottomStart || options.alignment == DialogAlignment.BottomEnd) {
        options.offset = { dx: 0, dy: -20 };
      } else if (options.alignment == DialogAlignment.Top || options.alignment == DialogAlignment.TopStart || options.alignment == DialogAlignment.TopEnd) {
        options.offset = { dx: 0, dy: 20 };
      } else {
        options.offset = { dx: 0, dy: 0 };
      }
    }
    if (options.showInSubWindow == undefined) {
      options.showInSubWindow = false;
    }
    if (options.isModal == undefined) {
      options.isModal = true;
    }
    let sheets = new Array<SheetInfo>()
    if (options.sheets && options.sheets.length > 0) {
      options.sheets.forEach(item => {
        sheets.push(item)
      })
    }
    ActionSheet.show({
      title: options.title,
      subtitle: options.subtitle,
      message: options.message,
      autoCancel: options.autoCancel,
      alignment: options.alignment,
      offset: options.offset,
      maskRect: options.maskRect,
      showInSubWindow: options.showInSubWindow,
      isModal: options.isModal,
      backgroundColor: options.backgroundColor,
      backgroundBlurStyle: options.backgroundBlurStyle,
      sheets: sheets,
      confirm: options.confirm,
      cancel: () => {
        if (options.cancel) {
          options.cancel()
        }
      }
    })
  }


  /**
   * 简单易用的列表选择弹窗 (ActionSheet)
   * @param options
   */
  static showActionSheetEasy(options: EasySheetOptions) {
    if (options.message == undefined) {
      options.title = '';
    }
    if (options.autoCancel == undefined) {
      options.autoCancel = false;
    }
    if (!options.backgroundColor) {
      options.backgroundColor = Color.Transparent
    }
    if (!options.backgroundBlurStyle) {
      options.backgroundBlurStyle = BlurStyle.COMPONENT_ULTRA_THICK
    }
    if (!options.maskRect) {
      options.maskRect = { x: 0, y: 0, width: '100%', height: '100%' };
    }
    if (!options.alignment) {
      options.alignment = DialogAlignment.Bottom;
    }
    if (!options.offset) {
      if (options.alignment == DialogAlignment.Bottom || options.alignment == DialogAlignment.BottomStart || options.alignment == DialogAlignment.BottomEnd) {
        options.offset = { dx: 0, dy: -20 };
      } else if (options.alignment == DialogAlignment.Top || options.alignment == DialogAlignment.TopStart || options.alignment == DialogAlignment.TopEnd) {
        options.offset = { dx: 0, dy: 20 };
      } else {
        options.offset = { dx: 0, dy: 0 };
      }
    }
    if (options.showInSubWindow == undefined) {
      options.showInSubWindow = false;
    }
    if (options.isModal == undefined) {
      options.isModal = true;
    }
    let sheets = new Array<SheetInfo>()
    if (options.sheets && options.sheets.length > 0) {
      if (options.select) {
        let select = options.select
        options.sheets.forEach((item, index) => {
          sheets.push({
            title: item,
            icon: index == select.position ? select.selectIcon : select.defaultIcon,
            action: () => {
              if (options.callBack) {
                options.callBack(index)
              }
            }
          })
        })
      }else {
        options.sheets.forEach((item, index) => {
          sheets.push({
            title: item,
            action: () => {
              if (options.callBack) {
                options.callBack(index)
              }
            }
          })
        })
      }
    }
    ActionSheet.show({
      title: options.title,
      subtitle: options.subtitle,
      message: options.message,
      autoCancel: options.autoCancel,
      alignment: options.alignment,
      offset: options.offset,
      maskRect: options.maskRect,
      showInSubWindow: options.showInSubWindow,
      isModal: options.isModal,
      backgroundColor: options.backgroundColor,
      backgroundBlurStyle: options.backgroundBlurStyle,
      sheets: sheets,
      confirm: options.confirm,
      cancel: () => {
        if (options.cancel) {
          options.cancel()
        }
      }
    })
  }


  /**
   * 日历选择器弹窗
   * @param options
   *   selected 设置选中项的日期。
   *   options 描述日期选中态底板样式。 默认值：底板样式为圆形。
   *   hintRadius 为0，底板样式为直角矩形。hintRadius为0 ~ 16，底板样式为圆角矩形。hintRadius>=16，底板样式为圆形
   *   onChange:(value: Date) => void 选择弹窗中日期使当前选中项改变时触发该回调。value：选中的日期值。
   *   onAccept:(value: Date) => void 点击弹窗中的“确定”按钮时触发该回调。value：选中的日期值。
   *   onCancel:() => void 点击弹窗中的“取消”按钮时触发该回调。
   */
  static showCalendarPicker(options: CalendarDialogOptions) {
    CalendarPickerDialog.show(options)
  }


  /**
   * 日期滑动选择器弹窗 (DatePickerDialog)
   *  start 指定选择器的起始日期。 默认值：Date(‘1970-1-1’)
   *  end 指定选择器的结束日期。 默认值：Date(‘2100-12-31’)
   *  selected 设置选中项的日期。默认值：当前系统日期。从API version 10开始，该参数支持$$双向绑定变量
   *  lunar 日期是否显示为农历，true表示显示农历，false表示不显示农历。默认值：false
   *  showTime 是否展示时间项，true表示显示时间，false表示不显示时间。默认值：false
   *  useMilitaryTime 展示时间是否为24小时制，true表示显示24小时制，false表示显示12小时制。默认值：false。说明：当展示时间为12小时制时，上下午与小时无联动关系。
   *  lunarSwitch 是否展示切换农历的开关，true表示展示开关，false表示不展示开关。默认值：false
   *  onDateChange:(value: Date) => void	滑动弹窗中的滑动选择器使当前选中项改变时触发该回调。
   *  onDateAccept:(value: Date) => void	点击弹窗中的“确定”按钮时触发该回调。
   *  onCancel:() => void	点击弹窗中的“取消”按钮时触发该回调。
   */
  static showDatePicker(options: DatePickerOptions) {
    DatePickerDialog.show({
      start: options.start,
      end: options.end,
      selected: options.selected,
      lunar: options.lunar,
      lunarSwitch: options.lunarSwitch,
      showTime: options.showTime,
      useMilitaryTime: options.useMilitaryTime,
      disappearTextStyle: options.disappearTextStyle,
      textStyle: options.textStyle,
      selectedTextStyle: options.selectedTextStyle,
      onCancel: options.onCancel,
      alignment: options.alignment,
      offset: options.offset,
      maskRect: options.maskRect,
      backgroundColor: options.backgroundColor,
      backgroundBlurStyle: options.backgroundBlurStyle,
      onDateAccept: options.onDateAccept,
      onDateChange: options.onDateChange,
      onAccept: (value: DatePickerResult) => { //抹平API差异（从API8开始支持，从API10开始废弃）
        if (options.onDateAccept && value) {
          let date = new Date(value.year + '-' + value.month + '-' + value.day);
          options.onDateAccept(date)
        }
      },
      onChange: (value: DatePickerResult) => { //抹平API差异（从API8开始支持，从API10开始废弃）
        if (options.onDateChange && value) {
          let date = new Date(value.year + '-' + value.month + '-' + value.day);
          options.onDateChange(date)
        }
      }
    });
  }


  /**
   * 时间滑动选择器弹窗 (TimePickerDialog)
   * @param options
   *  selected 设置选中项的时间。 默认值：当前系统时间。从API version 10开始，该参数支持$$双向绑定变量。
   *  format 指定需要显示的TimePicker的格式。 默认值：TimePickerFormat.HOUR_MINUTE（HOUR_MINUTE-按照小时和分显示、HOUR_MINUTE_SECOND-按照小时、分钟和秒显示。）
   *  useMilitaryTime 展示时间是否为24小时制，默认为12小时制。默认值：false。说明：当展示时间为12小时制时，上下午与小时无联动关系。
   *  onChange:(value: Date) => void 选择弹窗中日期使当前选中项改变时触发该回调。value：选中的日期值。
   *  onAccept:(value: Date) => void 点击弹窗中的“确定”按钮时触发该回调。value：选中的日期值。
   *  onCancel:() => void 点击弹窗中的“取消”按钮时触发该回调。
   */
  static showTimePicker(options: TimePickerDialogOptions) {
    TimePickerDialog.show(options);
  }


  /**
   * 文本滑动选择器弹窗 (TextPickerDialog)
   * @param options
   *  range 选择器的数据选择列表。不可设置为空数组，若设置为空数组，则不显示；若动态变化为空数组，则保持当前正常值显示。
   *        说明：单列数据选择器使用string[]，Resource，TextPickerRangeContent[]类型。
   *             多列数据选择器使用string[][]类型。多列联动数据选择器使用TextCascadePickerRangeContent[]类型。Resource类型只支持strarray.json。
   *  selected 设置默认选中项在数组中的索引值。默认值：0
   *           说明：单列数据选择器使用number类型。
   *                多列、多列联动数据选择器使用number[]类型。从API version 10开始，该参数支持$$双向绑定变量。
   *  value 设置默认选中项的值，优先级低于selected。默认值：第一个元素值
   *        说明：只有显示文本列表时该值有效。显示图片或图片加文本的列表时，该值无效。
   *             单列数据选择器使用string类型。多列、多列联动数据选择器使用string[]类型。从API version 10开始，该参数支持$$双向绑定变量。
   *  canLoop 设置是否可循环滚动，true：可循环，false：不可循环，默认值：true。
   *  onChange:(value: Date) => void 选择弹窗中日期使当前选中项改变时触发该回调。value：选中的日期值。
   *  onAccept:(value: Date) => void 点击弹窗中的“确定”按钮时触发该回调。value：选中的日期值。
   *  onCancel:() => void 点击弹窗中的“取消”按钮时触发该回调。
   */
  static showTextPicker(options: TextPickerDialogOptions) {
    TextPickerDialog.show(options);
  }

}


/**
 * AlertDialog基本参数类
 */
class AlertDialogParam {
  title?: ResourceStr; //弹框标题
  subtitle?: ResourceStr; //弹框副标题
  message: ResourceStr = ''; //弹框内容
  autoCancel?: boolean; //点击遮障层时，是否关闭弹窗，true表示关闭弹窗。false表示不关闭弹窗。默认值：true
  cancel?: () => void; //点击遮障层关闭dialog时的回调。
  alignment?: DialogAlignment; //弹窗的对齐方式。
  offset?: Offset; //弹窗相对alignment所在位置的偏移量。默认值：{ dx: 0 , dy: 0 }
  maskRect?: Rectangle; //弹窗遮蔽层区域，在遮蔽层区域内的事件不透传，在遮蔽层区域外的事件透传。
  showInSubWindow?: boolean; //某弹框需要显示在主窗口之外时，是否在子窗口显示此弹窗。
  isModal?: boolean; //弹窗是否为模态窗口，模态窗口有蒙层，非模态窗口无蒙层。默认值：true，此时弹窗有蒙层。
  backgroundColor?: ResourceColor; //弹窗背板颜色。默认值：Color.Transparent
  backgroundBlurStyle?: BlurStyle; //弹窗背板模糊材质。默认值：BlurStyle.COMPONENT_ULTRA_THICK
}


/**
 * AlertDialog按钮参数类
 */
class ButtonOptions {
  value: ResourceStr = ''; //Button的文本内容，若值为null，则该按钮不显示。
  action: () => void = () => {}; //Button选中时的回调。
  enabled?: boolean; //点击Button是否响应，默认值true。
  defaultFocus?: boolean; //设置Button是否是默认焦点，默认值false。
  style?: DialogButtonStyle; //设置Button的风格样式，默认值DialogButtonStyle.DEFAULT。
  fontColor?: ResourceColor; //Button的文本内容，若值为null，则该按钮不显示。
  backgroundColor?: ResourceColor; //Button背景颜色。
}


/**
 * 确认AlertDialog参数类
 */
class ConfirmDialogOptions extends AlertDialogParam {
  gridCount?: number; //弹窗容器宽度所占用栅格数。默认值：4
  confirm: ButtonOptions = new ButtonOptions();
}

/**
 * 两个按钮的AlertDialog参数类
 */
class PrimaryDialogOptions extends AlertDialogParam {
  gridCount?: number; //弹窗容器宽度所占用栅格数。默认值：4
  primaryButton: ButtonOptions = new ButtonOptions();
  secondaryButton: ButtonOptions = new ButtonOptions();
}

/**
 * 多个按钮的AlertDialog参数类
 */
class OptionDialogOptions extends AlertDialogParam {
  gridCount?: number; //弹窗容器宽度所占用栅格数。默认值：4
  buttons: Array<ButtonOptions> = [] //弹窗容器中的多个按钮。
  buttonDirection?: DialogButtonDirection //按钮排布方向默认值为DialogButtonDirection.AUTO，建议3个以上按钮使用Auto模式（两个以上按钮会切换为纵向模式，通常能显示更多按钮），非Auto模式下，3个以上按钮可能会显示不全，超出显示范围的按钮会被截断。
}

/**
 * 多个按钮的AlertDialog参数类
 */
class EasyDialogOptions extends AlertDialogParam {
  gridCount?: number; //弹窗容器宽度所占用栅格数。默认值：4
  buttons: Array<ResourceStr> = [] //弹窗容器中的多个按钮。
  buttonDirection?: DialogButtonDirection //按钮排布方向默认值为DialogButtonDirection.AUTO，建议3个以上按钮使用Auto模式（两个以上按钮会切换为纵向模式，通常能显示更多按钮），非Auto模式下，3个以上按钮可能会显示不全，超出显示范围的按钮会被截断。
  callBack?: (index: number) => void; //回调事件
}


/**
 * ActionSheet,confirm按钮参数类
 */
class SheetConfirm{
  value: ResourceStr = ''; //Button的文本内容，若值为null，则该按钮不显示。
  action: () => void = () => {}; //Button选中时的回调。
  enabled?: boolean; //点击Button是否响应，默认值true。
  defaultFocus?: boolean; //设置Button是否是默认焦点，默认值false。
  style?: DialogButtonStyle; //设置Button的风格样式，默认值DialogButtonStyle.DEFAULT。
}


/**
 * ActionSheet参数类
 */
class ActionSheetOptions extends AlertDialogParam {
  sheets: Array<SheetInfo>=[]; //title-选项的文本内容、icon-选项的图标、action-选项选中的回调。
  confirm?: SheetConfirm;
}


/**
 * 简单易用的ActionSheet的选中参数类
 */
class SelectSheet {
  position: number = 0; //选中位置
  defaultIcon: ResourceStr = ''; //默认显示的图标
  selectIcon: ResourceStr = ''; //选中显示的图标
}


/**
 * 简单易用的ActionSheet参数类
 */
class EasySheetOptions extends AlertDialogParam {
  sheets: Array<ResourceStr> = []; //title-选项的文本内容、icon-选项的图标、action-选项选中的回调。
  select?: SelectSheet;  //选中配置参数
  callBack?: (index: number) => void; //回调事件
  confirm?: SheetConfirm;
}


/**
 *
 */
class DatePickerOptions {
  start?: Date; //指定选择器的起始日期。默认值：Date(‘1970-1-1’)
  end?: Date; //指定选择器的结束日期。默认值：Date(‘2100-12-31’)
  selected?: Date; //设置选中项的日期。 默认值：当前系统日期。从API version 10开始，该参数支持$$双向绑定变量。
  lunar?: boolean; // 日期是否显示为农历，true表示显示农历，false表示不显示农历。 默认值：false
  lunarSwitch?: boolean; //是否展示切换农历的开关，true表示展示开关，false表示不展示开关。默认值：false
  showTime?: boolean; //是否展示时间项，true表示显示时间，false表示不显示时间。默认值：false
  useMilitaryTime?: boolean; //展示时间是否为24小时制，true表示显示24小时制，false表示显示12小时制。默认值：false。说明：当展示时间为12小时制时，上下午与小时无联动关系。
  disappearTextStyle?: PickerTextStyle; //设置所有选项中最上和最下两个选项的文本颜色、字号、字体粗细。
  textStyle?: PickerTextStyle; //设置所有选项中除了最上、最下及选中项以外的文本颜色、字号、字体粗细。
  selectedTextStyle?: PickerTextStyle; //设置选中项的文本颜色、字号、字体粗细。
  onDateAccept?: (value: Date) => void; //点击弹窗中的“确定”按钮时触发该回调
  onDateChange?: (value: Date) => void; //点击弹窗中的“确定”按钮时触发该回调
  onCancel?: () => void; //点击弹窗中的“取消”按钮时触发该回调。
  alignment?: DialogAlignment; //弹窗的对齐方式。
  offset?: Offset; //弹窗相对alignment所在位置的偏移量。默认值：{ dx: 0 , dy: 0 }
  maskRect?: Rectangle; //弹窗遮蔽层区域，在遮蔽层区域内的事件不透传，在遮蔽层区域外的事件透传。
  backgroundColor?: ResourceColor; //弹窗背板颜色。默认值：Color.Transparent
  backgroundBlurStyle?: BlurStyle; //弹窗背板模糊材质。默认值：BlurStyle.COMPONENT_ULTRA_THICK
}