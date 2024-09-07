
// 注：当前代码基于宽度为720的设计稿进行适配，使用lpx单位。
// 整段代码描述的功能：
// 该代码实现了一个简单的搜索功能组件，其中包括：
// 1. 输入框：用户可以在此输入要搜索的内容；
// 2. 搜索按钮：点击后，将当前输入内容添加到搜索历史记录的首位，若有重复则移除重复项，并保持历史记录不超过10条；
// 3. 搜索历史标题和清空记录按钮：展示搜索历史记录列表，并提供清空全部历史记录的功能；
// 4. 搜索历史记录列表：按照时间最近的顺序显示搜索历史记录，最多显示10条。
@Entry
@Component
struct SearchPage {
  // 定义状态变量，用于存储输入框的当前值
  @State inputValue: string = ''

  // 定义状态变量，用于存储搜索历史记录的数组
  @State historyValueArr: Array<string> = [
    '张三', '李四', '举头望明月', '低头思故乡', 'HarmonyOs', '不可能，绝对不可能'
  ]

  // 构建UI组件
  build() {
    // 主体内容使用Column布局，垂直堆叠组件
    Column() {
      // 输入框和搜索按钮组合，使用Row布局，水平排列
      Row() {
        // 创建一个TextInput输入框
        TextInput({
          placeholder: '请输入内容',
          text: this.inputValue
        })
          .width('524.31lpx') // 设置宽度
          .height('70lpx') // 设置高度
          .fontSize('27lpx') // 设置字体大小
          .backgroundColor("#ffffff") // 设置背景颜色
            // 输入框内容改变时，同步更新状态变量inputValue
          .onChange((value) => {
            this.inputValue = value
          })

        // 创建一个搜索按钮
        Button('搜索')
          // 按钮点击事件，处理搜索逻辑
          .onClick(() => {
            // 遍历历史记录数组，若找到与输入框内容相同的记录，从数组中移除
            for (let i = 0; i < this.historyValueArr.length; i++) {
              if (this.historyValueArr[i] === this.inputValue) {
                this.historyValueArr.splice(i, 1);
                break;
              }
            }

            // 将输入框内容添加到历史记录数组的首位
            this.historyValueArr.unshift(this.inputValue);

            // 若历史记录超过10条，则移除最后一项
            if (this.historyValueArr.length > 10) {
              this.historyValueArr.splice(this.historyValueArr.length - 1);
            }
          })
      }
      // 设置Row组件的宽度、对齐方式和内外边距
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: '37lpx',
        top: '11lpx',
        bottom: '11lpx',
        right: '15lpx'
      })

      // 搜索历史标题和清除记录按钮组合，同样使用Row布局
      Row() {
        // 搜索历史标题
        Text('搜索历史').fontSize('31lpx').fontColor("#000000")

        // 清空记录按钮
        Text('清空记录')
          .fontSize('27lpx').fontColor("#828385")
          // 清空记录按钮点击事件，清空历史记录数组
          .onClick(() => {
            this.historyValueArr.length = 0;
          })
      }
      // 设置Row组件的宽度、对齐方式和内外边距
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: '37lpx',
        top: '11lpx',
        bottom: '11lpx',
        right: '37lpx'
      })

      // 使用Flex布局，按行（FlexDirection.Row）包裹搜索历史记录
      Flex({
        direction: FlexDirection.Row,
        wrap: FlexWrap.Wrap,
      }) {
        // 遍历历史记录数组，创建Text组件展示每一条历史记录
        ForEach(this.historyValueArr, (item: string, value: number) => {
          Text(item)
            .padding({
              left: '15lpx',
              right: '15lpx',
              top: '7lpx',
              bottom: '7lpx'
            })
              // 设置背景颜色、圆角和间距
            .backgroundColor("#EFEFEF")
            .borderRadius(10)
            .margin('11lpx')
        })
      }
      // 设置Flex容器的宽度和内外边距
      .width('100%')
      .padding({
        left: '26lpx',
        top: '11lpx',
        bottom: '11lpx',
        right: '26lpx'
      })
    }
    // 设置Column容器的宽度、高度和背景颜色
    .width('100%')
    .height('100%')
    .backgroundColor("#F8F8F8")
  }
}
