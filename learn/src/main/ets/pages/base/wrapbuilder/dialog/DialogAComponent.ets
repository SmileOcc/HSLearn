import { hsLog } from '@learn/logger_har'
import { info, testParams, TTParams } from './TestWrapBuilderDialog'

@Component
export struct DialogAComponent {

  //需要内容更新，需要用prop
  @Prop @Watch("dataChange") dataInfo:testParams = {title:"123",info: {text:'abb',desc:"yyy"}}
  @Prop @Watch("dataChange") data:TTParams = new TTParams("mmmm")

  aboutToReuse(params: Record<string, object>) {
    console.log("ReusableChildComponent2 Reusable " + JSON.stringify(this.data));
  }

  aboutToRecycle(): void {
    console.log("ReusableChildComponent2 aboutToRecycle " + this.data.text);
  }

  dataChange() {
    let aaa = ""
    hsLog.i("=======DialogAComponent  dataChange")
  }

  updateee(data:testParams) {
    this.dataInfo = data
  }

  build() {
    Column() {
      Text(this.dataInfo.info?.text)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .margin({bottom: 36})
      Text(this.dataInfo.title)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .margin({bottom: 36})
      Text(this.data.text)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .margin({bottom: 36})

    }.backgroundColor('#FFF0F0F0')
  }
}