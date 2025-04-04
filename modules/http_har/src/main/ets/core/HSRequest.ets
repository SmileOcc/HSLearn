import { HSMethod } from "./HSMethod"
import { HashMap } from "@kit.ArkTS"

export class HSRequest {
  readonly url:string
  readonly method:HSMethod
  readonly headers:HashMap<string,string>
  readonly userHeaders:Array<HSUserHeader>
  readonly body:HashMap<string,object>
  readonly bodyRaw?:object

  constructor(builder: HSRequestBuilder) {
    if (builder.getUrl() === undefined) {
      throw Error("HSRequest url is undefined")
    }
    this.url = builder.getUrl()!
    this.method = builder.getMethod()
    this.headers = builder.getHeaders()
    this.userHeaders = builder.getUserHeaders()
    this.body = builder.getBody()
    this.bodyRaw = builder.getBodyRaw()
  }

  newBuilder() {
    return new HSRequestBuilder(this)
  }
}

export class HSRequestBuilder {
  private url?:string
  private method:HSMethod
  private headers:HashMap<string,string>
  private userHeaders:Array<HSUserHeader>
  private body:HashMap<string,object>
  private bodyRaw?:object

  constructor(request?: HSRequest) {
    this.url = request?.url ?? ""
    this.method = request?.method ?? HSMethod.POST
    this.headers = request?.headers ?? new HashMap()
    this.userHeaders = request?.userHeaders ?? new Array()
    this.body = request?.body ?? new HashMap()
    this.bodyRaw = request?.bodyRaw
  }

  getUrl(): string | undefined {
    return this.url
  }

  getMethod() {
    return this.method
  }

  getHeaders() {
    return this.headers
  }

  getUserHeaders() {
    return this.userHeaders
  }

  getBody() {
    return this.body
  }

  getBodyRaw() {
    return this.bodyRaw
  }

  build() {
    return new HSRequest(this)
  }
}

export interface HSUserHeader {
  key:string
  value:string
}