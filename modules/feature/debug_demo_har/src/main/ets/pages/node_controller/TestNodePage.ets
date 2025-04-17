import { BuilderNode, NodeController } from "@kit.ArkUI"
import { YWConstants } from "@learn/constants_har"
import { hsLog } from "@learn/logger_har"
import { YWResColor } from "@learn/res_har"
import { ywDebugGlobal } from "../../core/DebugGlobal"

@Builder
export function testNodeBuilder() {
  NavDestination() {
    TextNodePage()
  }
  // .hideTitleBar(true)
  .onBackPressed(() => {
    ywDebugGlobal.getMainNav().pop(true)
    return true
  })
}

@Entry
export struct TextNodePage {
  @Watch('testStateChange')
  @State testState: TestUIState = new TestUIState()
  private listNodeMap: Map<string, MyNodeController> = new Map()

  private oneNodeController: MyNodeController = new MyNodeController()
  //Node更新数据，不需要@state, 关联数据，需要更新的时候触发rebuild()即可
  private oneParams:TextParams =  new TextParams("text", "one", "desc---one")
  aboutToAppear(): void {

    let list: Array<TextParams> = new Array()
    for (let i = 0; i < 3; i++) {
      if (i == 0) {
        let params = new TextParams("text", "aaa", "desc---aaa")
        list.push(params)

        let textNodeCtrl = new MyNodeController()
        textNodeCtrl.setWrapBuilder(textViewComponent)
        textNodeCtrl.updateParams(params)
        this.listNodeMap.set("text", textNodeCtrl)

      } else if (i == 1) {
        let params = new TextParams("video", "bbb", "desc---bbb")
        list.push(params)

        let textNodeCtrl = new MyNodeController()
        textNodeCtrl.setWrapBuilder(textViewComponent)
        textNodeCtrl.updateParams(params)
        this.listNodeMap.set("video", textNodeCtrl)

      } else if (i == 2) {
        let params = new TextParams("image", "ccc", "desc---ccc")
        list.push(params)

        let textNodeCtrl = new MyNodeController()
        textNodeCtrl.setWrapBuilder(textViewComponent)
        textNodeCtrl.updateParams(params)
        this.listNodeMap.set("image", textNodeCtrl)
      }
    }
    this.testState.list = list

    this.oneNodeController.updateParams(this.oneParams)


    setTimeout(() => {
      let list = this.testState.list
      let fistItem = list[0]
      fistItem.name = "aaa--new"
      // this.testState.list = list

      let testList: Array<TextParams> = new Array()
      testList.push(...list)
      this.testState.list = testList
    }, 3000)


  }

  testStateChange() {

    for (let item of this.testState.list) {
      if (this.listNodeMap.has(item.type)) {
        let nodeCtrl = this.listNodeMap.get(item.type)
        nodeCtrl?.updateParams(item)
      }
    }
  }

  updateData() {
    let list = this.testState.list
    let fistItem = list[1]
    fistItem.name = "bbb--new"
    // this.testState.list = list

    let testList: Array<TextParams> = new Array()
    testList.push(...list)
    this.testState.list = testList
  }

  updateOneNodeData() {
    this.oneParams.name = "one -- update"
    this.oneNodeController.updateParams(this.oneParams)

  }

  @Builder
  nodeView(params: TextParams) {
    if (this.listNodeMap.has(params.type)) {
      NodeContainer(this.listNodeMap.get(params.type))
    }
  }

  build() {
    Row() {
      Column({space:20}) {
        Text("测试Node")
        ForEach(this.testState.list, (item: TextParams, key) => {
          this.nodeView(item)
        })

        Divider().height(12)
        NodeContainer(this.oneNodeController)
        Button("数据更新")
          .onClick(() => {
            this.updateData()
          })

        Button("数据更新 --one")
          .onClick(() => {
            this.updateOneNodeData()
          })
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .width('100%')
      .height('100%')

    }
    .width('100%')
    .height('100%')
  }
}

@Observed
export class TestUIState {
  list: Array<TextParams> = new Array()
  isShowTab: boolean = true
  isShowTitleBar: boolean = false
}

@Observed
class TextParams {
  type: string
  name: string
  desc: string

  constructor(type: string, name: string, desc: string) {
    this.type = type
    this.name = name
    this.desc = desc
  }
}

@Builder
function TextBuilder(params: TextParams) {
  Text("##:" + params.type + " $$ " + params.name + " ** " + params.desc)
    .backgroundColor(YWConstants.RandomColor())
}


//// ============= NodeController ============== ////

class MyNodeController extends NodeController {
  private rootNode: BuilderNode<[TextParams]> | null = null
  private currentNode: FrameNode | null = null
  //如果有多种类型，可以设置成集合
  private wrapBuilder: WrappedBuilder<[TextParams]> = wrapBuilder(TextBuilder)
  private params?: TextParams

  setWrapBuilder(wrap:WrappedBuilder<[TextParams]>) {
    this.wrapBuilder = wrap
  }

  updateParams(params: TextParams) {
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

  // makeNode(uiContext: UIContext): FrameNode | null {
  //   if (!this.params) {
  //     return null
  //   }
  //   if (this.rootNode == null) {
  //     this.rootNode = new BuilderNode(uiContext);
  //     this.rootNode.build(this.wrapBuilder, this.params)
  //   } else {
  //     let parent = this.rootNode.getFrameNode()?.getParent()
  //     if (parent) {
  //       //移除当前这个node
  //       parent.removeChild(this.rootNode.getFrameNode())
  //       parent = null //这个会把 所以其他也移除
  //     }
  //     this.rootNode.build(this.wrapBuilder, this.params)
  //   }
  //   return this.rootNode.getFrameNode()!;
  // }

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
const TAG = "TextViewComponent"
@Component
struct TextViewComponent {
  @Require
  params?: TextParams

  @Builder
  TextBuilder(params?: TextParams) {
    if (params) {
      Column(){
        Blank().height(12)
        Text("component: ##:" + params.type + " $$ " + params.name + " ** " + params.desc)
          .backgroundColor(YWConstants.RandomColor())
      }

    }
  }

  aboutToAppear(): void {
    hsLog.i(TAG,"aboutToAppear")
  }
  aboutToDisappear(): void {
    hsLog.i(TAG,"aboutToDisappear")
  }

  build() {
    this.TextBuilder(this.params)
  }
}


@Builder
function TextViewBuilder(params: TextParams) {
  TextViewComponent({params:params})
  // Text("##:" + params.type + " $$ " + params.name + " ** " + params.desc)
  //   .backgroundColor(YWConstants.RandomColor())
}

export let textViewComponent = wrapBuilder(TextViewBuilder)