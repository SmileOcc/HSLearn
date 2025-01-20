
//懒加载
export class YWLazy<T> {
  private instance?:T
  private instanceFunc:()=>T

  constructor(value:()=>T) {
    this.instanceFunc = value
  }

  public get value():T {
    if (this.instance == null) {
      this.instance = this.instanceFunc()
    }
    return this.instance
  }

}