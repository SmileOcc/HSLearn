import { YWRandomUtils } from '@learn/common_har';

@Entry
@Component
struct TestListScrollPage {
  @State message: string = 'Hello World';
  @State selectedIndex: number = 0;
  private listScroller: Scroller = new Scroller();

  alphabets = ['#', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K',  'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

  //只能观察到一维数组变化，二维的改变不支持，
  // @State contactsGroups: GroupItem[] = [
  @State contactsGroups: GroupItem[] = [
  {
      title: 'A',
      key:YWRandomUtils.generateUUID32(),
      contacts: [
        new Contact('艾佳', $r('app.media.avatar')),
        new Contact('安安', $r('app.media.avatar')),
        new Contact('Angela', $r('app.media.avatar')),
      ],
    },
    {
      title: 'B',
      key:YWRandomUtils.generateUUID32(),
      contacts: [
        new Contact('白叶', $r('app.media.avatar')),
        new Contact('伯明', $r('app.media.avatar')),
      ],
    },
    {
      title: 'C',
      key:YWRandomUtils.generateUUID32(),
      contacts: [
        new Contact('白叶c', $r('app.media.avatar')),
        new Contact('伯明c', $r('app.media.avatar')),
      ],
    },
    {
      title: 'D',
      key:YWRandomUtils.generateUUID32(),
      contacts: [
        new Contact('白叶d', $r('app.media.avatar')),
        new Contact('伯明d', $r('app.media.avatar')),
      ],
    },
    {
      title: 'E',
      key:YWRandomUtils.generateUUID32(),
      contacts: [
        new Contact('白叶e', $r('app.media.avatar')),
        new Contact('伯明e', $r('app.media.avatar')),
        new Contact('伯明e2', $r('app.media.avatar')),
        new Contact('伯明e3', $r('app.media.avatar')),
        new Contact('伯明e4', $r('app.media.avatar')),
        new Contact('伯明e5', $r('app.media.avatar')),
        new Contact('伯明e6', $r('app.media.avatar')),

      ],
    },
    {
      title: 'F',
      key:YWRandomUtils.generateUUID32(),
      contacts: [
        new Contact('白叶f', $r('app.media.avatar')),
        new Contact('伯明f', $r('app.media.avatar')),
      ],
    },

  ]


  @Builder itemHead(text: string) {
    // 列表分组的头部组件，对应联系人分组A、B等位置的组件
    Text(text)
      .fontSize(20)
      .backgroundColor('#fff1f3f5')
      .width('100%')
      .padding(5)
  }

  @Builder itemView(item:Contact, index:number) {
    ListItem() {


      Row() {
        Badge({
          count: item.badge,
          position: BadgePosition.RightTop,
          style: { badgeSize: 16, badgeColor: '#FA2A2D' }
        }) {
          Image(item.icon)
            .width(40)
            .height(40)
            .margin(10)
        }
        Text(item.name).fontSize(20)
      }
      .width('100%')
      .height(56)
      .padding({top:12,bottom:12})
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
    }.swipeAction({ end: this.itemEnd(item, index) })

  }

  @Builder itemEnd(item:Contact, index: number) {
    // 侧滑后尾端出现的组件
    Button({ type: ButtonType.Circle }) {
      Image($r('app.media.ic_public_delete'))
        .width(50)
        .height(50)
    }
    .onClick(() => {

      // @State只是监听数组的地址值（好像包括数组中对象的地址），但是数组中对象的属性值变化并没有改变地址值，所以监听不到

      //这个会触发UI绘制
      // this.contactsGroups.splice(1,1)


      let groupIndex =  this.contactsGroups.findIndex((groupItem,index,itemList)=>{
        let firstIndex:number = groupItem.contacts?.indexOf(item) ?? -1
        return firstIndex >= 0
      })

      let groupItem = this.contactsGroups[groupIndex]
      if (groupItem && (groupItem.contacts?.length ?? 0) > index) {

        groupItem.contacts?.splice(index,1)
        // this.contactsGroups[groupIndex].contacts?.splice(index,1)
        // const  subListCount = groupItem.contacts?.length ?? 100


        //这里不会触发UI绘制
        if ((groupItem.contacts?.length ?? 0) <= 0) {
          this.contactsGroups.splice(groupIndex,1)
        } else {//重新赋值

          // this.contactsGroups[groupIndex] = groupItem //这个不可以,这个是因为ForEach 用的标识之前用title，这没有变，就不可以

          //重新生产ui标识key
          this.contactsGroups[groupIndex] = {key:YWRandomUtils.generateUUID32(),title:groupItem.title,contacts:groupItem.contacts}
        }
        // this.contactsGroups[groupIndex] = {}//这个可以

        //先复制一个临时的列表 触发不了UI绘制，二维了
        // let tempList: GroupItem[] = [...this.contactsGroups]
        // this.contactsGroups.splice(0,this.contactsGroups.length)
        // this.contactsGroups = tempList

      }

    })

  }

  build() {
    Stack({ alignContent: Alignment.End }) {
      List({space:10, scroller: this.listScroller}) {
        // 循环渲染ListItemGroup，contactsGroups为多个分组联系人contacts和标题title的数据集合
        ForEach(this.contactsGroups, (item:GroupItem, index:number) => {
          ListItemGroup({ header: this.itemHead(item.title) }) {
            // 循环渲染ListItem
            ForEach(item.contacts, (contact:Contact,index:number) => {
              this.itemView(contact,index)
            }, (subItem:Contact) => subItem.key)
          }
          },(item:GroupItem) => item.key)
        //这两种都不可以，key本质没有变
          // },(item:GroupItem,index:number) => (item.title + `${index}`))
        // },(index:number) => index.toString())
      }
      .onScrollIndex((firstIndex: number) => {
        this.selectedIndex = firstIndex
        // 根据列表滚动到的索引值，重新计算对应联系人索引栏的位置this.selectedIndex


      })
      .sticky(StickyStyle.Header)  // 设置吸顶，实现粘性标题效果
      .divider({
        strokeWidth: 1,
        startMargin: 60,
        endMargin: 10,
        color: '#ffe9f0f0'
      })
      .scrollBar(BarState.Auto)
      .backgroundColor('#FFF1F3F5')
      .alignListItem(ListItemAlign.Center)
      .height('100%')
      .width('100%')

      // 字母表索引组件
      AlphabetIndexer({ arrayValue: this.alphabets, selected: 0 })
        .selected(this.selectedIndex)
        .onSelect((index)=>{
          this.listScroller.scrollToIndex(index)
        })

      Button() {
        Text("返回顶部")
      }
      .onClick(() => {
        // 点击按钮时，指定跳转位置，返回列表顶部
        this.listScroller.scrollToIndex(0)

        //调整badge值
        //无效
        let groupItem = this.contactsGroups[0]
        groupItem.contacts![0].badge = 2

        //同样需要改变key
        this.contactsGroups[0] = {key:YWRandomUtils.generateUUID32(),title:groupItem.title,contacts:groupItem.contacts}

      })
      .position({ x: '80%', y: '90%' })
    }
    .height('100%')
    .width('100%')
  }
}

@Observed
class GroupItem {
  key?: string
  title?:string
  contacts?:Contact[]
}

@Observed
class Contact {
  key: string = YWRandomUtils.generateUUID32();
  name: string;
  icon: Resource;
  badge: number = 1

  constructor(name: string, icon: Resource) {
    this.name = name;
    this.icon = icon;
  }
}
