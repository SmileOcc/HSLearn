import { HSCall } from "./HSCall";
import { HSHttpClient } from "./HSHttpClient";
import { HSIntercept } from "./HSIntercept";
import { HSRequest } from "./HSRequest";
import { HSResponse } from "./HSResponse";

export interface HSChain {
  progress(request:HSRequest):Promise<HSResponse>
  getCall():HSCall
  getRequest():HSRequest
  getTimeout():number | undefined
}