
export class AppContextLifeCycle {
  private context?:Context

  init(context:Context) {
    this.context = context
  }
}

export const appContextLifeInstance = new AppContextLifeCycle()