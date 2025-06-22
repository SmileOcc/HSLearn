import { resourceManager } from "@kit.LocalizationKit"
import { image } from "@kit.ImageKit"
import { effectKit } from "@kit.ArkGraphics2D"
import { ImageKnife, ImageKnifeComponent, ImageKnifeData } from "@ohos/imageknife"
import { fileUri } from "@kit.CoreFileKit"
import { ImageKnifeLoader } from "@ohos/imageknife/src/main/ets/ImageKnifeLoader"

export class MineColorImagePlugin {
  sourceUrl?: ResourceStr
  isLoading: boolean = false
  context: Context

  constructor(context: Context) {
    this.context = context
  }

  loadImage(url: ResourceStr,
    callBack: (sourceUrl: ResourceStr, localUrl: ResourceStr, bgColor?: string, bgAlpha?: number) => void) {
    if (this.isLoading) {
      return
    }
    this.isLoading = true
    this.sourceUrl = url
    if (typeof url !== 'string' && url as Resource) {
      //搞不懂，这种传入$r资源，里面读取报错（9001001 - Invalid resource ID.）
      // this.loadLocalImageColor($r(url),(color)=>{
      //   this.isLoading = false
      //   callBack(url, $r(`${url}`), color, undefined)
      // })
      this.loadLocalImageColor(url, (color) => {
        this.isLoading = false
        callBack(url, url, color, undefined)
      })

      return
    } else if (typeof url === 'string') {

      ImageKnife.getInstance().preLoadCache(url).then(async (value) => {
        if (value) {
          const loadurl =  fileUri.getUriFromPath(value)

          const dataInfo: ImageKnifeData | undefined = await ImageKnife.getInstance().getCacheImage(url)
          let source: PixelMap | string = ""
          if (dataInfo) {
            source = dataInfo.source
            const imageWidth: number = dataInfo.imageWidth
            const imageHeight: number = dataInfo.imageHeight
          }

          if (typeof source !== 'string') {
            this.loadNetImageColor(source,(color)=>{
              this.isLoading = false
              callBack(url, loadurl, color, undefined)
            })
          } else {
            this.isLoading = false
            callBack(url, loadurl, undefined, undefined)
          }


        } else {
          this.isLoading = false
          callBack(url, url, undefined, undefined)
        }
      })
      return
    }
    this.isLoading = false
    return callBack(url, $r('app.media.bg_small_web'), undefined, undefined)
  }

  async loadLocalImageColor(imgSource: Resource, callBack: (color?: string) => void) {
    // TODO 知识点：初始化页面获取第一张图片的颜色
    const context = this.context //getContext(this);
    const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    try {
      const fileData: Uint8Array = await resourceMgr.getMediaContent(imgSource);
      const buffer = fileData.buffer as ArrayBuffer;
      const imageSource: image.ImageSource = image.createImageSource(buffer);
      const pixelMap: image.PixelMap = await imageSource.createPixelMap();

      // TODO 知识点：智能取色器接口使用，初始化背景色 （取底部范围值）
      effectKit.createColorPicker(pixelMap, [0, 0.9, 1, 1], (err, colorPicker) => {
        //取平均值
        let color = colorPicker.getAverageColor();
        // 将取色器选取的color示例转换为十六进制颜色代码
        // this.bgColor = "#" + color.alpha.toString(16) + color.red.toString(16) + color.green.toString(16) + color.blue.toString(16)
        //
        // this.testImageStartColor = `rgba(${color.red},${color.green},${color.blue},0.0)`
        // this.testImageStartColor_08 = `rgba(${color.red},${color.green},${color.blue},0.8)`
        // this.testImageStartColor_07 = `rgba(${color.red},${color.green},${color.blue},0.7)`
        //
        // // this.testImageStartColor = "#" + color.alpha.toString(16) + color.red.toString(16) + color.green.toString(16) + color.blue.toString(16)
        //
        // let largestColor = colorPicker.getLargestProportionColor();
        // this.testLargestProportionColor = "#" + largestColor.alpha.toString(16) + largestColor.red.toString(16) + largestColor.green.toString(16) + largestColor.blue.toString(16)

        if (err) {
          callBack(undefined)
        } else {
          callBack(`rgba(${color.red},${color.green},${color.blue},1)`)
        }
      })
    } catch (e) {
      callBack(undefined)
    }

  }

  loadNetImageColor(source: PixelMap, callBack: (color?: string) => void) {
    // TODO 知识点：智能取色器接口使用，初始化背景色 （取底部范围值）
    effectKit.createColorPicker(source, [0, 0.9, 1, 1], (err, colorPicker) => {
      //取平均值
      let color = colorPicker.getAverageColor();
      if (err) {
        callBack(undefined)
      } else {
        callBack(`rgba(${color.red},${color.green},${color.blue},1)`)
      }
    })
  }
}