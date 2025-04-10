interface TestInfoInterFace {
  name: string;
  items: TestItem[];
}

// TODO 问题1：多层级时，需要逐个层级进行类监听
@Observed
class TestItem {
  content: string = "";
  isClicked: boolean = false;

  constructor(content: string, isClicked: boolean) {
    this.content = content;
    this.isClicked = isClicked;
  }
}

@Observed
class TestInfo {
  name: string;
  items: TestItem[];

  constructor(name: string, items: TestItem[]) {
    this.name = name;
    this.items = items;
  }
}

@Builder
export function TestObservedBuilder() {

  NavDestination() {
    TestObservedPage()
  }

  // .onBackPressed(()=>{
  //   ywDebugGlobal.getMainNav().pop(true)
  //   return true
  // })

}

@Entry
@Component
struct TestObservedPage {
  // TODO 问题3 每个被设置Observed的对象，需要new出来创建，才能激活监听，花括号的形式赋值，并不会激活监听。
  @State mTestDataArr: TestInfo[] = [
    new TestInfo('测试数据1', [new TestItem('单元数据1', false), new TestItem('单元数据2', false)]),
    new TestInfo('测试数据2', [new TestItem('单元数据1', false), new TestItem('单元数据2', false)]),
    new TestInfo('测试数据3', [new TestItem('单元数据1', false), new TestItem('单元数据2', false)]),
  //   new TestInfo('测试数据1', [{
  //     content: '单元数据1',
  //     isClicked: false
  //   }, {
  //     content: '单元数据1',
  //     isClicked: false
  //   }]),
  //   new TestInfo('测试数据2', [{
  //     content: '单元数据1',
  //     isClicked: false
  //   }, {
  //     content: '单元数据1',
  //     isClicked: false
  //   }]),
  //   new TestInfo('测试数据3', [{
  //     content: '单元数据1',
  //     isClicked: false
  //   }, {
  //     content: '单元数据1',
  //     isClicked: false
  //   }]),
  ]

  build() {
    Column() {
      ForEach(this.mTestDataArr, (item: TestInfoInterFace) => {
        ChildView({
          mTestInfo: item
        })
      })
    }
    .width('100%')
    .height('100%')
  }
}

@Component
export struct ChildView {
  private TAG: string = "TestPage";
  @ObjectLink mTestInfo: TestInfo

  build() {
    Column() {
      Text(this.mTestInfo.name)
        .backgroundColor(Color.Red)
        .fontSize(px2fp(52))

      // TODO 多层级时，需要逐个层级进行剥离，创建子组件和绑定双向监听。
      // ForEach(this.mTestInfo.items, (tempInfo: TestItem) => {
      //   Text(tempInfo.content)
      //     .fontSize(px2fp(52))
      //     .backgroundColor(tempInfo.isClicked ? Color.Blue : Color.Yellow)
      //     .onClick(() => {
      //       tempInfo.isClicked = !tempInfo.isClicked
      //       console.log(this.TAG, JSON.stringify(tempInfo))
      //     })
      // })

      ForEach(this.mTestInfo.items, (tempInfo: TestItem) => {
        ItemView({
          mItem: tempInfo
        }).margin({
          top: px2vp(100)
        })
      })

      Divider()
    }
  }
}

@Component
export struct ItemView {
  private TAG: string = "TestPage";
  @ObjectLink mItem: TestItem

  build() {
    Text(this.mItem.content)
      .fontSize(px2fp(52))
      .backgroundColor(this.mItem.isClicked ? Color.Blue : Color.Yellow)
      .onClick(() => {
        this.mItem.isClicked = !this.mItem.isClicked
        console.log(this.TAG, JSON.stringify(this.mItem))
      })
  }
}
