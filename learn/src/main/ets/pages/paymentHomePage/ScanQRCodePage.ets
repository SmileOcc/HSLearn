/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { customScan, scanBarcode, scanCore } from '@kit.ScanKit';
import { FunctionCard, ScanAbility } from './view/ScanQRCodeDialog';
import { Constants } from '../../../../../../modules/common_har/src/main/ets/common/Constants';
import deviceInfo from '@ohos.deviceInfo'; //设备信息

const aspectToHeightRatio = 4 / 3;

@Entry
@Component
struct ScanQRCodePage {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = '';
  @State cameraWidth: number = 1000 * aspectToHeightRatio;
  @State cameraHeight: number = 1000;
  @State currentIndex: number = 0;
  @State scanAbilities: string[] = Constants.SCAN_ABILITIES;
  @State marginTop:number =  -500;

  // 设备类型
  @State deviceType: string = '-'
  // 产品名称
  @State marketName: string = '-'

  private mXComponentController: XComponentController = new XComponentController();
  private openReceiveMoney = () => {
    router.pushUrl({
      url: "pages/paymentHomePage/ReceivePaymentPage"
    });
  }

  private playAnimation = () => {
    this.marginTop = 450;
  }

  aboutToAppear(): void {

    this.marketName = deviceInfo.marketName
    this.deviceType = deviceInfo.deviceType

    if (this.marketName == 'emulator') {
      AlertDialog.show({message:'模拟器不支持扫码'})

      return
    }
    let options: scanBarcode.ScanOptions = {
      scanTypes: [scanCore.ScanType.ALL],
      enableMultiMode: true,
      enableAlbum: true
    };

    try {
      customScan.init(options);
    } catch (error) {
      hilog.error(0x0001, '[Scan Sample]', 'Failed to init, error: %{public}s', JSON.stringify(error));
    }
  }

  aboutToDisappear(): void {
    try {
      customScan.release();
    } catch (error) {
    }
  }

  build() {
    Stack() {
      Column() {
        XComponent({
          id: 'componentId',
          type: 'surface',
          controller: this.mXComponentController
        })
          .onLoad(() => {
            const surfaceId: string = this.mXComponentController.getXComponentSurfaceId();
            let viewControl: customScan.ViewControl = {
              width: this.cameraWidth,
              height: this.cameraHeight,
              surfaceId: surfaceId
            };
            try {
              customScan.start(viewControl, (error: BusinessError, scanResult: Array<scanBarcode.ScanResult>) => {
                if (error) {
                  hilog.error(0x0001, '[Scan Sample]', 'start failed , error: %{public}s', JSON.stringify(error))
                  return;
                }
                hilog.info(0x0001, '[Scan Sample]', 'callback scan result: %{public}s', JSON.stringify(scanResult))
              });
              this.playAnimation();
            } catch (error) {
              hilog.error(0x0001, '[Scan Sample]', 'start failed , error: %{public}s', JSON.stringify(error))
            }
          })
          .width(this.cameraWidth)
          .height(this.cameraHeight)
      }
      .width(Constants.FULL_WIDTH)
      .height(Constants.FULL_HEIGHT)
      .clip(true)

      Column() {
        Row() {
          Image($r('app.media.ic_return'))
            .width($r('app.float.tabs_icon_size'))
            .height($r('app.float.tabs_icon_size'))
            .onClick(() => {
              router.back()
            })
          Image($r('app.media.ic_four_dot'))
            .width($r('app.float.four_dot_size'))
            .height($r('app.float.four_dot_size'))
        }
        .width(Constants.FULL_WIDTH)
        .height($r('app.float.function_row_height'))
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)

        Column() {
          Row() {
            Column() {
              FunctionCard($r("app.media.ic_payment_code"), Constants.SCAN_DIALOG_FUNCTIONS[0], this.openReceiveMoney)
            }

            Column() {
              FunctionCard($r("app.media.ic_album"), Constants.SCAN_DIALOG_FUNCTIONS[1], () => {
              })
            }
          }
          .width(Constants.FULL_WIDTH)
          .padding({
            left: $r('app.float.scan_page_space'),
            right: $r('app.float.scan_page_space'),
          })
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            ForEach(this.scanAbilities, (item: string, index: number) => {
              ScanAbility(item, index, this.currentIndex)
            }, (item: string) => item)
          }
          .width(Constants.FULL_WIDTH)
          .height($r('app.float.scan_ability_height'))
          .justifyContent(FlexAlign.Center)
          .margin({ top: $r('app.float.scan_page_margin_func') })
        }
        .width(Constants.FULL_WIDTH)

      }
      .width(Constants.FULL_WIDTH)
      .height(Constants.FULL_HEIGHT)
      .padding({
        top: $r('app.float.span16'),
        bottom: $r('app.float.span16'),
        left: $r('app.float.span24'),
        right: $r('app.float.span24')
      })
      .backgroundColor($r('app.color.all_opacity'))
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Image($r('app.media.scan_animation'))
          .width(Constants.FULL_WIDTH)
      }
      .width(Constants.FULL_WIDTH)
      .height($r('app.float.scan_animation_height'))
      .margin({ top: this.marginTop})
      .animation({
        duration: 2500,
        curve: Curve.Linear,
        iterations: -1,
        playMode: PlayMode.Normal
      })
    }
    .width(Constants.FULL_WIDTH)
    .height(Constants.FULL_HEIGHT)

  }
}