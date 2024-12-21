import NavDestination1 from './component/NavDestination1'
import NavDestination2 from './component/NavDestination2'
import NavigationCase1 from './component/NavigationCase1'
import NavigationCase2 from './component/NavigationCase2'

@Entry
@Component
struct TestNavigationDestionationPage {
  @State activeName: string = 'tab1'

  aboutToAppear(): void {
    // size: 获取页面栈大小
    this.navStack.size()
    // 获取栈中所有页面name集合
    // 获取【栈中】所有NavDestination页面的名称。
    this.navStack.getAllPathName()
    // 获取【指定index】的NavDestination页面的参数信息。
    // this.navStack.getParamByIndex(0)
    // 获取全部name为PageOne的NavDestination页面的参数信息。
    this.navStack.getParamByName("PageOne")
    // 获取全部name为PageOne的NavDestination页面的位置索引。
    this.navStack.getIndexByName("PageOne")



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



  // tabs
  @Builder
  tabBarBuilder() {
    Row() {
      ForEach(['tab1', 'tab2', 'tab3'], (item: string) => {
        Column() {
          Image($r('app.media.receive_payment')).width(24).aspectRatio(1)
          Text(item).fontColor(this.activeName === item ? '#ff00ff0f' : '#000')
        }.onClick(() => {
          this.activeName = item
        })
      })
    }.width('100%').justifyContent(FlexAlign.SpaceAround)
  }

  // 标题
  @Builder
  titleBuilder() {
    Row() {
      Text('title').fontWeight(700)
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  // 顶部icon
  @Builder
  NavigationMenus() {
    Row() {
      Image($r('app.media.tab_new'))
        .width(24).aspectRatio(1)
      Image($r('app.media.tab_new_select'))
        .width(24)
        .height(24)
      Image($r('app.media.startIcon'))
        .width(24)
        .height(24)
    }.width('100%').justifyContent(FlexAlign.SpaceAround)
  }

  // 路由容器
  @Builder
  navDestination(name: string) {
    if (name === 'NavDestination2') {
      NavDestination2()
    } else if (name === 'NavDestination1') {
      NavDestination1()
    }
  }

  //路由栈, (控制跳转）
  @Provide
  navStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.navStack) {
      if (this.activeName === 'tab1') {
        NavigationCase1()
      } else if (this.activeName === 'tab2') {
        NavigationCase2()
      } else {
        Text('123')
      }
    }
    .height('100%')
    .width('100%')
    // .toolbarConfiguration(this.tabBarBuilder) // 设置tabBar
    .navDestination(this.navDestination) // 设置路由容器
    .title(this.titleBuilder, {
      backgroundColor: Color.Blue,
    }) // 设置标题
    .titleMode(NavigationTitleMode.Full) // 标题模式
    .menus(this.NavigationMenus) // 顶部图标
    .hideTitleBar(false) // 是否隐藏标题栏
    .hideNavBar(false) // 是否隐藏导航栏, 隐藏Navigation的导航栏，包括标题栏、内容区和工具栏。
    .backgroundColor(Color.Pink)
  }

}

// 普通跳转
//
// 普通跳转，通过页面的name去跳转，并可以携带param。
//
// this.pageStack.pushPath({ name: "PageOne", param: "PageOne Param" })
// this.pageStack.pushPathByName("PageOne", "PageOne Param")



// 带返回回调的跳转，跳转时添加onPop回调，能在页面出栈时获取返回信息，并进行处理。
// this.pageStack.pushPathByName('PageOne', "PageOne Param", (popInfo) => {
//   console.log('Pop page name is: ' + popInfo.info.name + ', result: ' + JSON.stringify(popInfo.result))
// });

// 带错误码的跳转，跳转结束会触发异步回调，返回错误码信息。
//
// this.pageStack.pushDestinationByName('PageOne', "PageOne Param")
//   .catch((error: BusinessError) => {
//     console.error(`Push destination failed, error code = ${error.code}, error.message = ${error.message}.`);
//   }).then(() => {
//   console.error('Push destination succeed.');
// });
