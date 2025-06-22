import { resourceManager } from "@kit.LocalizationKit";
import { display } from "@kit.ArkUI";
import { effectKit } from "@kit.ArkGraphics2D";
import { image } from "@kit.ImageKit";


/**
 * 默认属性及常量值
 */
export default class Constants {

  // 判断是否平板展示使用的常量：
  // 依据Navigation的mode属性说明，如使用Auto，窗口宽度>=600vp时，采用Split模式显示；窗口宽度<600vp时，采用Stack模式显示
  static readonly DEVICESIZE: number = 600;
  // CardSwiperComponent大小100%
  static readonly CARD_SWIPER_FULL_SIZE = "100%";
  // 卡片的单位长度，便于设置卡片的比例
  public static readonly CARD_UNIT_LENGTH: number = 120;
  // 卡片列表测试用例，若未传入数据则按照CARD_TEST_CASE展示（与示例传入数据顺序相逆）
  public static readonly CARD_TEST_CASE: CardInfo[] = [
  // 卡片比例 2 x 1
    { src: $r('app.media.bear'), width: 2 * this.CARD_UNIT_LENGTH, height: this.CARD_UNIT_LENGTH },
    // 卡片比例 2 x 2
    { src: $r('app.media.parrot'), width: 2 * this.CARD_UNIT_LENGTH, height: 2 * this.CARD_UNIT_LENGTH },
    // 卡片比例 1 x 2
    { src: $r('app.media.kangaroo'), width: this.CARD_UNIT_LENGTH, height: 2 * this.CARD_UNIT_LENGTH },
    // 卡片比例 1 x 1
    { src: $r('app.media.panda'), width: this.CARD_UNIT_LENGTH, height: this.CARD_UNIT_LENGTH },
  ];
  // 卡片懒加载的预加载数量
  public static readonly SWIPER_CACHE_COUNT: number = 4;
  // Swiper 的偏移量
  public static readonly SWIPER_MARGIN: number = 25;
  // 图片动画透明度值
  public static readonly OPACITY: number = 0.99;
  // 图片动画时长
  public static readonly DURATION: number = 280;
  // 所有动画默认曲线，Friction(阻尼曲线)
  public static readonly DEFAULT_ANIMATION_CURVE = Curve.Friction;

  // 边缘渐变配置
  // 边缘渐变起始和终止颜色
  public static readonly BEGIN_COLOR: string = '#00ffffff';
  public static readonly END_COLOR: string = '#ffffffff';
  // 渐变颜色位置
  public static readonly OVERLAY_LINEAR_GRADIENT_COLOR_POS: number[] = [0.0, 0.03, 0.97, 1.0];
  // 渐变角度
  public static readonly OVERLAY_LINEAR_GRADIENT_ANGLE: number = 90;
  // 渐变遮盖层高度，设置为卡片列表中最高卡片的高度
  public static readonly FADING_OVERLAY_LENGTH: number = 2 * this.CARD_UNIT_LENGTH;
  // 边缘渐变动画时长
  public static readonly OVERLAY_DURATION: number = 220;
  // 边缘渐变动画曲线
  public static readonly OVERLAY_ANIMATION_CURVE = Curve.Friction;

  // 背景渐变配置
  // 背景线性渐变起始角度, 180即为从上至下渐变
  public static readonly LINEAR_GRADIENT_ANGLE = 180;
  // 背景渐变颜色位置
  public static readonly BACKGROUND_LINEAR_GRADIENT_COLOR_POS: number[] = [0.0, 0.3, 0.7, 1.0];
  // 背景起始颜色
  public static readonly BACKGROUND_END_COLOR: string = '#00ffffff';
}

@Builder
export function TestGradientPageBuilder() {

  NavDestination() {
    TestGradientPage()
  }
  .hideTitleBar(true)

}

const TAG = "TestGradientPage"

@Entry
@ComponentV2
struct TestGradientPage {
  private TAG: string = "TestGradientPage";

  // 初始化数据列表 (可以传入本地图片资源或者网络图片地址)
  initCardsList: CardInfo[] = [];
  // 是否开启边缘渐变
  isEdgeFading: boolean = true;
  // 是否开启背景跟随主题色转换
  isBackgroundColorChange: boolean = true;
  // 是否开启预览大图
  isShowPreviewImage: boolean = true;

  // 边缘渐变起始和终止颜色
  @Local private linearGradientBeginColor: string = Constants.BEGIN_COLOR;
  @Local private linearGradientEndColor: string = Constants.END_COLOR;
  // 初始背景色
  @Local private bgColor: string = Constants.BACKGROUND_END_COLOR;
  // 背景叠底位置
  private backgroundMaskZIndex: number = -1;
  // 卡片数据源
  private data: CardsSource = new CardsSource([]);
  // 卡片数据列表
  @Local private cardsList: CardInfo[] = [];
  // 卡片偏移度列表
  @Local private cardsOffset: number[] = [];
  // 屏幕宽度
  private displayWidth: number = 0;
  // Swiper 两侧的偏移量
  private swiperMargin: number = Constants.SWIPER_MARGIN;
  // Swiper 当前索引值
  @Local private currentSwiperIndex: number = 0;
  // 数据源对应的缩放数组
  @Local scaleList: number[] = [];
  // 最大缩放
  private MAX_SCALE: number = 1;
  // 最小缩放
  private MIN_SCALE: number = 0.8;
  // 手势触发时的offset
  @Local startSwiperOffset: number = 0;
  // 图片缩放的比例
  @Local proportion: number = 0;

  @Local private testImageStartColor: string = Constants.BACKGROUND_END_COLOR;
  @Local private testImageStartColor_08: string = Constants.BACKGROUND_END_COLOR;
  @Local private testImageStartColor_07: string = Constants.BACKGROUND_END_COLOR;

  @Local private testImageColor: string = Constants.BACKGROUND_END_COLOR;
  @Local private testLargestProportionColor: string = Constants.BACKGROUND_END_COLOR;


  aboutToAppear(): void {
    // 获取屏幕大小，初始化displayWidth，用于后续计算卡片的偏移量
    const displayData: display.Display = display.getDefaultDisplaySync();
    this.displayWidth = px2vp(displayData.width);
    if ((display.isFoldable() && display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED) ||
      this.displayWidth >= 600) {
      this.displayWidth = px2vp(displayData.width) / 2;
    }
    // 传入数据添加至卡片数据，并初始化偏移量列表，初始化缩放系数数组
    this.initCardsListAndOffset(this.initCardsList);
    // 初始化懒加载列表
    this.data = new CardsSource(this.cardsList);
    // 计算当前卡片及关联卡片的偏移量
    this.calculateOffset(0);
  }

  /**
   * 初始化 cardsList, cardsOffset 及 scaleList。读取传入的case，并添加卡片数据，初始化偏移量列表和缩放系数数组。
   * @param {CardInfo[]} initCardsList - 初始化数据列表
   */
  private initCardsListAndOffset(initCardsList: CardInfo[]) {
    // 传入case为空时，使用预置用例
    if (initCardsList === undefined || initCardsList.length === 0) {
      initCardsList = Constants.CARD_TEST_CASE
    }
    // 将初始化list传入卡片数据列表、卡片偏移度列表
    initCardsList.forEach((item, index) => {
      this.cardsList.push(item);
      this.cardsOffset.push(0);
      // 初始化数据源对应的缩放系数存入数组
      this.scaleList.push(index === 0 ? this.MAX_SCALE : this.MIN_SCALE);
    })
    // 初始化背景色
    this.initBackground();
  }

  /**
   * 初始化背景。
   */
  private async initBackground() {
    // TODO 知识点：初始化页面获取第一张图片的颜色
    const context = getContext(this);
    const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    const fileData: Uint8Array = await resourceMgr.getMediaContent(this.cardsList[0].src as Resource);
    const buffer = fileData.buffer as ArrayBuffer;
    const imageSource: image.ImageSource = image.createImageSource(buffer);
    const pixelMap: image.PixelMap = await imageSource.createPixelMap();

    // TODO 知识点：智能取色器接口使用，初始化背景色
    effectKit.createColorPicker(pixelMap, (err, colorPicker) => {
      let color = colorPicker.getMainColorSync();
      // 将取色器选取的color示例转换为十六进制颜色代码
      this.bgColor = "#" + color.alpha.toString(16) + color.red.toString(16) + color.green.toString(16) + color.blue.toString(16)

      this.testImageStartColor = `rgba(${color.red},${color.green},${color.blue},0.0)`
      this.testImageStartColor_08 = `rgba(${color.red},${color.green},${color.blue},0.8)`
      this.testImageStartColor_07 = `rgba(${color.red},${color.green},${color.blue},0.7)`

      // this.testImageStartColor = "#" + color.alpha.toString(16) + color.red.toString(16) + color.green.toString(16) + color.blue.toString(16)

      let largestColor = colorPicker.getLargestProportionColor();
      this.testLargestProportionColor = "#" + largestColor.alpha.toString(16) + largestColor.red.toString(16) + largestColor.green.toString(16) + largestColor.blue.toString(16)


    })
  }

  // build() {
  //   Column() {
  //     Scroll(){
  //       Column(){
  //         Stack() {
  //           // 渐变背景叠底
  //           Column() {
  //           }
  //           .width('100%')
  //           .height(500)
  //           .zIndex(-1)
  //           .visibility(this.isBackgroundColorChange ? Visibility.Visible : Visibility.Hidden)
  //           .linearGradient({
  //             // 渐变方向，从上至下
  //             angle: Constants.LINEAR_GRADIENT_ANGLE,
  //             // 数组末尾元素占比小于1时，满足重复着色的效果
  //             colors: [
  //               [this.bgColor, 0.0],
  //               [Constants.BACKGROUND_END_COLOR, 0.3],
  //               [Constants.BACKGROUND_END_COLOR, 0.7],
  //               [this.bgColor, 1.0]
  //             ]
  //           })
  //         }
  //         Blank().height(11)
  //
  //         this.testImageGradient()
  //         this.testImageGradient2()
  //
  //       }
  //
  //     }
  //
  //   }
  // }

  //连续两个expandSafeArea top，有空白间隙
  build() {

      RelativeContainer() {
        Row()
          .width('100%')
          .aspectRatio(1.0)
          .backgroundColor(Color.Red)
            // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])//设置这个 两个区块有空白间隙
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start },
          })
          .id('bgImg')

        Column() {
        }
        .width('100%')
        .height(20)
        .backgroundColor(Color.Blue)
        .alignRules({
          top: { anchor: 'bgImg', align: VerticalAlign.Bottom },
          left: { anchor: 'bgImg', align: HorizontalAlign.Start },
        })
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])

      }
      .width('100%').height('100%')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .backgroundColor(Color.Green)
    //
    // Column(){
    //   Image(this.cardsList[0].src)
    //     .width('100%')
    //     .height(200)
    //     .objectFit(ImageFit.Cover)
    //     .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    //
    //   Column()
    //     .width('100%')
    //     .layoutWeight(1)
    //     .backgroundColor(this.testImageStartColor_07)
    //     .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

      // .linearGradient({
        //   // 渐变方向，从上至下
        //   angle: Constants.LINEAR_GRADIENT_ANGLE,
        //   // 数组末尾元素占比小于1时，满足重复着色的效果
        //   colors: [
        //     [Constants.BACKGROUND_END_COLOR, 0.0],
        //     // [Constants.BACKGROUND_END_COLOR, 0.3],
        //     [this.testImageStartColor_07, 0.5],
        //     [this.testImageStartColor_08, 1.0]
        //   ]
        // })
    // }
    // .justifyContent(FlexAlign.Start)
    // .width('100%')
    // .height('100%')
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  @Builder
  testImageGradient() {
    Column(){
      Stack(){
        Image(this.cardsList[0].src)
          .width('100%')
          .height(200)
          .objectFit(ImageFit.Cover)

        Column()
          .width('100%')
          .height(350)
          .position({top:150})
          .linearGradient({
            // 渐变方向，从上至下
            angle: Constants.LINEAR_GRADIENT_ANGLE,
            // 数组末尾元素占比小于1时，满足重复着色的效果
            colors: [
              [Constants.BACKGROUND_END_COLOR, 0.0],
              // [Constants.BACKGROUND_END_COLOR, 0.3],
              [this.testImageStartColor_07, 0.5],
              [this.testImageStartColor_08, 1.0]
            ]
          })
      }
      .height(500)
      // Column()
      //   .width('100%')
      //   .height(200)
      //   // .backgroundColor(this.testImageStartColor_07)
      //   .linearGradient({
      //     // 渐变方向，从上至下
      //     angle: Constants.LINEAR_GRADIENT_ANGLE,
      //     // 数组末尾元素占比小于1时，满足重复着色的效果
      //     colors: [
      //       [this.testImageStartColor_07, 0.0],
      //       [this.testImageStartColor_08, 0.2],
      //       // [Constants.BACKGROUND_END_COLOR, 0.6],
      //       [this.testImageStartColor_08, 1.0]
      //     ]
      //   })
    }
    .width('100%')
    .height("500")
  }

  @Builder
  testImageGradient2() {
    Column(){
      Stack(){
        Image(this.cardsList[0].src)
          .width('100%')
          .height(200)
          .objectFit(ImageFit.Cover)

        Column()
          .width('100%')
          .height(100)
          .position({bottom:0})
          .linearGradient({
            // 渐变方向，从上至下
            angle: Constants.LINEAR_GRADIENT_ANGLE,
            // 数组末尾元素占比小于1时，满足重复着色的效果
            colors: [
              [Constants.BACKGROUND_END_COLOR, 0.0],
              // [Constants.BACKGROUND_END_COLOR, 0.3],
              // [this.testImageStartColor_08, 0.8],
              [this.testImageStartColor_07, 1.0]
            ]
          })
      }
      Column()
        .width('100%')
        .height(200)
        .backgroundColor(this.testImageStartColor_07)
        .linearGradient({
          // 渐变方向，从上至下
          angle: Constants.LINEAR_GRADIENT_ANGLE,
          // 数组末尾元素占比小于1时，满足重复着色的效果
          colors: [
            [this.testImageStartColor_07, 0.0],
            [this.testImageStartColor_08, 0.2],
            // [Constants.BACKGROUND_END_COLOR, 0.6],
            [this.testImageStartColor_08, 1.0]
          ]
        })
    }
    .width('100%')
    .height("500")
  }

  /**
   * 计算卡片偏移量，并维护偏移量列表。
   * @param { number } targetIndex - swiper target card's index.
   */
  private calculateOffset(target: number) {
    let left = target - 1;
    let right = target + 1;

    // 计算上一张卡片的偏移值
    if (this.isIndexValid(left)) {
      this.cardsOffset[left] = this.getMaxOffset(left) - this.cardsList[left].width * (1 - this.MIN_SCALE) / 2;
    }
    // 计算当前卡片的偏移值
    if (this.isIndexValid(target)) {
      this.cardsOffset[target] = this.getMaxOffset(target) * this.proportion / 2;
    }
    // 下一张片的偏移值
    if (this.isIndexValid(right)) {
      this.cardsOffset[right] = -this.cardsList[right].width * (1 - this.MIN_SCALE) / 2;
    }
  }

  /**
   * 检查卡片索引值的合法性。
   * @param {number} index - input card's index.
   * @returns {boolean} true or false.
   */
  private isIndexValid(index: number): boolean {
    return index >= 0 && index < this.cardsList.length;
  }

  /**
   * 计算指定卡片的最大偏移量。
   * @param {number} index - target card's index.
   * @returns {number} offset value.
   */
  private getMaxOffset(index: number): number {
    /*
     * 这里的偏移量指相对容器左侧的值。
     * 计算公式为：屏幕宽度 - Swiper两侧突出的偏移量 - 卡片自身的宽度。
     * 此值即为卡片可偏移的最大值，也就是卡片右对齐的状态值。
     * 如果居中，则将最大偏移量 / 2。
     */
    // 原图时最大偏移量
    let maxOffset: number = this.displayWidth - this.cardsList[index].width - 2 * this.swiperMargin;
    // 缩放时最大偏移量
    let maxOffsetScale: number =
      this.displayWidth - this.cardsList[index].width * this.MIN_SCALE - 2 * this.swiperMargin;
    this.proportion = maxOffset / maxOffsetScale;
    return maxOffsetScale;
  }

  /**
   * 根据卡片滑动距离实时计算卡片缩放系数。
   * @param {number} index - target card's index.
   * @param {number} offset - current Offset distance.
   */
  private calculateScaling(index: number, offset: number) {
    let currentScale: number = this.scaleList[index];
    let nextIndex: number = (index === this.scaleList.length - 1 ? 0 : index + 1);
    let preIndex: number = (index === 0 ? this.scaleList.length - 1 : index - 1);
    let nextScale: number = this.scaleList[nextIndex];
    let preScale: number = this.scaleList[preIndex];
    if (this.startSwiperOffset === 0) {
      this.startSwiperOffset = offset;
    }
    // 滑动距离
    let distance: number = Math.abs(this.startSwiperOffset - offset);
    currentScale = this.MAX_SCALE - Math.min(distance / this.displayWidth, this.MAX_SCALE - this.MIN_SCALE);
    // 滑动时实时缩放的比例
    if (this.startSwiperOffset > offset) {
      nextScale = this.MIN_SCALE + Math.min(distance / this.displayWidth, this.MAX_SCALE - this.MIN_SCALE);
      preScale = this.MIN_SCALE;
    } else {
      preScale = this.MIN_SCALE + Math.min(distance / this.displayWidth, this.MAX_SCALE - this.MIN_SCALE);
      nextScale = this.MIN_SCALE;
    }
    this.scaleList[this.currentSwiperIndex] = currentScale;
    this.scaleList[nextIndex] = nextScale;
    this.scaleList[preIndex] = preScale;
  }

  /**
   * 切换动画过程中获取当前图片的平均颜色
   */
  async getAverageColor(picSrc: ResourceStr) {
    const context = getContext(this);
    // 获取resourceManager资源管理器
    const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    const fileData: Uint8Array = await resourceMgr.getMediaContent(picSrc as Resource);
    // 获取图片的ArrayBuffer
    const buffer = fileData.buffer as ArrayBuffer;
    // 创建imageSource
    const imageSource: image.ImageSource = image.createImageSource(buffer);
    // 创建pixelMap
    const pixelMap: image.PixelMap = await imageSource.createPixelMap();

    effectKit.createColorPicker(pixelMap, (err, colorPicker) => {
      // 读取图像主色的颜色值，结果写入Color
      let color = colorPicker.getMainColorSync();
      // 开启背景颜色渲染的属性动画
      animateTo({ duration: 500, curve: Curve.Linear, iterations: 1 }, () => {
        // 将取色器选取的color示例转换为十六进制颜色代码
        this.bgColor = "#" + color.alpha.toString(16) + color.red.toString(16) + color.green.toString(16) + color.blue.toString(16);
      })
    })
  }

  /**
   * 浮层组件，实现边缘渐变效果，根据isEdgeFading判断是否开启
   */
  @Builder
  fadingOverlay() {
    Column()
      .width(Constants.CARD_SWIPER_FULL_SIZE)
      .height(Constants.FADING_OVERLAY_LENGTH)
        // TODO: 知识点: linearGradient 可以设置指定范围内的颜色渐变效果
      .linearGradient({
        angle: Constants.OVERLAY_LINEAR_GRADIENT_ANGLE,
        colors: [
          [this.linearGradientBeginColor, Constants.OVERLAY_LINEAR_GRADIENT_COLOR_POS[0]],
          [Constants.BEGIN_COLOR, Constants.OVERLAY_LINEAR_GRADIENT_COLOR_POS[1]],
          [Constants.BEGIN_COLOR, Constants.OVERLAY_LINEAR_GRADIENT_COLOR_POS[2]],
          [this.linearGradientEndColor, Constants.OVERLAY_LINEAR_GRADIENT_COLOR_POS[3]],
        ]
      })
      .animation({
        curve: Constants.OVERLAY_ANIMATION_CURVE,
        duration: Constants.OVERLAY_DURATION
      })
      .hitTestBehavior(HitTestMode.Transparent)
      .visibility(this.isEdgeFading ? Visibility.Visible : Visibility.Hidden)
  }
}

/**
 * 保存卡片信息列表的懒加载类。
 */
export class CardsSource implements IDataSource {
  // cardInfo对象集合
  private list: CardInfo[] = [];

  /**
   * 构造器
   * @param list
   */
  constructor(list: CardInfo[]) {
    this.list = list;
  }

  /**
   * Total data count
   * @returns: length
   */
  totalCount(): number {
    return this.list.length;
  }

  /**
   * Return the data of index
   * @param index - 集合 index
   * @returns: 集合index项数据
   */
  getData(index: number): CardInfo {
    return this.list[index];
  }

  /**
   * Register data change listener
   */

  registerDataChangeListener(): void {
  }

  /**
   * Unregister data change listener
   */
  unregisterDataChangeListener(): void {
  }
}

/**
 * 卡片信息的接口类型。
 */
export interface CardInfo {
  // 图片路径
  src: ResourceStr,
  // 卡片中图片展示宽度
  width: number,
  // 卡片中图片展示高度
  height: number
}