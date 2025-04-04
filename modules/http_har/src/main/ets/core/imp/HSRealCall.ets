import { HSCall } from "../HSCall";
import { HSHttpClient } from "../HSHttpClient";
import { HSIntercept } from "../HSIntercept";
import { HSRequest } from "../HSRequest";
import { HSResponse } from "../HSResponse";
import { HSCallInterceptChain } from "./HSCallInterceptChain";

export class HSRealCall implements HSCall {

  private httpClient:HSHttpClient
  private request:HSRequest
  private inters?:Array<HSIntercept>

  constructor(client:HSHttpClient,request:HSRequest,inters?:Array<HSIntercept>) {
    this.httpClient = client
    this.request = request
    this.inters = inters
  }


  execute(): Promise<HSResponse> {
    let inters:HSIntercept[] = []
    if (this.inters != undefined) {
      inters.push(...this.inters)
    }
    inters.push(...this.httpClient.getIntercepts())

    const chain = new HSCallInterceptChain(
      this,
      this.httpClient,
      this.request,
      0,
      inters,this.
      httpClient.getTimeout())
    return chain.progress(this.request)
  }

  getRequest(): HSRequest {
    return this.request
  }

}