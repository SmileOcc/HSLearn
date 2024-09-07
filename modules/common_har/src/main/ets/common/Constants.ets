import display from '@ohos.display';
import { bundleManager } from '@kit.AbilityKit';
import Logger from './KLogger';
import { GlobalContext } from './GlobalContext';
import KLogger from './KLogger';
import { process } from '@kit.ArkTS';


export let CIRCLE_RADIUS: number = 80

const DESIGN_WIDTH = 360;
const DESIGN_HEIGHT = 780;

export class Constants {

  static readonly kStatusBarHeight = 'statusBarHeight'

  //这里获取有问题,待优化，改成方法,
  static readonly screenHeight = px2vp(display.getDefaultDisplaySync().height);
  static readonly screenWidth = px2vp(display.getDefaultDisplaySync().width);

  static SCREEN_HEIGHT(){
    return px2vp(display.getDefaultDisplaySync().height)
  }
  static SCREEN_WIDTH(){
    return px2vp(display.getDefaultDisplaySync().width);
  }

  /**
   * Larger font weight.
   */
  static readonly FONT_WEIGHT_LARGE: number = 700;
  static readonly FONT_OPACITY: number = 0.6;
  static readonly FONT_SIZE_LARGE: number = 24;
  static readonly FONT_SIZE_MID: number = 18;
  static readonly FONT_SIZE_SMALL: number = 14;
  static readonly COLOR_PAGE_BGC: string = '#F1F3F5';
  static readonly COLOR_BTN_BGC: string = '#0D182431';
  static readonly COLOR_FONT: string = '#182431';
  static readonly COLOR_BLUE: string = '#007DFF';
  static readonly RADIUS: number = 12;
  static readonly MARGIN: number = 12;
  static readonly PADDING: number = 16;
  static readonly HEIGHT_TARGET: number = 50;
  static readonly HEIGHT_SUB_TARGET: number = 30;
  static readonly PIC_SIZE: number = 96;
  static readonly PROGRESS_SIZE: number = 48;

  static readonly MARGIN_UPDATE_TIME: number = 6;
  static readonly HEIGHT_TARGETLIST_COLUMN: string = '55%';
  static readonly WIDTH_TARGETINFO_COLUMN: string = '93%';
  static readonly HEIGHT_LIST: string = '80%';

  /**
   * Percentage representing the content width.
   */
  public static readonly CONTENT_WIDTH: string = '90%';

  /**
   * Percentage representing the full width.
   */
  public static readonly FULL_WIDTH: string = '100%';

  /**
   * Percentage representing half of the width.
   */
  public static readonly HALF_WIDTH: string = '50%';

  /**
   * Percentage representing the full height.
   */
  public static readonly FULL_HEIGHT: string = '100%';

  /**
   * Width of the scroll bar.
   */
  public static readonly SCROLL_BAR_WIDTH: number = 5;

  /**
   * Font weights for different styles.
   */
  public static readonly FONT_WEIGHT: number[] = [400, 500];

  /**
   * Various spacing values for content.
   */
  public static readonly CONTENT_SPACE: string[] = [
    '4vp', '8vp', '12vp', '14.78vp', '15vp', '16vp', '24vp', '26vp', '27vp', '28vp', '34.78vp', '36vp'
  ];

  /**
   * Breakpoints for responsive design.
   */
  public static readonly BREAKPOINTS: string[] = ['sm', 'md', 'lg'];

  /**
   * Column spans for grid layouts.
   */
  public static readonly GRID_COL_SPAN: number[] = [3, 6, 12];

  /**
   * Number of columns in grid rows.
   */
  public static readonly GRID_ROW_COLUMNS: number[] = [4, 6, 8];

  /**
   * Layout weight for elements.
   */
  public static readonly LAYOUT_WEIGHT: number = 1;

  /**
   * Opacity value.
   */
  public static readonly OPACITY: number = 0.6;

  /**
   * Names of various functions.
   */
  public static readonly FUNCTIONS_NAME: string[] = [
    '基金投资', '理财产品', '信用卡', '账单','速盈', '贵金属', '存款产品',  '缴费', '快贷', '更多'
  ];

  /**
   * Names of various functions.
   */
  public static readonly FUNCTIONS_CARD_NAME: string[] = [
    '扫一扫', '收付款', '出行', '卡包'
  ];

  /**
   * Items in a service card related to receiving money.
   */
  public static readonly RECEIVE_MONEY_SERVICE_CARD_ITEM: string[] = [
    '收款记录', '收钱语音提醒', '商家服务', '收钱免费兑换'
  ];

  /**
   * Default city name.
   */
  public static readonly CITY_NAME: string = '城市';

  /**
   * Default city name.
   */
  public static readonly TAB_BAR_TITLES: string[] = ['首页', '理财', '生活', '消息', '我的'];

  /**
   * Breakpoint split screen size.
   */
  public static readonly BREAKPOINTS_WINDOW_SIZE: number[] = [600, 840];

  /**
   * Corner radius.
   */
  public static readonly CORNER_RADIUS: number = 10;

  /**
   * QR code size.
   */
  public static readonly QRCODE_SIZE: number = 400;

  /**
   * Scan Abilities
   */
  public static readonly SCAN_ABILITIES: string[] = ['扫码', '识物', 'AR'];

  /**
   * 400 Font Weight
   */
  public static readonly FONT_WEIGHT_400: number = 400;

  /**
   * 500 Font Weight
   */
  public static readonly FONT_WEIGHT_500: number = 500;

  /**
   * 700 Font Weight
   */
  public static readonly FONT_WEIGHT_700: number = 700;

  /**
   * 0.9 Opacity
   */
  public static readonly PERCENT_90_OPACITY: number = 0.9;

  /**
   * 60 backdropBlur
   */
  public static readonly BACK_DROP_BLUR_60: number = 60;

  /**
   * Bottom Functions
   */
  public static readonly SCAN_DIALOG_FUNCTIONS: string[] = ['收付款', '相册'];

  /**
   * Bottom Functions
   */
  public static readonly EIGHTY_PERCENT: string = '80%';

  /**
   * Init camera width dialog
   */
  public static readonly INIT_CAMERA_WIDTH_DIALOG: number = 746;

  /**
   * Init camera height dialog
   */
  public static readonly INIT_CAMERA_HEIGHT_DIALOG: number = 560;


  /**
   * 21 line height
   */
  public static readonly LINE_HEIGHT_21: number = 21;

  /**
   * list space.
   */
  static readonly LIST_SPACE: number = 12;
  /**
   * Current month plus one.
   */
  static readonly PLUS_ONE: number = 1;

  /**
   * The fraction or number of seconds is less than 10.
   */
  static readonly TEN: number = 10;

  /**
   * One task of data.
   */
  static readonly ONE_TASK: number = 1;
  /**
   * Width of the content area.
   */
  static readonly WIDTH_TARGETLIST_COLUMN: string = '93.3%';

  static readonly COLOR_EEEEEE: string = '#eeeeee';

  /**
   * 字体颜色.
   */
  static readonly COLOR_333333: string = '#333333';
  static readonly COLOR_666666: string = '#666666';
  static readonly COLOR_999999: string = '#999999';

  //黄色按钮
  static readonly COLOR_ffcc33: string = '#ffcc33';

  // #45000000
  static HexColor(col:string){
    return '#'+col
  }
  static HexColorA(col:string, alph:number) {
    if (alph<1){
      return '#' + alph*100 + col
    }
    return '#'+col
  }

  static RandomColor(){
    console.log(`============= ${Math.floor(Math.random()*16777215).toString(16)}`)
    return '#' + Math.floor(Math.random()*16777215).toString(16)

  }


  static readonly kStorageLocalUser: string = 'kStorageLocalUser';
  static readonly kAppStorageStorageLocalUser: string = 'kAppStorageStorageLocalUser';
  static readonly kAppStorageStorageLocalThreeUser: string = 'kAppStorageStorageLocalThreeUser';

  static readonly kPageSize20: number = 20;
  static readonly kPageSize10: number = 10;


  /**
   * Component opacity value: 1.
   */
  static readonly FULL_OPACITY: number = 1;

  /**
   * Component opacity value: 0.6.
   */
  static readonly SIXTY_OPACITY: number = 0.6;

  /**
   * Component opacity value: 0.8.
   */
  static readonly EIGHTY_OPACITY: number = 0.8;

  /**
   * Font weight value: five.
   */
  static readonly FONT_WEIGHT_FIVE: number = 500;

  /**
   * Water flow layout weight value:1.
   */
  static readonly WATER_FLOW_LAYOUT_WEIGHT: number = 1;

  /**
   * Water flow layout columns template.
   */
  static readonly WATER_FLOW_COLUMNS_TEMPLATE: string = '1fr 1fr';

  static readonly CACHED_COUNT: number = 6;

  static readonly EVENT_QUICK_TOP_FUNC: string = 'event_quick_top_func';
  static readonly EVENT_TOP_ICON: string = 'event_top_icon';
  static readonly EVENT_REFRESH_WATERFLOW_DATA: string = 'event_refresh_waterflow_data';
  static readonly TIME_OUT_TWO_THOUSANDS: number = 2000;
  static readonly TIME_OUT_FIVE_HUNDREDS: number = 500;

  static readonly EVENT_HIDE_ITEM_MENU: string = 'event_hide_item_menu';
  static readonly FLOW_HEIGHT: Length = 244;
  static readonly EVENT_REMOVE_ITEM: string = 'event_remove_item';

  static readonly EIGHTY_FONT_WIDTH: string = '80%';

  static readonly ACTION_PICKER_CAMERA: string = "ohos.want.action.imageCapture";
  static readonly KEY_RESULT_PICKER_CAMERA: string = "resourceUri";
  static readonly WATER_FLOW_FRICTION: number = 0.65;
  static readonly DATASOURCE_MIN_COUNT: number = 5;


  static HTTP_TIMEOUT = 2500


  //基准算法实现 以屏幕宽为基准
  static adaptDimension(value: number): number {
    //获取分辨率，具体的获取代码是在下段代码中
    let deviceDisplay: display.Display = GlobalContext.getContext().getObject('display') as display.Display;

    //计算设计稿与设备的宽度缩放比例
    let widthScale = deviceDisplay.width / DESIGN_WIDTH;

    //通过宽度的缩放比例计算出，deviceDisplay.width宽度应该对应的高度
    let virtualHeight = widthScale * DESIGN_HEIGHT;

    //计算设计稿对角线长度
    let designDim = Math.sqrt(DESIGN_WIDTH * DESIGN_WIDTH + DESIGN_HEIGHT * DESIGN_HEIGHT);

    //计算设计稿对应的理想屏幕对角线长度
    let virtualDim = Math.sqrt(deviceDisplay.width * deviceDisplay.width + virtualHeight * virtualHeight);

    // 由于是采用宽高比，以宽为基准的计算方法，所以对于输入值来讲，输出值的计算公式为
    // virtualDim / 理想值 = designDim / value
    // 即：virtualDim*value / designDim

    return virtualDim * value / designDim;
  }


  //环境
  static isProdEnv() {
    return false
  }


  /// =============== 同步方式获取
  public static async getVersionName(): Promise<string> {
    try {
      let bundleInfo =
        await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      return bundleInfo.versionName;
    } catch (error) {
      Logger.debug(JSON.stringify(error))
    }
    return "";
  }

  public static async getVersionCode(): Promise<string> {
    try {
      let bundleInfo =
        await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      return bundleInfo.versionCode.toString();
    } catch (error) {
      Logger.debug(JSON.stringify(error))
    }
    return "";
  }

  public static async getAppVersion() {
    return `v${await Constants.getVersionName()}.${await Constants.getVersionCode()}`
  }

  public static currentTip() {
    let mainTid = process.tid
    KLogger.debug(`==== 当前线程tid: ${mainTid}`)
    return mainTid
  }
}

/**
 * The style of NavPage.
 */
export class NavPageStyle {
  /**
   * The height of Tabs.
   */
  static readonly BAR_HEIGHT: number = 56;

  /**
   * The default position of Tabs.
   */
  static readonly POSITION_INITIAL: number = 0;
}



