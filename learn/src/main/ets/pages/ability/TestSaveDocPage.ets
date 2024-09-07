import { common } from '@kit.AbilityKit'
import Want from '@ohos.app.ability.Want';

@Entry
@Component
struct TestSaveDocPage {
  private index: number = 1
  @State docs: number[] = []

  private context = getContext(this) as common.UIAbilityContext

  build() {
    Row() {
      Column({space: 10}) {

        Button('打开已保存文档')
          .onClick(() => {
            // 添加文档
            // 跳转的目的地want
            let want: Want = {
              deviceId: '',
              bundleName: 'com.example.hmos_learn',
              moduleName: 'entry',
              abilityName: 'SavedAbility',
              parameters: {
                instanceKey: 'save' //specified时有用）
              }
            }
            // 跳转
            this.context.startAbility(want)
          })

        Divider()
        // 新建文档按钮点击跳转
        Button('新建文档')
          .onClick(() => {
            // 添加文档
            this.docs.push(this.index++)
          })
        Divider()

        ForEach(this.docs, (id:number) => {
          Row({space:10}){
            Image($r('app.media.app_icon'))
              .width(20)

            // 文档列表跳转
            Text(`文档${id}`)
              .fontSize(18)
              .onClick(() => {
                // 跳转到文档编辑的 UIAbility
                // 跳转的目的地want
                let want: Want = {
                  deviceId: '',
                  bundleName: 'com.example.hmos_learn',
                  moduleName: 'entry',
                  abilityName: 'DocAbility',
                  parameters: {
                    instanceKey: '文档' + id //key不一致（specified时有用）
                  }
                }
                // 跳转
                this.context.startAbility(want)
              })

          }
          .width('100%')
        })

      }
      .width('100%')
      .height('100%')
      .padding(20)
    }
  }
}