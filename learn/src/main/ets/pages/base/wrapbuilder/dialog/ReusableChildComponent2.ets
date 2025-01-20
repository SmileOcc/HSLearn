
@Component
export struct ReusableChildComponent2 {
  @Prop text: string = "false";

  aboutToReuse(params: Record<string, object>) {
    console.log("ReusableChildComponent2 Reusable " + JSON.stringify(params));
  }

  aboutToRecycle(): void {
    console.log("ReusableChildComponent2 aboutToRecycle " + this.text);
  }

  build() {
    Column() {
      Text(this.text)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 36 })
    }.backgroundColor('#FFF0F0F0')
  }
}