import { YWShowToast } from '@learn/common_har'


// -----------跳转页面2 -----------------

@Component
struct NavDestination2 {
  @Consume navStack: NavPathStack

  aboutToAppear(): void {
    YWShowToast(JSON.stringify(this.navStack.getParamByName('NavDestination2')))
  }

  build() {
    NavDestination() {
      Column() {
        Text('页面2')
      }
    }.title('页面2').hideTitleBar(true)

  }
}

export default NavDestination2
