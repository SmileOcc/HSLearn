import { LengthMetrics, LengthUnit } from '@kit.ArkUI';

@ComponentV2
export struct AddressInputView {
  @Param componentId: string = '';
  @Param text: string = '';
  @Param contentType: ContentType | undefined = undefined;
  @Param label: ResourceStr | undefined = undefined;
  @Param index: number = -1;
  @Local scaleTimes: number = 1;
  @Local currentIndex: number = -1;
  @Local valueText: string =''

  aboutToAppear(): void {
    this.valueText = this.text
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      TextInput({ text: this.valueText })
        .id(this.componentId)
        .width('100%')
        .backgroundColor(Color.White)
        .contentType(this.contentType)
        .padding({ left: 12, top: 0, bottom: 0 })
        .selectionMenuHidden(true)
        .onChange((value: string) => {
          this.valueText = value;
          if (value === '') {
            this.scaleTimes = 1;
          } else {
            this.scaleTimes = 0.75;
          }
        })
        .onFocus(() => {
          this.scaleTimes = 0.75;
          this.currentIndex = this.index;
        })
        .onBlur(() => {
          if (this.valueText === '') {
            this.scaleTimes = 1;
          }
        })
      Text() {
        Span('*')
          .fontColor('#ff5000')
          .baselineOffset(new LengthMetrics(-2, LengthUnit.VP))
        Span(this.label)
          .baselineOffset(new LengthMetrics(0, LengthUnit.VP))
      }
      .scale(this.index === this.currentIndex || this.valueText !== '' ? {
        x: this.scaleTimes,
        y: this.scaleTimes,
        centerX: 0,
        centerY: -80
      } : {
        x: 1,
        y: 1,
        centerX: 0,
        centerY: -80
      })
      .animation({ duration: 200 })
      .height(this.index === this.currentIndex ? 24 : undefined)
      .width('100%')
      //自身和子节点都响应触摸测试，不会阻塞兄弟节点的触摸测试，不会影响祖先节点的触摸测试。
      .hitTestBehavior(HitTestMode.Transparent)
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .padding({ left: 12 })
    }
    .height(72)
  }
}