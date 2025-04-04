// 使用NodeController的Page页
import { getPreNodeWeb } from './PreNodeWebNodeController'


@Entry
@Component
struct TestPreNodeWebPage {
  build() {
    Row() {
      Column() {
        // NodeContainer用于与NodeController节点绑定，rebuild会触发makeNode
        // Page页通过NodeContainer接口绑定NodeController，实现动态组件页面显示
        NodeContainer(getPreNodeWeb('https://www.example.com'))
          .height('90%')
          .width('100%')
      }
      .width('100%')
    }
    .height('100%')
  }
}
