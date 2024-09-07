import Logger from '../../../../../../modules/common_har/src/main/ets/common/KLogger'

export interface TestLayoutFactory {
  testEvent():void
}

export class PhoneLayoutFactor implements TestLayoutFactory {
  testEvent(): void {
    Logger.debug('PhoneLayoutFactor')

  }
}

export class TabletLayoutFactor implements TestLayoutFactory {
  testEvent(): void {
    Logger.debug('TabletLayoutFactor')
  }

}