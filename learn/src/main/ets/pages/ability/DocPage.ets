import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';

@Entry
@Component
struct DocPage {
  private context = getContext(this) as common.UIAbilityContext
  @State editTitle: boolean = true
  @State title: string = globalThis?.key
  @State content: string = ''

  build() {
    Row() {
      Column({ space: 10 }) {
        Row({ space: 10 }) {
          Image($r('app.media.back'))
            .width(30)
            .onClick(() => {
              // 跳转到文档列表的 UIAbility
              let want: Want = {
                deviceId: '',
                bundleName: 'com.example.hmos_learn',
                moduleName: 'entry',
                abilityName: 'EntryAbility'
              }
              // 跳转
              this.context.startAbility(want)
            })
          if (!this.editTitle) {
            Text(this.title)
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
              .onClick(() => this.editTitle = true)
          } else {
            TextInput({
              placeholder: '请输入标题',
              text: this.title
            })
              .layoutWeight(1)
              .onChange(val => this.title = val)
            Button('确定')
              .onClick(() => this.editTitle = false)
          }
        }
        .width('100%')

        Divider()
        TextArea({
          placeholder: '请输入文档内容',
          text: this.content
        })
          .layoutWeight(1)
          .onChange(val => this.content = val)
      }
      .padding(10)
      .width('100%')
      .height('100%')
    }
  }
}