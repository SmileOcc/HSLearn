import { HSChain } from "./HSChain";
import { HSResponse } from "./HSResponse";

export interface HSIntercept {
  intercept(request:HSChain):Promise<HSResponse>
}