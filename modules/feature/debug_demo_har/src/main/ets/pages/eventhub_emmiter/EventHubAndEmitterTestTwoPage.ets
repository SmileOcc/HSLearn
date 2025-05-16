
@Builder
export function TestEventBuilder() {

  NavDestination() {
    TestEventHubAndEmmiterTwoViewPage()
  }
  .hideTitleBar(true)

}

const TAG = "TestEventHubAndEmmiterTwoViewPage"

@Entry
@Component
struct TestEventHubAndEmmiterTwoViewPage {

  build() {
    Column(){
      Text("数据回传")
      Button("发送").onClick(()=>{
        getContext().eventHub.emit("CALLAA", "传递一个数据:" + "数据回传")

      })
    }
  }
}