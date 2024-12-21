import { YWConstants } from '@learn/constants_har'
import { BuilderWrapData } from '../node/MainNodeController'

export enum DialogActionType {
  NORMAL,
  COFIRM,
  DANGER,
}

export enum DialogShowType {
  Ver,
  Hor,
}


// export const dialogViewNodeBuilder = wrapBuilder<[DialogConfig]>(dialogViewNodeView)
export const dialogViewNodeBuilder = wrapBuilder(dialogViewNodeView)

@Builder
function dialogViewNodeView(params:DialogConfig) {
  DialogView(
    {
      config:params,
      dismiss:()=> {

      }
    }
  )
}

export class DialogAction {
  type:DialogActionType = DialogActionType.NORMAL
  text?:ResourceStr
  click:(event:ClickEvent)=>void = ()=>{}
}

export interface DialogConfig {
  showType?:DialogShowType
  title?:ResourceStr
  content?:ResourceStr
  actions?:Array<DialogAction>
  canOutClickHide?:Boolean
}

@Component
export struct DialogView {

  @Require @Prop config: DialogConfig

  dismiss:()=>void = ()=> {

  }


  aboutToAppear(): void {

  }

  @Builder
  titleView() {
    Text(this.config.title){}

  }

  @Builder
  contentView() {
    Text(this.config.content){}
  }

  @Builder
  titleContentSpace() {

  }

  @Builder
  horActionItemView(item:DialogAction, isFirst:Boolean) {
    Button(item.text,buttonType(item.type))
      .buttonExtend(item,isFirst)
  }

  @Builder
  verActionItemView(item:DialogAction, isFirst:Boolean) {
    Button(item.text,buttonType(item.type))
      .buttonExtend(item,isFirst)
      .width('100%')
  }

  @Builder
  actionView() {

    if (this.config.showType == DialogShowType.Hor) {
      Row(){
        ForEach(this.config.actions,(item:DialogAction,index)=>{
          this.horActionItemView(item,index == 0 ? true : false)
        })
      }
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)

    } else {
      Column(){
        ForEach(this.config.actions,(item:DialogAction,index)=>{
          this.verActionItemView(item,index == 0 ? true : false)
        })
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
    }


  }


  @Builder
  mainView() {
    Column() {
      if (this.config.title) {
        this.titleView()
      }
      if (this.config.title && this.config.content) {
        this.titleContentSpace()
      }
      if (this.config.content) {
        this.contentView()
      }

      this.actionView()

    }
    .width("80%")
    .borderRadius('8')
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.Center)
  }



  @Styles
  bgStyles() {
    .backgroundColor(0x000000)
  }

  build() {

    Column() {
      this.mainView()
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .bgStyles()
    .onClick(()=>{
      if (this.config.canOutClickHide) {
        this.dismiss()
      }
    })

  }
}

@Extend(Button)
function buttonExtend(action:DialogAction, isFirst:Boolean) {

  .buttonStyle(ButtonStyleMode.NORMAL)
  .height(44)
  .borderWidth(1)
  .fontColor(YWConstants.HexColorA('ffcc33',0.9))
  .borderColor(YWConstants.HexColorA('ffcc33',0.9))
  .padding({left:10,bottom:3,right:10,top:3})
  .fontColor(Color.Green)
  .fontStyle(FontStyle.Italic)
  .onClick(action.click)
}


function buttonType(type:DialogActionType):ButtonOptions {

  if (type == DialogActionType.COFIRM) {
    return { type: ButtonType.Normal, buttonStyle: ButtonStyleMode.NORMAL }
  }

  if (type == DialogActionType.DANGER) {
    return { type: ButtonType.Normal, buttonStyle: ButtonStyleMode.NORMAL }
  }
  return { type: ButtonType.Normal, buttonStyle: ButtonStyleMode.NORMAL }

}