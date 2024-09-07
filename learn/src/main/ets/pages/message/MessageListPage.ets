@Entry
@Component
struct MessageListPage {

  @State list: SwipeMessageInterface[] = [
    {
      username: "安安1",
      info: "这孩子不是笨，就是学习方法不对。学习方法都找不对还不是笨啊？",
      date: "10:23",
      noRead: 0,
      icon: $r("app.media.logo")
    },
    {
      username: "大明1",
      info: "别人扮猪吃老虎，你只能扮猪。",
      date: "10:22",
      noRead: 2,
      icon: $r("app.media.icon")
    },
    {
      username: "大地2",
      info: "别人的女朋友都会生气了，而你的女朋友还在充气。",
      date: "昨天",
      noRead: 0,
      icon: $r("app.media.logo")
    },
    {
      username: "小贾2",
      info: "想变美就多睡觉，睡懵了就觉得自己美了。",
      date: "昨天",
      noRead: 5,
      icon: $r("app.media.logo")
    },
    {
      username: "徐姐",
      info: "该失望的事从没辜负过我，每次都认认真真的让我失望。",
      date: "星期三",
      noRead: 0,
      icon: $r("app.media.logo")
    },
    {
      username: "钱超",
      info: "请相信我，我所说的每句话，都是废话！",
      date: "星期三",
      noRead: 2,
      icon: $r("app.media.icon")
    },
    {
      username: "沈刚",
      info: "你永远不会知道，你的哪个好友，会成为下一个微商。",
      date: "10-22",
      noRead: 0,
      icon: $r("app.media.logo")
    },
    {
      username: "夏静",
      info: "都说累成狗，其实狗没你那么累。",
      date: "10-21",
      noRead: 5,
      icon: $r("app.media.logo")
    },
    {
      username: "丁杰",
      info: "每次临时抱佛脚的时候，佛总是给我一脚。",
      date: "10-23",
      noRead: 0,
      icon: $r("app.media.logo")
    },
    {
      username: "潘桂英",
      info: "不想结婚生子，是我作为穷人的自觉。",
      date: "10-22",
      noRead: 2,
      icon: $r("app.media.icon")
    },
    {
      username: "唐军",
      info: "人家谈恋爱，靠长相靠浪漫靠烧钱，而你靠对方眼瞎。",
      date: "10-22",
      noRead: 0,
      icon: $r("app.media.logo")
    },
    {
      username: "闫磊",
      info: "做事一定要考虑别人的感受，千万不能让他们太开心了。",
      date: "10-21",
      noRead: 5,
      icon: $r("app.media.logo")
    },
    {
      username: "史萍",
      info: "你踢球受过最重的伤，是女友到球场给对手喂水！",
      date: "10-23",
      noRead: 0,
      icon: $r("app.media.logo")
    },
    {
      username: "赵青",
      info: "别问我有啥，先说你要啥，再说你凭啥。",
      date: "10-22",
      noRead: 2,
      icon: $r("app.media.icon")
    },
    {
      username: "于丽",
      info: "经过多年的打拼，虽然没有什么收获，但你有债呀！",
      date: "10-22",
      noRead: 0,
      icon: $r("app.media.logo")
    },
    {
      username: "郑敏",
      info: "女生之间的友谊啊，就像塑料花，虽然假但永不凋零。",
      date: "10-21",
      noRead: 5,
      icon: $r("app.media.logo")
    },
  ]
  @State changeValue: string = ''

  getMsglist() {
    return this.list.filter(item => {
      return item.username.includes(this.changeValue) || item.info.includes(this.changeValue)
    })
  }

  //自定义组件内自定义构建函数
  @Builder actionItem(index: number) {
    Row() {
      Text("标记未读")
        .actionItemText(80, '#409EFF', () => {
          this.list[index].noRead = 1
          this.list = [...this.list];
        })
      Text("不显示")
        .actionItemText(70, '#E6A23C', () => {
          this.list.splice(index, 1)
        })
      Text("删除")
        .actionItemText(60, '#F56C6C', () => {
          this.list.splice(index, 1)
        })
    }
    .margin({ left: 10 })
  }

  build() {
    Column() {
      Row() {
        Search({ placeholder: '搜索' })
          .backgroundColor('#ffffff')
          .onChange((value: string) => {
            this.changeValue = value
          })
          .margin(20)
      }.width('100%')

      List() {
        ForEach(this.getMsglist(), (item: SwipeMessageInterface, key) => {
          ListItem() {
            msgList(item)
          }
          .height(60)
          .swipeAction({
            end: this.actionItem(key)
          })
        })
      }
      .divider({
        strokeWidth: 1,
        color: "#eeeeee"
      })
      .backgroundColor("#ffffff")
      .layoutWeight(1)
    }
    .width("100%")
    .height("100%")
    .backgroundColor("#eeeeee")
  }
}

//定义扩展组件样式
@Extend(Text) function actionItemText(width: number = 60, bgColor: ResourceColor = '#F56C6C', callBack: Function = () => {
}) {
  .fontSize(14)
  .fontColor("#ffffff")
  .height(60)
  .width(width)
  .textAlign(TextAlign.Center)
  .backgroundColor(`${bgColor}`)
  .onClick(() => {
    callBack()
  })
}

// 全局自定义构建函数
@Builder function msgList(item: SwipeMessageInterface) {
  Row() {
    Badge({
      count: item.noRead,
      position: BadgePosition.RightTop,
      style: {}
    }) {
      Image(item.icon)
        .width(44)
        .height((44))
        .borderRadius(4)
    }

    Column() {
      Text(item.username)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
      Text(item.info)
        .fontSize(14)
        .fontColor("#666666")
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .height(40)
    .margin({
      left: 10
    })
    .alignItems(HorizontalAlign.Start)
    .layoutWeight(1)

    Text(item.date)
      .fontSize(14)
      .fontColor('#cccccc')
      .width(60)
      .textAlign(TextAlign.End)
  }
  .padding(10)
}

interface SwipeMessageInterface {
  username: string,
  info: string,
  date: string,
  noRead: number,
  icon: ResourceStr,
}