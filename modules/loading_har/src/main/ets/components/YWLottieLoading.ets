/*
 * @Desc: loading 动画
 */
import lottie from '@ohos/lottie';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';

@Component
export struct YWLottieLoading {
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private mainCanvasRenderingContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(this.mainRenderingSettings)
  private jsonData: string = '';
  // private politeChickyPath: string = 'components/loading/lottie/loading.json'; // hap包内动画资源文件路径，仅支持json格式
  @StorageProp('isLoadingStart') @Watch('loadAnimation') isStart: boolean = false;

  /**
   * 加载动画
   * @param autoplay 控制动画是否自动播放参数
   */
  loadAnimation() {
    if (this.isStart === undefined) {
      return
    }
    if (!this.isStart) {
      lottie.destroy();
      return
    }
    this.createAnimation();
  }

  private createAnimation() {
    // 销毁动画，减少缓存
    lottie.destroy();
    // let contexts = global.getObject<common.UIAbilityContext>('ui_context');
    let resStr = new util.TextDecoder('utf-8', { ignoreBOM: true });
    let contexts = getContext() as common.UIAbilityContext
    contexts.resourceManager.getRawFile('loading.json', (err: Error, data: Uint8Array) => {
      if (data === null || data === undefined || data.buffer === undefined) {
        return;
      }
      let lottieStr = resStr.decode(new Uint8Array(data.buffer));
      this.jsonData = JSON.parse(lottieStr);

      lottie.loadAnimation({
        container: this.mainCanvasRenderingContext, // 渲染上下文
        renderer: 'canvas', // 渲染方式
        loop: true, // 是否循环播放,默认true
        autoplay: true, // 是否自动播放，默认true
        animationData: this.jsonData, // json对象数据
        context: contexts, // 当前场景上下文context
        // contentMode: 'Contain',                      // 填充的模式
        // initialSegment: [10,50]                      // 播放的动画片段
      })
    })
  }

  build() {
    Canvas(this.mainCanvasRenderingContext)
      .width('85%')
      .height('50%')
      .onReady(() => {
        //抗锯齿的设置
        this.mainCanvasRenderingContext.imageSmoothingEnabled = true;
        this.mainCanvasRenderingContext.imageSmoothingQuality = 'medium'
      })
  }
}