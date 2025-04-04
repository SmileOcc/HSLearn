import { HSMethod } from "./HSMethod";
import { HSRequest, HSUserHeader } from "./HSRequest";
import { HashMap } from "@kit.ArkTS";

export class HSResponse {
  private request:HSRequest
  private method:HSMethod
  private headers:HashMap<string,string>
  // private userHeaders:Array<HSUserHeader>
  private body:string
  private bodyRaw?:object

  constructor(builder: HSResponseBuilder) {
    if (builder.getRequest() === undefined) {
      throw Error("HSResponse request nil")
    }
    this.request = builder.getRequest()!
    this.method = builder.getMethod()
    this.headers = builder.getHeaders()
    this.body = builder.getBody()
  }

}

export class HSResponseBuilder {
  private request?:HSRequest
  private method:HSMethod
  private headers:HashMap<string,string>
  // private userHeaders:Array<HSUserHeader>
  private body:string
  private bodyRaw?:object

  constructor(request:HSRequest,method:HSMethod,headers:HashMap<string,string>,body:string) {
    this.request = request
    this.method = method
    this.headers = headers
    this.body = body
  }

  getRequest(): HSRequest | undefined {
    return this.request
  }

  getMethod() {
    return this.method
  }

  getHeaders() {
    return this.headers ?? new HashMap()
  }

  getBody() {
    return this.body
  }

  getBodyRaw(): object | undefined {
    return this.bodyRaw
  }

  build() {
    return new HSResponse(this)
  }
}