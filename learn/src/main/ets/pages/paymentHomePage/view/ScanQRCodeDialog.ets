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

import { customScan, scanBarcode, scanCore } from '@kit.ScanKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { Constants } from '../../../../../../../modules/common_har/src/main/ets/common/Constants';
import { BreakpointTypeEnum } from '../../../../../../../modules/common_har/src/main/ets/common/BreakPointSystem';

const aspectToHeightRatio = 4 / 3;

@Builder
export function FunctionCard(icon: Resource, text: string, clickCallback: Function) {
  Column() {
    Row() {
      Image(icon)
        .width(Constants.FULL_WIDTH)
    }
    .width($r('app.float.quick_function_item_image_size_smaller'))
    .height($r('app.float.quick_function_item_image_size_smaller'))
    .backgroundColor($r('app.color.scan_option_bgc'))
    .borderRadius($r('app.float.br20'))
    .justifyContent(FlexAlign.Center)
    .margin({ bottom: $r('app.float.span3dot5') })

    Text(text)
      .fontFamily($r('app.string.normal_font_family'))
      .fontSize($r('app.float.smaller_font_size'))
      .textAlign(TextAlign.Center)
      .fontWeight(Constants.FONT_WEIGHT_400)
      .fontColor(Color.White)
  }
  .onClick(() => {
    clickCallback()
  })
}

@Builder
export function ScanAbility(name: string, index: number, currentIndex: number) {
  Column() {
    Text(name)
      .fontFamily($r('app.string.medium_font_family'))
      .fontSize($r('app.float.smaller_font_size'))
      .fontColor(Color.White)
      .textAlign(TextAlign.Center)
      .fontWeight(Constants.FONT_WEIGHT_500)
      .margin({ bottom: $r('app.float.span4') })
    Row()
      .width($r('app.float.active_dot_size'))
      .height($r('app.float.active_dot_size'))
      .borderRadius($r('app.float.br2'))
      .backgroundColor(currentIndex === index ? $r('app.color.active_dot_color') : Color.Transparent)
  }
  .width($r('app.float.active_dot_size_width'))
}


@CustomDialog
export struct ScanQRCodeDialog {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  @State cameraWidth: number = Constants.INIT_CAMERA_WIDTH_DIALOG;
  @State cameraHeight: number = Constants.INIT_CAMERA_HEIGHT_DIALOG;
  @State currentIndex: number = 0;
  @State scanAbilities: string[] = Constants.SCAN_ABILITIES;
  @State marginTop: number = 50;
  private controller?: CustomDialogController;
  private mXComponentController: XComponentController = new XComponentController();
  private receivePayment: Function = () => {
  };
  private playAnimation = () => {
    this.marginTop = 320;
  }

  aboutToAppear(): void {
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
    customScan.release();
  }

  private openReceiveMoney = () => {
    this.controller?.close();
    if (this.currentBreakpoint === 'sm') {
      router.pushUrl({
        url: "pages/ReceivePaymentPage"
      })
    } else {
      this.receivePayment();
    }
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Column() {
        XComponent({
          id: 'componentId',
          type: 'surface',
          controller: this.mXComponentController
        })
          .onLoad(() => {
            hilog.info(0x0001, '[Scan Sample]', 'onLoad is called')
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
                hilog.info(0x0001, '[Scan Sample]', 'callback scan result: %{public}s', JSON.stringify(scanResult));
                this.playAnimation();
              });
              this.playAnimation();
            } catch (error) {
              hilog.error(0x0001, '[Scan Sample]', 'start failed , error: %{public}s', JSON.stringify(error))
            }
          })
          .width(this.cameraWidth)
          .height(this.cameraHeight)
      }
      .width($r('app.float.half_dialog_width'))
      .height($r('app.float.half_dialog_height'))
      .clip(true)
      .borderRadius($r('app.float.b424'))

      Column() {
        Row() {
          Text($r('app.string.scan_text'))
            .fontFamily("HarmonyHeiTi-Bold")
            .fontSize($r('app.float.biggest_font_size'))
            .fontColor(Color.White)
            .fontWeight(Constants.FONT_WEIGHT_700)
          Row() {
            Image($r('app.media.ic_close'))
              .width(Constants.FULL_WIDTH)
              .height(Constants.FULL_HEIGHT)
              .fillColor(Color.White)
          }
          .width($r('app.float.icon_close_size'))
          .height($r('app.float.icon_close_size'))
          .backgroundColor($r('app.color.border_divider_color'))
          .borderRadius($r('app.float.br20'))
          .onClick(() => {
            this.controller?.close();
          })
        }
        .width(Constants.FULL_WIDTH)
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ bottom: $r('app.float.title_margin_function') })

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
          left: $r('app.float.padding_80'),
          right: $r('app.float.padding_80')
        })
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ bottom: $r('app.float.function_margin_scan_ability') })


        Row() {
          Blank()
          ForEach(this.scanAbilities, (item: string, index: number) => {
            ScanAbility(item, index, this.currentIndex)
          }, (item: string) => item)
        }
        .width(Constants.FULL_WIDTH)
        .height($r('app.float.scan_ability_height'))
      }
      .width($r('app.float.half_dialog_width'))
      .height($r('app.float.half_dialog_height'))
      .padding($r('app.float.br16'))
      .backgroundColor($r('app.color.scan_dialog_back_color'))
      .borderRadius($r('app.float.br24'))

      Row() {
        Image($r('app.media.scan_animation'))
          .width(Constants.FULL_WIDTH)
      }
      .width($r('app.float.scan_animation_width'))
      .height($r('app.float.scan_animation_height'))
      .margin({ top: this.marginTop })
      .animation({
        duration: 2500,
        curve: Curve.Linear,
        iterations: -1,
        playMode: PlayMode.Normal
      })
    }
  }
}