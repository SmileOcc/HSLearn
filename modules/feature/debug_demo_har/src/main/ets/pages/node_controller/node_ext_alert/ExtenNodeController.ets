import { BuilderNode, NodeController, UIContext } from "@kit.ArkUI";
import { kNode_Status_hide, kNode_Status_Show, NodeViewModel } from "./NodeViewModel";

export class ExtendNodeController<UIModel extends NodeViewModel> extends NodeController {
  rootNode?:BuilderNode<[UIModel]> | undefined = undefined
  private currentNode: FrameNode | null = null
  uiViewModel: UIModel
  wrapBuilder: WrappedBuilder<[UIModel]>
  constructor(viewModel: UIModel, builder:WrappedBuilder<[UIModel]>) {
    super()
    this.uiViewModel = viewModel
    this.wrapBuilder = builder
    this.uiViewModel.addLister((status)=>{
      if (status == kNode_Status_Show && !this.rootNode) {
        this.rebuild()
      } else if (status == kNode_Status_hide && this.rootNode) {
        this.rebuild()
      }
    })
  }

  makeNode(uiContext: UIContext): FrameNode | null {
    if (this.uiViewModel.getStatus() == kNode_Status_hide) {
      this.rootNode?.dispose()
      this.rootNode = undefined

    } else if (this.uiViewModel.getStatus() == kNode_Status_Show) {
      this.rootNode = new BuilderNode(uiContext);

      //可以根据参数中的类型，build不同的wrapBuilder
      this.rootNode.build(this.wrapBuilder, this.uiViewModel)
      this.currentNode = null
      this.currentNode = this.rootNode.getFrameNode() //通过这种方式可以每次触发 组件的aboutToAppear
      return this.currentNode
    }

    return null
  }

  clear() {
    this.rootNode?.dispose()
    this.rootNode = undefined
  }

  aboutToDisappear(): void {
    this.clear()
  }

}