import { IUState } from './IUState'

abstract class YWBaseModel<T extends IUState> {
  abstract iuState: IUState
}

export default YWBaseModel