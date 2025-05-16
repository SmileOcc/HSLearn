@Component
export struct EventHubTestView {
  @State num: number = 0


  aboutToAppear(): void {
    this.num = 2
  }

  build() {
    Button("组件传递数据")
      .onClick(() => {
        this.num++
        getContext().eventHub.emit("CALLAA", "传递一个数据:" + this.num)
      })
  }
}