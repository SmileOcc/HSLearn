import { YWConstants } from '@learn/constants_har';
import { UserInfoModel } from '../accountInfo/model/UserInfoModel';

let storage = LocalStorage.getShared()
@Entry(storage)
@Component
struct LocalStoragePage {
  @State message: string = 'Hello World';

  @LocalStorageLink('PropA') parentLinkNumber: number = 1;
  //单向
  @LocalStorageProp('PropA') parentPropNumber: number = 2;
  @LocalStorageLink('PropB') childLinkObject: PropB = new PropB(0);

  @StorageLink(YWConstants.kStorageLocalUser) localUseInf:UserInfoModel = new UserInfoModel()

  aboutToAppear(): void {
    console.log('========== LocalStoragePage')

    storage.setOrCreate('PropB', new PropB(50));


  }

  build() {
    Row() {
      Column() {
        Text('Link: ' + this.message + this.parentLinkNumber)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.parentLinkNumber += 1;
          })
        Text('PropA: ' + this.message + this.parentPropNumber)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.parentPropNumber += 1;
          })
        Text('Link: ' + this.message + this.childLinkObject.code)
          .onClick(() => {
            this.childLinkObject.code += 1;
          })
        Child()
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