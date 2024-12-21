import { KLogger } from "@learn/common_har";

@Component
export struct AboutPage {
  @State message: string = 'Hello World';

  @Consume('navStack') navStack: NavPathStack
  build() {
    NavDestination() {
      Stack() {
        Text('这是关于我的页面').fontSize(35)

        Button('返回--》给点数据')
          .onClick(() => {
            const record: Record<string, Object> = {
              'from': 'login/login',
              'text': "登录给你的",
              'age': 19,
            }
            this.navStack.pop(record)//返回结果，record可以是object
          })

      }
      .width('100%')
      .height('100%')
    }
    .mode(NavDestinationMode.STANDARD)
    .hideTitleBar(true)
    .onBackPressed(()=>{
      this.onBackPress()
      return true
    })
    .onShown(()=>{
      KLogger.info("======= onShown")

    })
    .onHidden(()=>{
      KLogger.info("======= onHidden")

    })
    .onWillAppear(()=>{
      KLogger.info("======= onWillAppear")

    })
    .onDisAppear(()=>{
      KLogger.info("======= onDisAppear")

    })
    .onAppear(()=>{
      KLogger.info("======= onAppear")

    })
  }

  aboutToAppear(): void {
    KLogger.info("======= aboutToAppear")
  }

  aboutToDisappear(): void {
    // this.appContext.
    KLogger.info("======= aboutToDisappear")

  }

  onPageShow(): void {
    KLogger.info("======= onPageShow")

  }
  onPageHide(): void {
    KLogger.info("======= onPageHide")

  }

  onBackPress(): boolean | void {

    let size = this.navStack.size()
    let allPages = this.navStack.getAllPathName()

    if (this.navStack.size() > 0) {
      this.navStack.pop(true)
    }
  }
}
