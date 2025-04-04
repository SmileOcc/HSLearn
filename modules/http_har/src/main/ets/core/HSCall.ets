import { HSRequest } from "./HSRequest";
import { HSResponse } from "./HSResponse";

export interface HSCall {
  execute():Promise<HSResponse>
  getRequest():HSRequest
}