import { BuilderNode, NodeController } from '@kit.ArkUI'
import { hsLog } from '@learn/logger_har'
import { ExtenUIBaseViewModel } from './ExtenUIViewModel'

class ExtenSheetNodeController extends NodeController {
  private rootNode: BuilderNode<[SheetNodeParams]> | null = null
  private currentNode: FrameNode | null = null
  private params?: SheetNodeParams
  //如果有多种类型，可以设置成集合
  private wrapBuilder: WrappedBuilder<[SheetNodeParams]> = wrapBuilder(sheetNodeBuilder)

  setWrapBuilder(wrap:WrappedBuilder<[SheetNodeParams]>) {
    this.wrapBuilder = wrap
  }

  updateParams(params: SheetNodeParams) {
    this.params = params

    // 调用此接口通知NodeContainer组件重新回调makeNode方法，更改子节点。
    this.rebuild()
  }

  // makeNode
  // abstract makeNode(uiContext : UIContext): FrameNode | null
  // 当实例绑定的NodeContainer创建的时候进行回调。回调方法将返回一个节点，将该节点挂载至NodeContainer。
  // 或者可以通过NodeController的rebuild()方法进行回调的触发。

  makeNode(uiContext: UIContext): FrameNode | null {
    if (!this.params) {
      return null
    }
    if (this.rootNode == null) {
      this.rootNode = new BuilderNode(uiContext);
    } else {
      let parent = this.rootNode.getFrameNode()?.getParent()
      if (parent) {
        //移除当前这个node
        // parent.removeChild(this.currentNode)
        // parent = null //这个会把 所以其他也移除
      }
    }
    //可以根据参数中的类型，build不同的wrapBuilder
    this.rootNode.build(this.wrapBuilder, this.params)

    this.currentNode = null
    this.currentNode = this.rootNode.getFrameNode() //通过这种方式可以每次触发 组件的aboutToAppear
    return this.currentNode
  }


  aboutToResize(size: Size) {
    console.log("aboutToResize width : " + size.width + " height : " + size.height)
  }

  aboutToAppear() {
    console.log("aboutToAppear")
  }

  aboutToDisappear() {
    console.log("aboutToDisappear");
  }

  onTouchEvent(event: TouchEvent) {
    console.log("onTouchEvent");
  }
}

///// =============== NodeController 刷新，子组件每次都会触发 aboutToAppear （解决在aboutToAppear处理数据请求 一些异常) =========//
const TAG = "ExtendSheetNodeComponent"
@ComponentV2
struct ExtendSheetNodeComponent {

  @Param @Require params: SheetNodeParams

  aboutToAppear(): void {
    hsLog.i(TAG,"aboutToAppear")
  }
  aboutToDisappear(): void {
    hsLog.i(TAG,"aboutToDisappear")
  }

  build() {
    Stack(){
      ForEach(this.params.plugList, (e: ExtenUIBaseViewModel) => {
        NodeContainer(e.onCreateNode())
      }, (embedId: string) => embedId)
    }
  }
}


@Builder
function sheetNodeBuilder(params: SheetNodeParams) {
  ExtendSheetNodeComponent({params:params})

}

export let textViewComponent = wrapBuilder(sheetNodeBuilder)

export class SheetNodeParams {
  plugList:ExtenUIBaseViewModel[] = []
}