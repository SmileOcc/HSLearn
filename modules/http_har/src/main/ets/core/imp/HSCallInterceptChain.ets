import { HSCall } from "../HSCall";
import { HSChain } from "../HSChain";
import { HSHttpClient } from "../HSHttpClient";
import { HSIntercept } from "../HSIntercept";
import { HSRequest } from "../HSRequest";
import { HSResponse } from "../HSResponse";
import { HSRealCall } from "./HSRealCall";

export class HSCallInterceptChain implements HSChain {

  private httpClient:HSHttpClient
  private request:HSRequest
  private call:HSRealCall
  private inters:HSIntercept[]
  private index:number
  private timeout?:number

  constructor(call:HSRealCall, client:HSHttpClient,request:HSRequest,index:number, inters:HSIntercept[],timeout?:number) {
    this.call = call
    this.httpClient = client
    this.request = request
    this.inters = inters
    this.timeout = timeout
    this.index = index
  }

  getRequest(): HSRequest {
    return this.request
  }


  progress(request:HSRequest):Promise<HSResponse> {

    if (this.index + 1 > this.inters.length - 1) {
      throw Error("request index over " + this.index)
    }

    const inter:HSIntercept = this.inters[this.index]

    const nextChain:HSCallInterceptChain = this.nextChain(this.index+1,request)
    return inter.intercept(nextChain)

  }

  getCall(): HSCall {
    return this.call
  }

  getTimeout(): number | undefined {
    return this.timeout
  }

  getIntercepts(): HSIntercept[] {
    return this.inters
  }

  getHttpClient(): HSHttpClient {
    return this.httpClient
  }

  nextChain(index:number, request:HSRequest) {
    return new HSCallInterceptChain(this.call, this.httpClient, request, index, this.inters, this.timeout)
  }

}