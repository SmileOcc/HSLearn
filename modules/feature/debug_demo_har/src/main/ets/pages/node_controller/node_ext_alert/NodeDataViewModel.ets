import { NodeViewModel } from "./NodeViewModel";

export class NodeDataViewModel extends NodeViewModel {
  data?: object
  context?: object | undefined
  constructor(context?: object, userSession?: object) {
    super(false,context,userSession);
  }
}