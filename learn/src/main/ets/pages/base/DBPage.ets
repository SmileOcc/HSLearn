import { AccountData, DBUtils } from '../../../../../../modules/common_har/src/main/ets/utils/DBUtils';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct DBPage {
  // 账户数据数组
  @State accountDataArray: AccountData[] = []
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext
  //1. 实例化数据库工具类
  //2. 界面打开时，查询数据
  //3. 点击确定，插入数据

  //1. 实例化数据库工具类
  dbUtils: DBUtils = new DBUtils()
  // 添加数据弹框
  addDialogController: CustomDialogController = new CustomDialogController({
    builder: AddDialog({
      //点击确定的回调
      confirm: (insertData: AccountData) => {
        this.onConfirm(insertData)
      }
    })
  })
  // 列表的图片数组
  imageArr: Resource[] = [$r('app.media.foods'),
    $r('app.media.games'),
    $r('app.media.fuel')
  ]

  //TODO:aboutToAppear一般用于数据初始化
  // 获取网络数据
  // 获取持久化的数据

  aboutToAppear(): void {
    // 补充：创建数据库表
    this.dbUtils.getRdbStore(this.context, () => {
      //2. 界面打开时，查询数据
      this.queryData()
    })

  }
  queryData(){
    this.dbUtils.query((result: AccountData[]) => {
      if (result.length <= 0) {
        return //没有数据
      }
      AlertDialog.show({ message: '获取数据成功' })
      //     accountDataArray
      this.accountDataArray = result
    })
  }

  // 点击确定回调
  onConfirm(insertData: AccountData) {
    console.log("test123", JSON.stringify(insertData))
    //3. 点击确定，插入数据
    this.dbUtils.insertData(insertData, (num: number) => {
      if(num<=0){
        AlertDialog.show({message:"插入失败"})
      }else{
        AlertDialog.show({ message: "插入成功：" + num })
        //重新获取数据
        this.queryData()
      }
    })
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Text('关系型数据库')
            .height(33)
            .fontSize(24)
            .margin({ left: 24 })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin(12)

        //数据列表
        List({ space: 20 }) {
          ForEach(this.accountDataArray, (item: AccountData, index: number) => {
            ListItem() {
              Row() {
                // 图片
                Image(this.imageArr[item.accountType])
                  .width(40)
                  .aspectRatio(1)
                  .margin({ right: 16 })
                // 内容
                Text(item.typeText)
                  .height(22)
                  .fontSize(16)
                Blank().layoutWeight(1)
                // 金额
                Text("￥: " + String(item.amount))
                  .height(22)
                  .fontSize(16)
              }
              .width('90%')
              .padding({ left: 12, right: 12 })
              .margin({ left: 20 })
              .backgroundColor('#f1f3f5')
              .padding(10)
              .borderRadius(30)
            }
          })
        }
      }
      .width('100%')

      Button() {
        Image($r('app.media.add'))
      }
      .width(48)
      .height(48)
      .position({ x: '80%', y: '90%' })
      .onClick(() => {
        this.addDialogController.open()
      })
    }
  }
}

interface Item {
  icon: Resource;
  text: string;
}

@CustomDialog
struct AddDialog {
  controller: CustomDialogController;
  //确认回调
  confirm?: (insertData: AccountData) => void
  items: Array<Item> = [
    { icon: $r('app.media.foods'), text: '吃饭' },
    { icon: $r('app.media.games'), text: '娱乐' },
    { icon: $r('app.media.fuel'), text: '加油' },
  ]
  @State currentIndex: number = -1
  @State money: number = 0

  build() {
    Column() {
      Row() {
        ForEach(this.items, (item: Item, index) => {
          Column() {
            Image(item.icon)
              .width(40)
              .height(40)

            Text(item.text)
              .fontSize(12)
              .fontColor('#FF007DFF')
              .margin({ top: 8 })
          }
          .width(86)
          .aspectRatio(1) //指定当前组件的宽高比
          .padding({ top: 12 })
          .margin({ top: 16, left: 12 })
          .align(Alignment.TopStart)
          .backgroundColor(this.currentIndex === index ? '#ccc' : '#FFF1F3F5')
          .borderRadius(16)
          .onClick(() => {
            this.currentIndex = index
          })
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)

      Row() {
        Column() {
          Text('金额')
            .width('100%')
            .fontSize(20)
            .fontColor(Color.Black)

          Column() {
            TextInput({
              placeholder: '请输入金额'
            })
              .padding({
                left: 0,
                top: 0,
                bottom: 0
              })
              .borderRadius(0)
              .backgroundColor(Color.White)
              .type(InputType.Number)
              .onChange((value: string) => {
                this.money = Number(value)
              })
          }
          .height(48)
          .padding({ top: 15, bottom: 11 })
          .borderWidth({ bottom: 1 })
          .borderColor('#33182431')

          Button("确定").onClick((event: ClickEvent) => {
            if (this.currentIndex === -1) {
              AlertDialog.show({ message: "请选择种类" })
              return
            }
            if (this.money === 0) {
              AlertDialog.show({ message: "请输入金额" })
              return
            }
            let insertData: AccountData = {
              id: 0,
              accountType: this.currentIndex,
              typeText: this.items[this.currentIndex].text,
              amount: this.money
            }
            this.confirm && this.confirm(insertData)
            this.controller.close()
          })
            .width('90%')
            .margin(20)
        }
        .width('100%')
        .padding({ left: 12, right: 12 })
      }
      .width('100%')
      .margin(20)
    }
  }
}