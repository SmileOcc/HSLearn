
import { YWRouterNav, NavRouterPage } from '@learn/nav_router_har';

//不需要 @Entry
@Component
export struct TestNavLoginPage {
  @State message: string = '这是登录页面, 有NavDestination';

  build() {
    NavDestination(){
      RelativeContainer() {
        Text(this.message)
          .id('TestNavLoginPageHelloWorld')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .height('100%')
      .width('100%')
    }
    .mode(NavDestinationMode.STANDARD)
    .hideTitleBar(true)

  }
}

@Builder
function getPage(_value: object): void {
  TestNavLoginPage()
}

//在import(xxx/LoginPage)是会执行
YWRouterNav.registerPage(NavRouterPage.LOGIN,wrapBuilder(getPage))