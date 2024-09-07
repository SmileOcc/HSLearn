import { ProvideModel } from './model/ProvideModel';

@Entry
@Component
struct ProvideConsumPage {
  @State message: string = 'provide Consum';

  @Provide model:ProvideModel = new ProvideModel('title','name')
  build() {
    Row() {
      Column() {
        Text(this.message + "子类使用 @state,@Consume @Link 都有效，可以双向修改, \n【@prop 单向接受】")

        Text(this.message + " " + this.model.name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{
            this.model.name = "祖类 修改name"
          })
        ProvideChild({itemModel:this.model,itemModel2:this.model,itemModel3:this.model})
      }
      .width('100%')
    }
    .height('100%')
  }
}


@Component
struct ProvideChild {
  @Prop itemModel:ProvideModel
  @State itemModel2:ProvideModel = new ProvideModel()
  @Link itemModel3:ProvideModel

  // 通过相同的变量名绑定
  // 通过相同的变量别名绑定
  @Consume model:ProvideModel //同名

  build() {
    Column(){
      Text("@Prop" + this.itemModel.name ?? '空 修改无效')
        .width(200)
        .height(30).backgroundColor(Color.Green)
        .onClick(()=>{
          this.itemModel.name = "修改:Prop name"
        })
      Blank().height(2)
      Text("@State" + this.itemModel2.name ?? '空 这个修改有效 双向的')
        .width(200)
        .height(30).backgroundColor(Color.Green)
        .onClick(()=>{
          this.itemModel2.name = "修改: State name"
        })
      Blank().height(2)
      Text("@Link" + this.itemModel2.name ?? '空 这个修改有效 双向的')
        .width(200)
        .height(30).backgroundColor(Color.Green)
        .onClick(()=>{
          this.itemModel3.name = "修改: Link name"
        })
      Text(this.model.name ?? '空 这个修改有效 双向的')
        .width(200)
        .height(30).backgroundColor(Color.Green)
        .onClick(()=>{
          this.model.name = "修改:Consume name"
        })

      ProvideChildTwo()
    }
    .backgroundColor(Color.Grey)
  }
}

@Component
struct ProvideChildTwo {
  @Consume('model') subItme:ProvideModel //别名

  build() {
    Column(){
      Text('孙组件: ' + this.subItme.name)
        .width(200)
        .height(50).backgroundColor(Color.Orange)
        .onClick(()=>{
          this.subItme.name = "修改孙 name"
        })
    }
  }
}


