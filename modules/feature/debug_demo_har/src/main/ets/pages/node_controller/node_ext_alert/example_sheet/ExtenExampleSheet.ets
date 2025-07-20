import { hsLog } from "@learn/logger_har"
import { NodeDataViewModel } from "../NodeDataViewModel"

///// =============== NodeController 刷新，子组件每次都会触发 aboutToAppear （解决在aboutToAppear处理数据请求 一些异常) =========//
const TAG = "ExtenExampleSheet"

@ComponentV2
struct ExtendExampleSheet {
  @Param @Require viewModel: NodeDataViewModel

  @Builder
  TextBuilder(params?: NodeDataViewModel) {
    if (params) {
      Column() {
        Blank().height(12)
        Text("aaaa")
      }

    }
  }

  aboutToAppear(): void {
    hsLog.i(TAG, "aboutToAppear")
  }

  aboutToDisappear(): void {
    hsLog.i(TAG, "aboutToDisappear")
  }

  build() {
    Column() {
      Column() {
        Text("默认")
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor("#50000000")
      .onClick(() => {
        this.viewModel.hide()
      })

      Column() {
        this.TextBuilder(this.viewModel)
      }
      .width('100%')
      .height('500vp')
      .backgroundColor(Color.White)
    }
    .justifyContent(FlexAlign.End)
    .backgroundColor(Color.Orange)
    .width('100%')
    .height('100%')
    .transition(
      TransitionEffect.move(TransitionEdge.BOTTOM)
        .animation({
          duration: 500,
          curve: Curve.Friction
        })
    )
  }
}


@Builder
export function extendExampleBuilder(params: NodeDataViewModel) {
  ExtendExampleSheet({ viewModel: params })
}

export let textViewComponent = wrapBuilder(extendExampleBuilder)