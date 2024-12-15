@Entry
@Component
struct TestTabBarPage {
  @State message: string = 'Hello World';
  @State currentIndex: number = 0 // 默认为0，代表默认让第一个导航高亮

  build() {
    Tabs({ barPosition: BarPosition.End, index: $$this.currentIndex}) {
      TabContent() {
        // ...
      }.tabBar(this.tabBuilder('首页', $r('app.media.tab_new'),$r('app.media.tab_new_select'),0))

      TabContent() {
        // ...
      }.tabBar(this.tabBuilder('信息', $r('app.media.tab_new'),$r('app.media.tab_new_select'),1))

      TabContent() {
        // ...
      }.tabBar(this.tabBuilder('相册', $r('app.media.tab_new'),$r('app.media.tab_new_select'),2))

      TabContent() {
        // ...
      }.tabBar(this.tabBuilder('我的', $r('app.media.tab_new'),$r('app.media.tab_new_select'),3))
    }
    // .onChange(index => {
    //   this.currentIndex = index
    // })

    // 以上利用onChange可以实现以外，其实在Next加入$$双向绑定后也能实现，
    // 做法是，只要将currentIndex与Tabs的index参数做双向绑定即可实现，代码如下
    // Tabs({ barPosition: BarPosition.End, index: $$this.currentIndex }) {
    //   // 省略里面内容
    // }
  }

  @Builder
  tabBuilder(title: string, icon: ResourceStr, selectIcon: ResourceStr, index: number) {
    Column({ space: 2 }) {
      Image(this.currentIndex === index ? selectIcon : icon)
        .width(30)
        .fillColor(this.currentIndex === index ? '#0094ff' : '#000')
      Text(title)
        .fontColor(this.currentIndex === index ? '#0094ff' : '#000')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }


}