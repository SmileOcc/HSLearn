import { OsRouterUrls } from '@learn/common_har/Index';
import { ITigerAppContext } from '../../core/ITigerAppContext';
import { ILaunchListener, ILaunchServer } from '../../core/launchexecute/ILaunchServer';
import { LaunchStepState } from '../../core/launchexecute/LaunchStepState';
import { TigerServerType } from '../../core/launchexecute/TigerServerType';
import { TigerGlobalThis } from '../../core/TigerGlobalThis';
import { LaunchLoadingView } from '../loading/LaunchLoadingView';
import { MainUIState, MainViewModel } from './RootViewModel';
import { promptAction } from '@kit.ArkUI';
import { MainPage } from "../mainpage/MainPage";
import { CategoryPage } from '../pages/CategoryPage';
import { AboutPage } from '../pages/AboutPage';
import { hsLog } from '@learn/logger_har';
import { tigerMainTabBuilder } from './MainTabPage';

export const TigerRootBuilder = wrapBuilder(rootBuilder)

@Builder function rootBuilder(name:string, params:Map<string,Object>) {
  NavDestination(){
    RootPage()
  }
    .hideTitleBar(true)
}

@Entry({routeName:OsRouterUrls.TIGER_APP})
@Component
export struct RootPage {
  @State message: string = 'Hello Tiger';

  private appContext: ITigerAppContext = TigerGlobalThis.getInstance().getAppContext()

  private viewModel:MainViewModel = new MainViewModel(this.appContext)

  @State iuState: MainUIState = this.viewModel.iuState

  @State selectIndex:number = 0

  @State @Watch('onSplashPageFinish') isSplashPage: boolean = true;

  onSplashPageFinish() {
    //启动页结束后进行操作，如请求网络等
  }

  aboutToAppear(): void {

    let appId = "tigerAppID"
    let context = this.getUIContext()
    TigerGlobalThis.initContext(context,appId)

    // this.iuState.isShowTab = true

    setTimeout(()=>{
      this.viewModel.showErrorAlert()
    },4000)
  }

  textPush() {
    TigerGlobalThis.getRootStack().pushPath({name:""},{launchMode:LaunchMode.MOVE_TO_TOP_SINGLETON})
  }

  aboutToDisappear(): void {
    // this.appContext.
    // this.iuState.isShowTab = false

  }

  @Builder
  rightMenuView(){
    Row(){
      Button('去关于我的页面')
        .onClick(() => {
          this.goAbout()
        })
    }
    .backgroundColor(Color.Yellow)
    .width(100)
    .height(50)
    .position({ x: 200, y: 40 })
  }

  //二级页面通过：@Consume('navStack') navStack: NavPathStack  获取到路由管理进行页面跳转
  //路由栈, (控制跳转）
  // @Provide('navStack')
  // navStack: NavPathStack = new NavPathStack()

  // 路由容器
  @Builder
  navDestination(name: string, params?: object) {
    if (name === 'cate') {
      CategoryPage()
    } else if (name === 'NavDestination1') {
      CategoryPage()
    }
    if (name === 'AboutPage') {
      AboutPage()
    }
  }

  build() {
    Stack(){
      Navigation(TigerGlobalThis.getRootStack()) {
        if (this.iuState.isLoading) {
          LaunchLoadingView()
        } else {
          tigerMainTabBuilder("",new Map())
        }
      }
      .height('100%')
      .width('100%')
      // .toolbarConfiguration(this.tabBarBuilder) // 设置tabBar
      .navDestination(this.navDestination) // 设置路由容器
      .mode(NavigationMode.Stack)
      // .title(this.titleBuilder, {
      //   backgroundColor: Color.Blue,
      // }) // 设置标题
      .titleMode(NavigationTitleMode.Full) // 标题模式
      // .menus(this.NavigationMenus) // 顶部图标
      .hideTitleBar(!this.iuState.isShowTitleBar) // 是否隐藏标题栏
      .hideNavBar(!this.iuState.isShowTab) // 是否隐藏导航栏, 隐藏Navigation的导航栏，包括标题栏、内容区和工具栏。
      .backgroundColor(Color.Pink)
      .onAppear(()=>{
        hsLog.i("======= aboutToAppear")
        // this.iuState.isShowTab = true

      })
      // .animation()
      .onDisAppear(()=>{
        hsLog.i("======= aboutToAppear")
        // this.iuState.isShowTab = false
      })

      // NodeContainer(this.viewModel.getMainNodeControl())
      //   .id('nodeContainer')
      //   .onClick(() => {
      //     promptAction.showToast({ message: '哎呦' })
      //   })

      this.rightMenuView()
    }

  }



  onBackPress(): boolean | void {

    // let size = this.navStack.size()
    // let allPages = this.navStack.getAllPathName()
    //
    // if (this.navStack.size() > 0) {
    //   this.navStack.pop(true)
    // }

    // size: 获取页面栈大小
    // this.navStack.size()
    // // 获取栈中所有页面name集合
    // // 获取【栈中】所有NavDestination页面的名称。
    // this.navStack.getAllPathName()
    // // 获取【指定index】的NavDestination页面的参数信息。
    // // this.navStack.getParamByIndex(0)
    // // 获取全部name为PageOne的NavDestination页面的参数信息。
    // this.navStack.getParamByName("PageOne")
    // // 获取全部name为PageOne的NavDestination页面的位置索引。
    // this.navStack.getIndexByName("PageOne")



    // // 返回到上一页
    // this.navStack.pop()
    // this.navStack.removeByIndexes([this.navStack.size-1])
    // // 返回到上一个PageOne页面
    // this.navStack.popToName("PageOne")
    // // 返回到索引为1的页面
    // this.navStack.popToIndex(1)
    // // 返回到根首页（清除栈中所有页面）
    // this.navStack.clear()
    //
    // // 将栈顶页面替换为PageOne
    // this.navStack.replacePath({ name: "PageOne", param: "PageOne Param" })
    // this.navStack.replacePathByName("PageOne", "PageOne Param")
    //
    // // 删除栈中name为PageOne的所有页面
    // this.navStack.removeByName("PageOne")
    // // 删除指定索引的页面
    // this.navStack.removeByIndexes([1,3,5])
  }



  goAbout(){
    const navPath: NavPathInfo = new NavPathInfo('AboutPage', undefined);
    TigerGlobalThis.getRootStack().pushPath(navPath)
    // this.navStack.pushPath(navPath);
    // this.iuState.isShowTab = false
  }



  // tab是基础组件，无生命周期回调。目前推荐的是，使用tab来进行组件级别的切换。如果涉及页面的切换和跳转，或需要使用页面级别的生命周期，建议使用Navigation

  // Navigation当前支持的生命周期函数：aboutToAppear->onReady->onAppear->onShow->onHide->onDisappear->aboutToDisappear;
  // aboutToAppear: 自定义组件析构销毁之前执行
  // onReady: 当NavDestination即将构建子组件之前会触发此回调。
  // onAppear: 组件挂载显示时触发此回调。
  // onShow: 当该NavDestination页面显示时触发此回调。
  // onHide: 当该NavDestination页面隐藏时触发此回调。
  // onDisappear: 组件卸载消失时触发此回调。
  // aboutToDisappear: 在自定义组件析构销毁之前执行.
  // onPageShow、onPageHide、onBackPress等生命周期回调函数，仅对@Entry装饰的自定义组件生效。

}
