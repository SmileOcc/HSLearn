import { DialogBuilderParam, YWWindowUtils } from "@learn/common_har";
import { image } from "@kit.ImageKit";
import { RectPosition, ActionType, Position, InitPosition } from '../model/Bean';
import fs from '@ohos.file.fs';
import { BusinessError } from "@kit.BasicServicesKit";
import { YWConstants } from "@learn/constants_har";
import { AppStorageV2 } from "@kit.ArkUI";
import { hsLog } from "@learn/logger_har";

const TAG = "ImageEdit"
@Component
export struct ImageEdit {
  @Prop param: DialogBuilderParam;
  @Provide pixelMap: image.PixelMap | undefined = undefined;
  @Provide imageInfo: image.ImageInfo | undefined = undefined;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private settings2: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasContext2: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings2);
  private actionType: ActionType = ActionType.move;
  private screenWidth: number = YWWindowUtils.getScreenWidth();
  private screenHeight: number = YWWindowUtils.getScreenHeight();

  private topBarHeight: number = AppStorage.get(YWConstants.kStatusBarHeight) as number ?? 0
  private bottomBarHeight: number = this.param.data.bottomHeight ?? 60
  private contentWidth = this.screenWidth
  private contentHeight = this.screenHeight - this.topBarHeight - this.bottomBarHeight
  //固定裁剪窗口大小
  private coverWidth = 200
  private coverHeight = 200

  private imageInfoWidth: number = 0
  private imageInfoHeight: number = 0

  private imageScale: number = 1

  private touchPosition: Position = {
    x: 0,
    y: 0,
  };
  @State private initPosition: InitPosition = {
    x: 0,
    y: 0,
    width: 0,
    height: 0,
  }
  @State @Watch('drawMask') clipRect: RectPosition = {
    x: 0,
    y: 0,
    height: 0,
    width: 0
  };

  aboutToAppear(): void {
    if (this.bottomBarHeight < 60) {
      this.bottomBarHeight = 60
    }
    this.contentHeight = this.screenHeight - this.topBarHeight - this.bottomBarHeight
    this.clipRect.width = this.coverWidth
    this.clipRect.height = this.coverHeight
    this.initData();
  }

  /**
   * 裁剪框位置和大小变化，初始位置为图片的初始坐标，移动的坐标
   * @param moveX
   * @param moveY
   */
  moveClipCanvas(moveX: number, moveY: number) {
    let clipRect: RectPosition = {
      x: this.clipRect.x,
      y: this.clipRect.y,
      width: this.clipRect.width,
      height: this.clipRect.height
    }
    switch (this.actionType) {
      case ActionType.move:
        clipRect.x += moveX;
        clipRect.y += moveY;
        break;
      case ActionType.topLeft:
        clipRect.x += moveX;
        clipRect.y += moveY;
        clipRect.width += -moveX;
        clipRect.height += -moveY;
        break;
      case ActionType.topRight:
        clipRect.y += moveY;
        clipRect.width += moveX;
        clipRect.height += -moveY;

        break;
      case ActionType.bottomLeft:
        clipRect.x += moveX;
        clipRect.width += -moveX;
        clipRect.height += moveY;
        break;
      case ActionType.bottomRight:
        clipRect.width += moveX;
        clipRect.height += moveY;
        break;
      default:
        break;
    }

    // 偏移坐标小于初始位置
    if (clipRect.x < this.initPosition.x) {
      clipRect.x = this.initPosition.x;
    }
    if (clipRect.y < this.initPosition.y) {
      clipRect.y = this.initPosition.y;
    }
    // 横坐标限制位置
    if (clipRect.width + clipRect.x > this.initPosition.width + this.initPosition.x) {
      if (this.actionType === ActionType.move) {
        clipRect.x = this.initPosition.width + this.initPosition.x - clipRect.width;
      } else {
        clipRect.width = this.initPosition.width + this.initPosition.x - clipRect.x
      }
    }
    // 纵坐标限制
    if (clipRect.height + clipRect.y > this.initPosition.height + this.initPosition.y) {
      if (this.actionType === ActionType.move) {
        clipRect.y = this.initPosition.height + this.initPosition.y - clipRect.height;
      } else {
        clipRect.height = this.initPosition.height + this.initPosition.y - clipRect.y;
      }
    }
    if (clipRect.width < 30 || clipRect.height < 30) {
      hsLog.d(TAG,`===clip end: ${JSON.stringify(this.clipRect)}`)
      return
    }

    this.clipRect = {
      x: Math.round(clipRect.x),
      y: Math.round(clipRect.y),
      width: Math.round(clipRect.width),
      height: Math.round(clipRect.height)
    };

    hsLog.d(TAG,`===clip: ${JSON.stringify(this.clipRect)}`)
  }

  /**
   * 取消剪切
   */
  cancel() {
    this.param.closeDialog!();
  }

  /**
   * 绘制蒙层
   */
  drawMask() {
    // this.canvasContext2.clearRect(0, 0, this.imageInfo?.size.width, this.imageInfo?.size.height);
    // this.canvasContext2.fillStyle = 'rgba(0,0,0,0.7)';
    // this.canvasContext2.fillRect(0, 0, px2vp(this.imageInfo?.size.width), px2vp(this.imageInfo?.size.height));
    // this.canvasContext2.clearRect(this.clipRect.x - this.initPosition.x, this.clipRect.y - this.initPosition.y,
    //   this.clipRect.width, this.clipRect.height);

    this.canvasContext2.clearRect(0, 0, this.contentWidth, this.contentHeight);
    this.canvasContext2.fillStyle = 'rgba(0,0,0,0.7)';
    this.canvasContext2.fillRect(0, 0, this.contentWidth, this.contentHeight);
    this.canvasContext2.clearRect(this.clipRect.x - this.initPosition.x, this.clipRect.y - this.initPosition.y,
      this.clipRect.width, this.clipRect.height);
  }

  /**
   * 初始化裁剪图片
   */
  async initData() {
    fs.open(this.param.data.uri, fs.OpenMode.READ_ONLY).then(async (file) => {
      const imageSource: image.ImageSource = image.createImageSource(file.fd);
      let decodingOptions: image.DecodingOptions = {
        editable: true,
        desiredPixelFormat: 3
      }
      imageSource.createPixelMap(decodingOptions).then((pixelMap) => {
        pixelMap.getImageInfo().then((imageInfo) => {
          this.imageInfo = imageInfo;
          this.pixelMap = pixelMap;
          this.imageInfoWidth = Math.round(this.imageInfo.size.width)
          this.imageInfoHeight = Math.round(this.imageInfo.size.height)

          let imageInfoWidthVp = px2vp(this.imageInfoWidth)
          let imageInfoHeightVp = px2vp(this.imageInfoHeight)

          let imageScale = imageInfoWidthVp / imageInfoHeightVp
          let contentScale = this.contentWidth / this.contentHeight
          this.imageScale = imageScale
          if (imageScale > contentScale) {
            this.initPosition.width = this.contentWidth
            this.initPosition.height = this.initPosition.width / imageScale
            this.initPosition.x = 0
            this.initPosition.y = (this.contentHeight - this.initPosition.height) / 2.0
          } else {
            this.initPosition.height = this.contentHeight
            this.initPosition.width = this.initPosition.height * imageScale
            this.initPosition.x = (this.contentWidth - this.initPosition.width) / 2.0
            this.initPosition.y = 0
          }
          //TODO 根据图片 限制裁剪框的 初始默认值大小， 和 最小值等 ， 裁剪框居中

          hsLog.d(TAG, `imageScale = coverScale (${imageScale} : ${contentScale})`)
          hsLog.d(TAG, `imageInfoWidthVp = imageInfoHeightVp (${imageInfoWidthVp} : ${imageInfoHeightVp})`)
          hsLog.d(TAG, `contentWidth = contentHeight (${this.contentWidth} : ${this.contentHeight})`)
          hsLog.d(TAG, `initPosition result: (${this.initPosition.width} : ${this.initPosition.height})`)

          // 裁剪框初始位置
          // this.initPosition.width = px2vp(Math.round(this.imageInfo.size.width));
          // this.initPosition.height = px2vp(Math.round(this.imageInfo.size.height));

          // this.initPosition.width = this.screenWidth;
          // this.initPosition.height = this.screenHeight;
          // this.clipRect.height = px2vp(this.imageInfo.size.height / 4);
          // this.clipRect.width = px2vp(this.screenWidth);

          // this.clipRect.height = this.initPosition.height;
          // this.clipRect.width = this.initPosition.width;

          this.clipRect.x = this.initPosition.x;
          this.clipRect.y = this.initPosition.y;
        })
      })
    });
  }

  /**
   * 绘制裁剪框
   */
  drawClipImage() {
    this.canvasContext.clearRect(0, 0, this.clipRect.width, this.clipRect.height);
    this.canvasContext.lineWidth = 6;
    this.canvasContext.strokeStyle = '#3299cc';
    this.canvasContext.beginPath();

    this.canvasContext.moveTo(0, 20);
    this.canvasContext.lineTo(0, 0);
    this.canvasContext.lineTo(20, 0);

    this.canvasContext.moveTo(this.clipRect.width - 20, 0);
    this.canvasContext.lineTo(this.clipRect.width, 0);
    this.canvasContext.lineTo(this.clipRect.width, 20);

    this.canvasContext.moveTo(0, this.clipRect.height - 20);
    this.canvasContext.lineTo(0, this.clipRect.height);
    this.canvasContext.lineTo(20, this.clipRect.height);

    this.canvasContext.moveTo(this.clipRect.width - 20, this.clipRect.height);
    this.canvasContext.lineTo(this.clipRect.width, this.clipRect.height);
    this.canvasContext.lineTo(this.clipRect.width, this.clipRect.height - 20);
    this.canvasContext.stroke();

    this.canvasContext.beginPath();
    this.canvasContext.lineWidth = 0.5;
    let height = Math.round(this.clipRect.height / 3);
    for (let index = 0; index <= 3; index++) {
      let y = index === 3 ? this.clipRect.height : height * index;
      this.canvasContext.moveTo(0, y);
      this.canvasContext.lineTo(this.clipRect.width, y);
    }
    let width = Math.round(this.clipRect.width / 3);
    for (let index = 0; index <= 3; index++) {
      let x = index === 3 ? this.clipRect.width : width * index;
      this.canvasContext.moveTo(x, 0);
      this.canvasContext.lineTo(x, this.clipRect.height);
    }
    this.canvasContext.stroke();
  }

  /**
   * 裁剪图片
   */
  async clipImage() {
    let x = this.clipRect.x - this.initPosition.x;
    let y = this.clipRect.y - this.initPosition.y;

    let currentX = x / this.initPosition.width * this.imageInfoWidth
    let currentY = y / this.initPosition.height * this.imageInfoHeight
    let currentImageW = this.clipRect.width / this.initPosition.width * this.imageInfoWidth
    let currentImageH = this.clipRect.height / this.initPosition.height * this.imageInfoHeight

    if (currentX <= 0) {
      currentX = 0
    }
    if (currentY <= 0) {
      currentY = 0
    }
    if (currentImageW > this.imageInfoWidth) {
      currentImageW = this.imageInfoWidth
    }
    if (currentImageH > this.imageInfoHeight) {
      currentImageH = this.imageInfoHeight
    }

    this.pixelMap?.crop({
      x: currentX,
      y: currentY,
      size: { height: currentImageH, width: currentImageW }
    }).then(() => {
      this.param.onConfirm!(true, this.pixelMap);
    }).catch((error: BusinessError) => {
      if (error) {
        console.error(`Error: Image cropping failed. ErrorCode is ${error.code}, errorMessage is ${error.message}`);
      }
    })
  }

  /**
   * 判断操作类型
   * @param area
   * @param touch
   */
  isMove(area: Area, touch: TouchObject) {
    if (touch.x < 60 && touch.y < 60) {
      // 左上角
      this.actionType = ActionType.topLeft;
      hsLog.d(TAG,'左上角')
    } else if (touch.x < 60 && touch.y > (Number(area.height) - 60)) {
      // 左下
      this.actionType = ActionType.bottomLeft;
      hsLog.d(TAG,'左下角')

    } else if (touch.x > Number(area.width) - 60 && touch.y < 60) {
      // 右上
      this.actionType = ActionType.topRight;
      hsLog.d(TAG,'右上角')

    } else if (touch.x > Number(area.width) - 60 && touch.y > (Number(area.height) - 60)) {
      // 右下
      this.actionType = ActionType.bottomRight;
      hsLog.d(TAG,'右下角')

    } else {
      this.actionType = ActionType.move;
      hsLog.d(TAG,'====移动move')

    }
  }

  build() {
    Column(){
      Row()
        .width('100%')
        .height(this.topBarHeight)
        .backgroundColor(YWConstants.RandomColor())
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Image(this.pixelMap)
          .width(this.initPosition.width)
          .height(this.initPosition.height)
          .objectFit(ImageFit.Contain)
        // 蒙层
        Canvas(this.canvasContext2)
          .position({
            x: this.initPosition.x,
            y: this.initPosition.y
          })
          .width(this.initPosition.width)
          .height(this.initPosition.height)
        // 裁剪框
        Canvas(this.canvasContext)
          .position({
            x: this.clipRect.x,
            y: this.clipRect.y
          })
          .width(this.clipRect.width)
          .height(this.clipRect.height)
          .onReady(() => {
            this.drawClipImage()
          })
          .onTouch(event => {
            if (event.type === TouchType.Down) {
              this.isMove(event.target.area, event.touches[0]);
              this.touchPosition = {
                x: event.touches[0].windowX,
                y: event.touches[0].windowY
              }
            } else if (event.type === TouchType.Move) {
              let moveX = event.changedTouches[0].windowX - this.touchPosition.x;
              let moveY = event.changedTouches[0].windowY - this.touchPosition.y;
              this.touchPosition = {
                x: event.changedTouches[0].windowX,
                y: event.changedTouches[0].windowY
              }
              this.moveClipCanvas(moveX, moveY);
            }
          })

      }
      .width('100%')
      .layoutWeight(1)
      Row() {
        Text($r('app.string.addressrecognize_cancel_button'))
          .width("40vp")
          .height("40vp")
          .fontColor(Color.White)
          .onClick(() => {
            this.cancel();
          })
        Text($r('app.string.addressrecognize_complete_button'))
          .width("40vp")
          .height("40vp")
          .fontColor(Color.White)
          .onClick(() => {
            this.clipImage();
          })
      }
      .backgroundColor(YWConstants.RandomColor())
      // .margin({ top: "10vp" })
      .width("100%")
      // .height("7%")
      .height(this.bottomBarHeight)
      .padding({
        left: "30vp",
        right: "30vp",
      })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width("100%")
    .height("100%")
    // .backgroundColor($r('sys.color.black'))
    .backgroundColor(YWConstants.RandomColor())



  }
}

