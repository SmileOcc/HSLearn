import { window } from "@kit.ArkUI";
import { common } from "@kit.AbilityKit";
import { YWAuthManager } from "./YWAuthManager";


export let authResolvePromise:((value:void | Promise<void>)=>void)

const authPromise:Promise<void> = new Promise<void>((resolve)=>{
  authResolvePromise = resolve
})



// @Entry
@Component
export struct YWAuthPage {
  @State message: string = 'Hello World';

  aboutToAppear(): void {
  }
  build() {
    Column(){
      Column(){
        Text("第一次 使用协议。。。。")
        Row(){
          Button('同意')
            .onClick(()=>{

              YWAuthManager.setUserPrivacy(getContext(this))
              //保存同意值
              authResolvePromise()
            })
          Button("取消")
            .onClick(()=>{

              const context = getContext(this) as common.UIAbilityContext;
              context.terminateSelf()//退出APP
            })
        }
        .justifyContent(FlexAlign.SpaceAround)
        .width('100%')
      }
      .justifyContent(FlexAlign.SpaceAround)
      .backgroundColor(Color.White)
      .width('80%')
      .height('60%')
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    // .backgroundColor(Color.Black)
    // .backgroundColor('#80FFFFFF')
    .backgroundColor('#80000000')
    .height('100%')
    .width('100%')
  }
}

export { authPromise as AuthPromise}