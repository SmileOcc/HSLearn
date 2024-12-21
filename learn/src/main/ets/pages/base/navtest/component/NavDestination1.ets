
// -----------跳转页面1 -----------------

@Component
struct NavDestination1 {
  @Consume navStack: NavPathStack

  build() {
    NavDestination() {
      Column() {
        Text('页面1')
        Button('跳转NavDestination2').onClick(() => {
          const param: Record<string, string> = {
            'dec': '跳转NavDestination2'
          }
          this.navStack.pushPath({
            name: 'NavDestination2',
            param
          })
        })
      }
    }.title('页面1')
  }
}

export default NavDestination1

