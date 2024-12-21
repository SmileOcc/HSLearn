import { YWConstants } from '@learn/constants_har';
import { UserInfoModel } from '../accountInfo/model/UserInfoModel';

let storage = LocalStorage.getShared()
@Entry(storage)
@Component
struct LocalStorageAppStoragePage {
  @State message: string = 'Hello World';

  @LocalStorageLink('PropA') parentLinkNumber: number = 1;
  //单向
  @LocalStorageProp('PropA') parentPropNumber: number = 2;
  @LocalStorageLink('PropB') childLinkObject: PropB = new PropB(0);

  //这个修改，怎么同步刷新了  tempUserInfo ？？？
  @StorageLink(YWConstants.kStorageLocalUser) localUseInf:UserInfoModel = new UserInfoModel()

  @StorageLink(YWConstants.kAppStorageStorageLocalThreeUser) localUseInfThree:UserInfoModel = new UserInfoModel()


  //这两个是获取
  @State appStorageUserInfo:SubscribedAbstractProperty<UserInfoModel> = AppStorage.link(YWConstants.kAppStorageStorageLocalUser)
  @Prop appStorageUserInfoTwo:SubscribedAbstractProperty<UserInfoModel>


  //不可以
  //@Link appStorageUserInfoThree:SubscribedAbstractProperty<UserInfoModel>

  //这个 其他修改，这个有效
  @State tempUserInfo:UserInfoModel = this.appStorageUserInfo.get()


  aboutToAppear(): void {
    console.log('========== LocalStoragePage')

    storage.setOrCreate('PropB', new PropB(50));


    this.appStorageUserInfoTwo = AppStorage.link(YWConstants.kAppStorageStorageLocalUser)
  }

  build() {
    Row() {
      Column() {

        Text('StorageLink: ' + this.localUseInf.name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.localUseInf.name = 'ood001'
          })
        Blank().height(10)

        Text('StorageLink: ' + this.localUseInfThree.name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.localUseInfThree.name = 'offf001'
          })
        Blank().height(10)
        Text('Link: ' + this.message + this.parentLinkNumber)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.parentLinkNumber += 1;
          })
        Text('PropA: ' + this.message + this.parentPropNumber)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.parentPropNumber += 1;
          })
        Text('Link: ' + this.message + this.childLinkObject.code)
          .onClick(() => {
            this.childLinkObject.code += 1;
          })
        Child()


        Text('State: ' + this.message + " " + this.appStorageUserInfo.get().name)
          .onClick(() => {
            let model = this.appStorageUserInfo.get()
            model.name += '1'
            this.appStorageUserInfo.set(model)//修改了本地数据，UI上是get获取 【tempInfo变得有效】
          })
          .backgroundColor(Color.Green)
        Text('Prop: ' + this.message + " " + this.appStorageUserInfoTwo.get().name)
          .onClick(() => {
            let model = this.appStorageUserInfoTwo.get()
            model.name += '1'
            this.appStorageUserInfoTwo.set(model)//修改了本地数据，UI上是get获取 【tempInfo变得有效】
          })
          .backgroundColor(Color.Green)



        Text('重置name: ' + this.message + " " + this.appStorageUserInfoTwo.get().name)
          .onClick(() => {
            let model = this.appStorageUserInfoTwo.get()
            model.name = 'occ'
            AppStorage.setOrCreate(YWConstants.kAppStorageStorageLocalUser,model)//修改了本地数据，UI上是get获取 【tempInfo变得有效】
          })
          .backgroundColor(Color.Green)

        Text('重置name 中间持有: ' + this.message + " " + this.tempUserInfo.name)
          .onClick(() => {
            this.tempUserInfo.name = 'occ01'
            AppStorage.setOrCreate(YWConstants.kAppStorageStorageLocalUser,this.tempUserInfo)//修改了本地数据，UI上是get获取
          })
          .backgroundColor(Color.Green)
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Component
struct Child {
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropA'属性建立双向绑定
  @LocalStorageLink('PropA') childLinkNumber: number = 1;
  // @LocalStorageLink变量装饰器与LocalStorage中的'PropB'属性建立双向绑定
  @LocalStorageLink('PropB') childLinkObject: PropB = new PropB(0);

  build() {
    Column() {
      Button(`Child from LocalStorage ${this.childLinkNumber}`) // 更改将同步至LocalStorage中的'PropA'以及Parent.parentLinkNumber
        .onClick(() => {
          this.childLinkNumber += 1;
        })
      Button(`Child from LocalStorage ${this.childLinkObject.code}`) // 更改将同步至LocalStorage中的'PropB'以及Parent.parentLinkObject.code
        .onClick(() => {
          this.childLinkObject.code += 1;
        })

      Button(`Child from LocalStorage ${this.childLinkObject.code}`) // 更改将同步至LocalStorage中的'PropB'以及Parent.parentLinkObject.code
        .onClick(() => {
          storage.setOrCreate('PropB', new PropB(60));

        })


      Button(`Child from LocalStorage ${this.childLinkNumber}`) // 更改将同步至LocalStorage中的'PropB'以及Parent.parentLinkObject.code
        .onClick(() => {
          storage.setOrCreate('PropA', 90);

        })

    }
  }
}


// 从API version 12开始，自定义组件支持接收LocalStorage实例。
// 当自定义组件作为子节点，定义了成员属性时，LocalStorage实例必须要放在第二个参数位置传递，否则会报类型不匹配的编译问题。
// 当在自定义组件中定义了属性时，暂时不支持只有一个LocalStorage实例作为入参。如果没定义属性，可以只传入一个LocalStorage实例作为入参。
// 如果定义的属性不需要从父组件初始化变量，则 第一个参数需要传{}。
// 作为构造参数传给子组件的LocalStorage实例在初始化时就会被决定，可以通过@LocalStorageLink或者LocalStorage的API修改LocalStorage实例中保存的属性值，但LocalStorage实例自身不能被动态修改。

class PropB {
  code: number;

  constructor(code: number) {
    this.code = code;
  }
}