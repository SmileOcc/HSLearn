// ------------- NavigationCase1 : tab页面1 --------------
@Component
struct NavigationCase1 {
  @Consume navStack: NavPathStack

  build() {
    Column() {
      Text('tab1')
      Button('跳转NavDestination1').onClick((event: ClickEvent) => {
        this.navStack.pushPath({
          name: 'NavDestination1'
        })
      })
    }
  }
}

export default NavigationCase1
