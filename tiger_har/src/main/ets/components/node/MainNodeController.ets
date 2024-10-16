import { BuilderNode, FrameNode, NodeController, UIContext } from '@kit.ArkUI';
import { Queue } from '@kit.ArkTS';

export interface MainNodeConfig {
  title?:ResourceStr
  content:ResourceStr
  click?:()=>void
}

export class BuilderWrapData<T>{
  builderNode?: WrappedBuilder<[ComponentParams<T>]>
  params?:T
  controller?:ICustomComponentDelegate
}

export class MainNodeController extends NodeController implements INodeComponentDelegate{

  private uiContent?:UIContext

  // 置为null方便后续进行更新组件的时候的控制
  private rootNode?: FrameNode
  private componentQueue = new Queue<BuilderWrapData<object>>()

  // 在挂载时触发的逻辑, 需要提供一个具体的node
  makeNode(uiContext: UIContext): FrameNode | null {
    this.uiContent = uiContext

    if (!this.rootNode) {
      this.rootNode = new FrameNode(uiContext) //new BuilderNode<[BuilderWrapData<MainNodeConfig>]>(uiContext)
    }

    while (this.componentQueue.length > 0) {
      const builderWrap = this.componentQueue.pop()
      // this.rootNode.appnedchild

    }

    // 后续被rebuild调用时, 不会触发上面的if逻辑
    return this.rootNode
  }

  buildComponent(uiContext:UIContext, buildWrap:BuilderWrapData<object>): BuilderNode<[ComponentParams<object>,ICustomComponentDelegate]> {

    const builder = new BuilderNode<[ComponentParams<object>,ICustomComponentDelegate]>(uiContext)

    const builderParams:ComponentParams<object> = {
      controller:buildWrap.controller,
      params: buildWrap.params,

    }
    const frameNode = builder.getFrameNode()
    if (frameNode) {
      buildWrap.controller?.attach(frameNode,this)
    }
    builder.build(buildWrap.builderNode,builderParams)
    return builder
  }

  addComponent<T extends  object>(component:WrappedBuilder<[ComponentParams<T>]>, params:T): void {

    const controller = new CustomComponentController()
    const builderParams:BuilderWrapData<T> = {
      builderNode:component,
      controller: controller,
      params:params
    }

    if (this.uiContent && this.rootNode) {
      // this.rootNode.appnedchild
    } else {
      this.componentQueue.add(builderParams)
    }

  }

  remove(frameNode:FrameNode):void {

  }


  // 外部调用的更新的方法
  update<MainNodeConfig>(newData: BuilderWrapData<MainNodeConfig>): void {

    // update的数据类型要和builder一致
    // this.rootNode?.update(newData)

  }
}


export interface ComponentParams<T> {
  controller?: ICustomComponentDelegate
  params?:T
}

export interface INodeComponentDelegate {
  remove(frameNode:FrameNode):void
}


export interface ICustomComponentDelegate {

  attach(frameNode:FrameNode, controllerDelegate:INodeComponentDelegate): void

  // addComponent<T extends  object>(component:WrappedBuilder<[ComponentParams<T>]>): void

  getRootNodeNumber():number

  hidden(): void
}


export class CustomComponentController implements ICustomComponentDelegate {

  private rootNode?: FrameNode
  private controllerDelegate?:INodeComponentDelegate

  attach(frameNode:FrameNode, controllerDelegate:INodeComponentDelegate): void {
    this.rootNode = frameNode
    this.controllerDelegate = controllerDelegate
  }

  getRootNodeNumber():number {
    // return this.rootNode.ge
    return -1
  }

  hidden():void {
    if (this.rootNode) {
      this.controllerDelegate?.remove(this.rootNode)
    }
    // this.rootNode?.dispose
    this.rootNode = undefined
  }

}
