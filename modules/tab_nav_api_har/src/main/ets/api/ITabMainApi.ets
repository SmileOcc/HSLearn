import { ITabComponentDelegate } from "../delegate/ITabComponentDelegate";

export interface ITabMainApi {
  getTabComponent():WrappedBuilder<[ITabComponentDelegate]>
}