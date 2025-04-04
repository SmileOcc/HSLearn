import { HSIntercept } from "./HSIntercept";
import { HSRequest } from "./HSRequest";
import { HSRealCall } from "./imp/HSRealCall";

export class HSHttpClient {
  private intercepts:Array<HSIntercept> = new Array()
  private timeout:number | undefined

  constructor(intercepts:Array<HSIntercept>,timeout?:number) {
    this.timeout = timeout
    this.intercepts = intercepts
  }

  newCall(request:HSRequest) {
    return new HSRealCall(this,request,this.intercepts)
  }

  getIntercepts():Array<HSIntercept> {
    const res:Array<HSIntercept> = new Array<HSIntercept>()
    res.push(...this.intercepts)
    return res
  }

  getTimeout() {
    return this.timeout
  }
}

export class HSHttpClientBuilder {
  private intercepts:Array<HSIntercept> = new Array()
  private timeout:number | undefined

  constructor(builder?:HSHttpClientBuilder) {
    this.intercepts = builder?.intercepts ?? new Array()
    this.timeout = builder?.timeout
  }

  setTimeout(number:number) {
    this.timeout = number
  }

  addIntercepts(inter:HSIntercept) {
    this.intercepts.push(inter)
  }

  getTimeout() {
    return this.timeout
  }
  getIntercepts() {
    return this.intercepts
  }

  build() {
    return new HSHttpClient(this.getIntercepts(),this.getTimeout())
  }
}