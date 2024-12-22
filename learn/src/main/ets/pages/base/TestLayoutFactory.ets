import { hsLog } from '@learn/logger_har';
export interface TestLayoutFactory {
  testEvent():void
}

export class PhoneLayoutFactor implements TestLayoutFactory {
  testEvent(): void {
    hsLog.d('PhoneLayoutFactor')

  }
}

export class TabletLayoutFactor implements TestLayoutFactory {
  testEvent(): void {
    hsLog.d('TabletLayoutFactor')
  }

}