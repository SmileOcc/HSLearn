import router from '@ohos.router'

const TAG: string = '[NavigationBar]'

@Component
export struct NavigationBar {
  private url: string = '';
  private username: string = '';
  private bundleName: string = '';
  private flag: boolean = false;
  private title: ResourceStr = $r('app.string.empty');
  private email: string = '';
  private signature: string = '';

  build() {
    Row() {
      if (this.flag) {
        Row() {
          Row() {
            Image($r('app.media.left'))
              .objectFit(ImageFit.Contain)
              .width('10%')
            Text($r('app.string.back'))
              .fontSize(18)
              .textAlign(TextAlign.End)
              .fontColor(Color.Black)
          }
          .id('back')
          .layoutWeight(1)
          .onClick(() => {
            router.back()
            // AlertDialog.show(
            //   {
            //     title: $r('app.string.warning'),
            //     message: $r('app.string.routerback'),
            //     primaryButton: {
            //       value: $r('app.string.confirm'),
            //       action: () => {
            //         router.replaceUrl({
            //           url: this.url,
            //           params: {
            //             bundleName: this.bundleName,
            //             username: this.username,
            //             email: this.email,
            //             signature: this.signature
            //           }
            //         })
            //       }
            //     },
            //     secondaryButton: {
            //       value: $r('app.string.cancel'),
            //       action: () => {
            //         Logger.info(TAG, `AlertDialog enter`)
            //       }
            //     },
            //     cancel: () => {
            //       Logger.info(TAG, `AlertDialog close`)
            //     }
            //   })
          })

          Text(this.title)
            .fontSize(18)
            .fontColor(Color.White)
            .textAlign(TextAlign.Start)
            .margin({ right: '5%' })
        }
        .height('8%')
        .width('100%')
        .padding({ left: 15 })
        .backgroundColor('#0D9FFB')
        .constraintSize({ minHeight: 50 })
      } else {
        Row() {
          Text(this.title)
            .fontSize(18)
            .fontColor(Color.Black)
            .textAlign(TextAlign.Center)
        }
        .height('8%')
        .width('100%')
        .padding({ left: 15 })
        // .backgroundColor('#0D9FFB')
        .backgroundColor(Color.White)

        .constraintSize({ minHeight: 50 })
      }
    }
  }
}