
class DebugGlobal {
  mainNav:NavPathStack = new NavPathStack()
  deContext?:UIContext

  // constructor(context:UIContext) {
  //   this.deContext = context
  // }

  init(context:UIContext) {
    this.deContext = context
  }



  getMainNav():NavPathStack {
    return this.mainNav
  }

}

export const  ywDebugGlobal = new DebugGlobal()