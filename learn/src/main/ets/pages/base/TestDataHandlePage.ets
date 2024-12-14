import { objectToCamel } from './TSTestDataHandle'

@Component
struct BuilderParamBlackView {
  header: string = 'aa'
  @BuilderParam closer: () => void

  build() {
    Column() {
      Text(this.header)
        .fontSize(30)
      this.closer
    }
  }

  @Builder
  specificParam(str: string) {
    Column() {

    }
  }
}

@Entry
@Component
struct TestDataHandlePage {
  @State message: string = '数据调试';
  private list: Array<ITestData> =
    [{ name: "a", cid: "b", max: 11 }, { name: "b", cid: "b", max: 11 }, { name: "b", cid: "b", max: 11 }]
  testInfo: ITestInfo = { app_one: "one", app_name_xx: "name" }
  numArr = [1, 2, 3, 4]
  // 对象数组排序
  foods: Food[] = [
    {
      name: '西兰花',
      price: 6,
      count: 2
    },
    {
      name: '西红柿',
      price: 3,
      count: 3
    },
    {
      name: '榴莲',
      price: 30,
      count: 2
    },
    {
      name: '葱花',
      price: 1,
      count: 10
    }
  ]
  @State textArr: string[] = []
  name = "中国<em>公司</em>重庆市<em>公司</em>北分<em>公司</em>"

  @Builder
  componentBuilder() {
    Text(`Parent builder `)
  }

  @Builder
  specificParam(): void {
    Column() {

    }
  }

  aboutToAppear(): void {

    // 对em标签内的关键词标红显示
    if (this.name.indexOf('<em>') != -1) {
      let replaceText = this.name.replace(/<\/em>/g, '<em>')
      this.textArr = replaceText.split('<em>')
    }

    // Object.keys(this.testInfo).reduce((obj) =>({...result,["a":"b"]}),{})

    //排序
    const arr = [5, 12, 8, 130, 44]
    arr.sort((a, b) => {
      // return a-b
      return b - a
    })

    console.log(arr.toString())

    this.foods.sort((a, b) => {
      return a.price - b.price
    })
    console.log(JSON.stringify(this.foods))


    this.testMap()
    this.testReduce()
    this.testForEach()

    //箭头函数
    let buy = (num: number, price: number) => {
      return num * price
    }

    let totalPrice: number = buy(2, 3)
    console.log('最终的价格', totalPrice)

    // 联合类型
    let judge: number | string = 100
    judge = 'A+'
    console.log('评价', judge)

    // 锁定类型
    let gender: 'male' | 'female' | 'secret' = 'male'
    console.log('性别', gender)

  }

  // 函数计算总成绩
  calculateTotalScore(scores: number[]): number {
    // array.reduce(callbackFn,initialValue);
    // callbackFn:(accumulator,currentValue)=>... 将第一个元素作为accumulator，并从第二个元素开始处理数组。
    return scores.reduce((total, score) => total + score, 0);
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        BuilderChild({ customBuilderParam: this.componentBuilder })

        Text("数组")

        Text() {
          ForEach(this.textArr, (text: string) => {
            if (this.name.indexOf(`<em>${text}</em>`) != -1) {
              Span(text).fontColor(Color.Red)
            } else {
              Span(text)
            }
          })
        }

        //closer 有问题
        // BuilderParamBlackView({header:this.message,closer: ()=>{
        //   Text('YYY')
        //
        // }})
        // .padding(12)
        // .backgroundColor(Color.Red)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
    }
    .height('100%')
  }

  testReduce() {

    // reduce方法的作用是求和，他会逐个遍历数组元素，每一步都将当前元素的值与前一步的结果相加
    const total = this.foods.reduce((pre, next) => {
      return pre + next.price * next.count
    }, 0)
    console.log('total:', total)

    const keyList: string[] = Object.keys(this.testInfo)
    console.log(`key --- list: ${keyList}}`)

    const rest = keyList.reduce((pre, next, arr) => {
      return this.testInfo
    }, this.testInfo)

    const rest2 = objectToCamel(this.testInfo)
    console.log(`key --- list: ${rest2}}`)

    // accumulator

    //求和
    const arr1 = [1, 2, 3, 4, 5]
    const res1 = arr1.reduce((sum, next, index) => {
      //第一次：pre-->1 next-->2 index-->1
      //第二次：pre-->3 next-->3 index-->2
      return sum + next
    })

    const res1_1 = arr1.reduce((sum, next, index) => {
      //第一次：pre-->1 next-->2 index-->1
      //第二次：pre-->3 next-->3 index-->2
      return sum + next
    }, 100)

    //扁平化数组
    const arr2 = [[1, 2, 3], [4, 5], [6, 7]]
    const res2 = arr2.reduce((pre, next, index) => {
      return pre.concat(next) //前数组拼接后数组
    })
  }

  // 简写条件:
  //   函数体只有一行，可以省略大括号
  // 省略大括号时，如果有 return，也需要一起省略
  // 参数只有一个，且不需要写类型，可以省略小括号

  testForEach() {

    this.numArr.forEach((item: number) => {
      console.log('', item)
    })

    this.numArr.forEach((item: number, index: number, source: number[]) => {
      return item * index
    })

    this.numArr.forEach(item => console.log('', item))

  }

  testMap() {

    let res = this.numArr.map((item: number) => {
      return item * 2;
    })

    // source:[1,2,3,4]
    res = this.numArr.map((item: number, index: number, source: number[]) => {
      return item * 2
    })

    this.numArr.forEach(item => console.log('', item))

  }

  testFilter() {
    let res2 = this.numArr.filter((item: number) => {
      if (item > 2) {
        return true
      } else {
        return false
      }
    })

    res2 = this.numArr.filter(item => item > 2)
    console.log(`key --- list: ${res2}}`)

  }

  testArrayAction() {
    // 数组的第一种定义（类型 + 方括号）
    let list1: number[] = [1, 2, 3, 4, 5];
    let list2: string[] = ['1', '2', '3', '4', '5']
    // let list3: any[] = [1, 2, 4, { a: 1 }, '23']

    // 数组的第二种定义（数组泛型）
    let list4: Array<number> = [1, 2, 3, 4, 5]
    let list5: Array<string> = ['1', '2', '3', '4', '5']
    // let list6: Array<any> = ['1', '2', { a: 1 }, 4, 5, true, false]


    let dataList: string[] = ['北京', '上海', '广州']
    // 普通 for 循环
    for (let i = 0; i < dataList.length; i++) {
      console.log(dataList[i])
    }
    // for...of 循环
    for (const item of dataList) {
      console.log(item)
    }
    // forEach 循环
    dataList.forEach((item, index) => {
      console.log(item)
    })

    // 在数组末尾，添加/删除元素
    let dataList2: string[] = ['北京', '上海', '广州']
    dataList2.push('杭州') // 尾部添加元素，结果为：['北京', '上海', '广州', '杭州']
    dataList2.pop() // 尾部删除元素，结果为：['北京', '上海', '广州']

    // 在数组头部，添加/删除元素
    let dataList3: string[] = ['北京', '上海', '广州']
    dataList3.unshift('杭州') // 头部添加元素，结果为：[杭州', '北京', '上海', '广州']
    dataList3.shift() // 头部删除元素，结果为：['北京', '上海', '广州']

    // 删除指定位置的元素
    let dataList4: string[] = ['北京', '上海', '广州', '杭州']
    dataList4.splice(2, 1) // 从索引 2 开始删除 1 个元素，结果为：['北京', '上海', '杭州']


    // map() 方法 和 filter() 方法
    /// 1.基本使用
    const numbers = [1, 2, 3, 4, 5];
    // 返回操作后的数据：使用 map 将数组中的元素都乘以 2
    const newLis1 = numbers.map(item => item * 2) // 返回结果: [2, 4, 6, 8, 10]
    // 返回满足条件的数据：使用 filter 过滤出大于 3 的元素
    const newLis2 = numbers.filter(item => item > 3) // 返回结果: [4, 5]

    /// 2.针对模型数组的使用场景
    class Person {
      name: string
      sex: string
      age: number

      constructor(name: string, sex: string, age: number) {
        this.name = name
        this.sex = sex
        this.age = age
      }
    }

    let dataList5: Person[] = [
      new Person('小张', '男', 20),
      new Person('小明', '男', 18),
      new Person('小红', '女', 16),
    ]
    // 返回模型数组的某个属性
    const newList3 = dataList5.map((item, index) => item.name) // 返回结果: ['小张', '小明', '小红']
    // 返回满足条件的数据：年龄大于18的人
    const newList4 = dataList5.filter((item, index) => item.age > 18) // 返回结果: { 'name': '小张', 'sex': '男', 'age': 20}


    // 查找数组元素
    let dataList6: string[] = ['北京', '上海', '广州', '杭州', '成都']
    const index = dataList6.indexOf('杭州') // 3
    // 1.判断数组是否包含某个元素
    // 方式 1
    if (dataList6.indexOf('杭州') != -1) {
      console.log('包含：杭州')
    }
    // 方式 2
    if (dataList6.includes('杭州')) {
      console.log('包含：杭州')
    }

    // 2.获取数组的子数组
    // 获取索引 1 到 3（不包含索引 3）之间的元素； 即截取索引为 [1, 3) 区间的数据
    let subList = dataList6.slice(1, 3) //  返回结果: ['上海', '广州']

    // 3.查找符合条件的第一个索引或其元素
    const numbers2 = [1, 2, 5, 8, 10];
    const findIndex = numbers2.findIndex(item => item > 5) // 3
    const findItem = numbers2.find(item => item > 5) // 8


    // 其它操作
    let dataList7: string[] = ['北京', '上海', '广州']
    // 1.连接/合并两个数组
    const newList = dataList7.concat(['台湾']) // 返回结果: ['北京', '上海', '广州', '台湾']
    // 2.将数组元素连接成字符串
    const dataString = dataList7.join('，') // 返回结果: '北京，上海，广州'
    // 3.翻转数组元素的顺序
    dataList7.reverse() // 返回结果: ['广州', '上海', '北京']

    // 4.检查一个变量是否为数组
    if (Array.isArray(dataList7)) {
      console.log('是数组类型')
    }
  }
}


@Component
struct BuilderChild {
  @Builder
  customBuilder() {
  }

  // 使⽤⽗组件@Builder装饰的⽅法初始化⼦组件@BuilderParam
  @BuilderParam customBuilderParam: () => void = this.customBuilder;

  build() {
    Column() {
      this.customBuilderParam()
    }
  }
}


interface ITestData {
  cid?: string
  name?: string
  max?: number
}

interface ITestInfo {
  app_one?: string,
  app_name_xx?: string
}

interface Food {
  name: string
  price: number
  count: number
}
