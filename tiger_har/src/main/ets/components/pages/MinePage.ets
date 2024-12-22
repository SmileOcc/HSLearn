import { hsLog } from '@learn/logger_har';

@Component
export struct MinePage {
  @Consume('navStack') navStack: NavPathStack

  build() {
    Column() {
      NavDestination() {
        Text('这是我的').fontSize(35)

        Button('返回--》给点数据')
          .onClick(() => {
            const record: Record<string, Object> = {
              'from': 'login/login',
              'text': "登录给你的",
              'age': 19,
            }
            this.navStack.pop(record)//返回结果，record可以是object
          })

        Button('返回- about')
          .onClick(() => {
            const record: Record<string, Object> = {
              'from': 'login/login',
              'text': "登录给你的",
              'age': 19,
            }
            const navPath: NavPathInfo = new NavPathInfo('AboutPage', undefined);

            this.navStack.pushPath(navPath,record)//返回结果，record可以是object
          })

        // .width('100%')
        // .height('100%')
      }
      .mode(NavDestinationMode.STANDARD)
      .hideTitleBar(true)
      .onBackPressed(()=>{
        this.onBackPress()
        return true
      })
      .onShown(()=>{
        hsLog.i("======= onShown")

      })
      .onHidden(()=>{
        hsLog.i("======= onHidden")

      })
      .onWillAppear(()=>{
        hsLog.i("======= onWillAppear")

      })
      .onDisAppear(()=>{
        hsLog.i("======= onDisAppear")

      })
      .onAppear(()=>{
        hsLog.i("======= onAppear")

      })
    }
    .width('100%')
    .height('100%')
  }

  onBackPress(): boolean | void {

    let size = this.navStack.size()
    let allPages = this.navStack.getAllPathName()

    if (this.navStack.size() > 0) {
      this.navStack.pop(true)
    }
  }

  aboutToAppear(): void {
    hsLog.i("======= aboutToAppear")
  }

  aboutToDisappear(): void {
    // this.appContext.
    hsLog.i("======= aboutToDisappear")

  }

  onPageShow(): void {
    hsLog.i("======= onPageShow")

  }
  onPageHide(): void {
    hsLog.i("======= onPageHide")

  }
}
