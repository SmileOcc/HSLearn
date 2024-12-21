
@Component
export struct LaunchLoadingView {

  // @Link isSplashPage: boolean; //双向绑定
  @State num: number = 1;

  eventClick?:()=>void

  private timerId: number = 0;


  private gotoHome() {
    // this.isSplashPage = false
    this.eventClick?.()
  }

  aboutToAppear(): void {
    // this.timerId = setInterval(() => { //定时器
    //   if (this.num === 4) {
    //     clearInterval(this.timerId);
    //     this.gotoHome();
    //   }
    //   this.num += 1;
    // }, 500)
  }

  build() {
    Column(){
      Text("启动中...")
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}