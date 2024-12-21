import { NavRouterPage } from '@learn/nav_router_har';

export { MainPage } from './src/main/ets/components/MainPage'

// 动态import时需要调用的接口，接口名请使用harInit，用于动态加载页面
export function harInit(pageName: string) {
  switch (pageName) {
    case NavRouterPage.LOGIN.pageName:
      import('./src/main/ets/components/YWLoginPage');
      //当import后，就会执行 RouterNav.registerPage(RouterPage.LOGIN, wrapBuilder(getPage)) ，从而添加到路由管理中
      break;
  }
}

export { loginService } from './src/main/ets/core/YWLoginService'