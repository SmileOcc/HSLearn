/*
 * @Desc: 以页面形式显示loading等待层
 */
import { YWLoadingStyle } from './YWLoadingStyle';
import { YWLottieLoading } from './YWLottieLoading';
import { hsGlobalThis, YWNavRouterUtils } from '@learn/common_har';

@Component
export struct YWLoading {
  private gStyle: YWLoadingStyle | undefined = hsGlobalThis.getObject<YWLoadingStyle>('YWLoadingStyle');
  private style: YWLoadingStyle = this.gStyle ? this.gStyle : {};
  private pathStack: NavPathStack = new NavPathStack()
  @State backCancel: boolean = true;
  @State outsideCancel: boolean = false;
  @State alignment: Alignment = Alignment.Center;
  @State layout: WrappedBuilder<[object]> = this.style.layout ? this.style.layout : wrapBuilder(defaultLoading);
  @State outBoxAttr: AttributeModifier<StackAttribute> = {};

  build() {
    NavDestination() {
      Stack() {
        Stack()
          .width('100%')
          .height('100%')
          .onClick(() => {
            if (this.outsideCancel) {
              this.pathStack.pop();
            }
          })
        //具体实现
        this.layout.builder(undefined)
      }
      .backgroundColor($r('sys.color.mask_secondary'))
      .alignContent(this.alignment)
      .width('100%')
      .height('100%')
      .attributeModifier(this.outBoxAttr)
    }
    .onReady(cxt => {
      this.pathStack = cxt.pathStack
      const parm = cxt.pathInfo.param as YWLoadingStyle
      this.creatCurStyle(parm)
    })
    .onAppear(() => {
      AppStorage.setOrCreate('isLoadingStart', true);
    })
    .onDisAppear(() => {
      AppStorage.setOrCreate('isLoadingStart', false);
    })
    .onBackPressed(() => {
      return !this.backCancel;
    })
    .mode(NavDestinationMode.DIALOG)
    .hideTitleBar(true)
  }

  private creatCurStyle(parm: YWLoadingStyle) {
    if (parm === undefined) {
      return;
    }

    if (parm.alignment !== undefined) {
      this.alignment = parm.alignment;
    } else if (this.style.alignment !== undefined) {
      this.alignment = this.style.alignment;
    }

    if (parm.pressBackCancel !== undefined) {
      this.backCancel = parm.pressBackCancel;
    } else if (this.style.pressBackCancel !== undefined) {
      this.backCancel = this.style.pressBackCancel;
    }

    if (parm.outsideCancel !== undefined) {
      this.outsideCancel = parm.outsideCancel;
    } else if (this.style.outsideCancel !== undefined) {
      this.outsideCancel = this.style.outsideCancel;
    }

    if (parm.outBoxAttr !== undefined) {
      this.outBoxAttr = parm.outBoxAttr;
    } else if (this.style.outBoxAttr !== undefined) {
      this.outBoxAttr = this.style.outBoxAttr;
    }

    if (parm.layout !== undefined) {
      this.layout = parm.layout;
    } else if (this.style.layout !== undefined) {
      this.layout = this.style.layout;
    }
  }

  /**
   * 全局初始化样式
   */
  static initDefaultStyle(YWLoadingStyle: YWLoadingStyle) {
    hsGlobalThis.setObject('YWLoadingStyle', YWLoadingStyle)
  }

  public static open(parm: YWLoadingStyle = {}) {
    YWNavRouterUtils.push('Loading', parm);
  }

  public static close() {
    YWNavRouterUtils.finishPage('Loading');
  }
}

@Builder
function defaultLoading() {
  YWLottieLoading()
}


@Builder
export function RegisterBuilder(): void {
  YWLoading();
}