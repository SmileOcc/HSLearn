import common from '@ohos.app.ability.common';
import Prompt from '@system.prompt';
import router from '@ohos.router';
import dataPreferences from '@ohos.data.preferences';

import mediaquery from '@ohos.mediaquery';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { Callback } from '@kit.BasicServicesKit';
import { HotWordsModel } from './model/HotWordsModel';
import { ThinkWordModel } from './model/ThinkWordModel';
import { HistoryWordModel } from './model/HistoryWordModel';
import RouterUtils from '../../../../../../modules/common_har/src/main/ets/utils/RouterUtils';
import { YWConstants } from '@learn/constants_har';

const MAX_LINES: number = 3;

@Entry
@Component
struct SearchResultPage {
  private hotTopicList1: Array<string> = [
    '四种醉驾可从宽处理',
    '冰面摔倒至腹腔出血',
    '董宇辉复播',
    '朱一龙拍戏受伤送医',
    '音乐节求婚观众退票',
    '周杰伦新歌歌名',
    '用好“改革开放”这关键一招',
    '男子冬钓失联 遗体在冰缝中被发现',
    '女孩用科目三跳绳 获省级比赛第1名',
    '美丽乡村 幸福生活',
  ]
  private hotTopicList2: Array<string> = [
    '醉驾轻微可不起诉',
    '狄龙被驱逐',
    '劳荣枝希望还清花呗',
    '周海媚告别仪式完成',
    '董宇辉兼任副总裁',
    '小米智能锁自动开门',
    '李家超:基本法第23条明年内实施',
    '山东两幼师出租房内遇害',
    '南京同曦老总大闹裁判休息室',
    '女子出车祸鲨鱼夹插入后脑勺',
    '官方辟谣南京过江隧道连环追尾',
    '上海地铁开启疯狂动物城模式',
    '上海地铁开启疯狂动物城模式1',
    '上海地铁开启疯狂动物城模式2',
    '上海地铁开启疯狂动物城模式3',
  ]
  private hotTopicList3: Array<string> = [
    '朱丹好友起诉朱丹',
    '"中年大叔"自拍刷屏',
    '西方臻选回应被封号',
    '草莓价格大跳水',
    '库里三分球8中0',
    '国足开启亚洲杯备战',
  ]
  private currentHistoryHeight: number = 0
  @State toastBottom: number = 0;
  @State currentInputBoxContent: string = ''
  private controller = new TextInputController()
  private hotWords: Array<HotWordsModel> = []
  @State historyWords: Array<HistoryWordModel> = []
  @State inputBoxFocus: boolean = false;
  @State hotwordLines: number = 0
  @State searchButtonText: string = '取消'
  private swiperController: SwiperController = new SwiperController()
  private data: MyDataSource = new MyDataSource([])
  private currentLineNumbs: number = 0
  private context = getContext(this) as common.UIAbilityContext;
  @State screenDirection: ConfigurationConstant.Direction | undefined = this.context.config.direction
  @State showThinkWord: boolean = false
  @State thinkWords: Array<ThinkWordModel> = []
  // 当设备横屏时条件成立
  listener = mediaquery.matchMediaSync('(orientation: landscape)');
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      historyWords: $historyWords,
      title: '确认全部删除？',
      cancel: this.onCancel,
      confirm: this.onAccept,
    }),
    alignment: DialogAlignment.Default, // 可设置dialog的对齐方式，设定显示在底部或中间等，默认为底部显示
  })

  onCancel() {

  }

  onAccept() {
    console.log('当前数组长度：' + this.historyWords.length)
  }

  configureParamsByScreenDirection() {

    if (this.screenDirection == 0) {
      this.toastBottom = (AppStorage.get(YWConstants.kStorageHeight) as number) / 2
    } else {
      this.toastBottom = (AppStorage.get(YWConstants.kStorageHeight) as number) / 2
    }
  }

  DATASOURCE: string[] = [
    '联想词测试',
    '测试联想词',
    '全城寻找测试在哪里',
    '找不到人',
    '哈尔滨的啤酒好喝',
    'HarmonyOS版权归属华为'
  ]

  simulatorThinkWord() {

    this.thinkWords = []

    this.DATASOURCE.forEach((value: string, index: number) => {
      let s: string = ''
      let m: string = ''
      let e: string = ''
      let hIndex: number = -1

      let position = value.indexOf(this.currentInputBoxContent)
      if (position != -1) {

        if (position == 0) {
          s = value.substring(0, this.currentInputBoxContent.length)
        } else {
          s = value.substring(0, position)
        }

        if (s.length < value.length) {

          position = value.substring(s.length).indexOf(this.currentInputBoxContent)

          if (position == -1) {
            m = value.substring(s.length)
          } else {
            m = value.substring(s.length, this.currentInputBoxContent.length)
          }

          if (s.length + m.length < value.length) {
            e = value.substring(s.length + m.length)
          }

        }

        if (s === this.currentInputBoxContent) {
          hIndex = 0
        } else if (m === this.currentInputBoxContent) {
          hIndex = 1
        } else if (e === this.currentInputBoxContent) {
          hIndex = 2
        }

        this.thinkWords.push(new ThinkWordModel('#000000', '#ff0000', hIndex, s, m, e))
      }

    })

  }

  onPortrait(mediaQueryResult: mediaquery.MediaQueryResult) {
    if (mediaQueryResult.matches) {
      //横屏
      this.screenDirection = 1
    } else {
      //竖屏
      this.screenDirection = 0
    }

    setTimeout(() => {
      this.configureParamsByScreenDirection()
    }, 300)
  }

  aboutToAppear() {
    this.searchButtonText = '取消'

    let list: number[] = []
    for (let i = 1; i <= 3; i++) {
      list.push(i);
    }
    this.data = new MyDataSource(list)

    this.hotWords.push(new HotWordsModel('HarmonyOS', '#E84026', 'https://developer.harmonyos.com/'))
    this.hotWords.push(new HotWordsModel('实名认证', '#5d5d5d'))
    this.hotWords.push(new HotWordsModel('HMS Core', '#5d5d5d'))
    this.hotWords.push(new HotWordsModel('Serverless', '#5d5d5d'))
    this.hotWords.push(new HotWordsModel('生态市场', '#5d5d5d'))
    this.hotWords.push(new HotWordsModel('应用上架', '#5d5d5d'))
    this.hotWords.push(new HotWordsModel('仓颉', '#5d5d5d'))
    this.hotWords.push(new HotWordsModel('HUAWEI HiAI', '#5d5d5d'))
    this.hotWords.push(new HotWordsModel('表盘', '#5d5d5d'))
    this.hotWords.push(new HotWordsModel('推送', '#5d5d5d'))
    this.hotWords.push(new HotWordsModel('主题', '#5d5d5d'))
    this.hotWords.push(new HotWordsModel('公测', '#5d5d5d'))

    //方式一
    let portraitFunc: Callback<mediaquery.MediaQueryResult> = this.onPortrait.bind(this)
    this.listener.on('change', portraitFunc)

    //方式二
    // this.listener = mediaquery.matchMediaSync('(orientation: landscape)'); //监听横屏事件
    // this.listener.on('change',(result)=>{
    //   this.onPortrait(result)
    // })

    // this.toastBottom = (AppStorage.Get(CommonConstants.ScreenHeight) as number) / 2

    dataPreferences.getPreferences(getContext(this), 'HistoryWord', (err, preferences) => {
      if (err) {
        console.error(`Failed to get preferences. Code:${err.code},message:${err.message}`);
        return;
      }
      console.info('Succeeded in getting preferences.');
      // 进行相关数据操作
    })

  }

  historyWordIndex: number = 1

  submitData(wordModel: HistoryWordModel) {
    if (wordModel.word.length != 0) {

      let exist: boolean = false
      let existIndex: number = -1

      this.historyWords.forEach((item, index) => {
        if (item.word === wordModel.word) {
          if (index != 0) {
            this.historyWords.splice(index, 1)
          }
          exist = true
          existIndex = index
        }
      });

      if (existIndex == 0) {
        console.log('不需要刷新页面')
        this.currentInputBoxContent = ''
        this.searchButtonText = '取消'
        this.showThinkWord = false
        return
      }

      if (!exist) {
        wordModel.index = this.historyWordIndex++
        this.historyWords.push(wordModel)
      } else {
        this.historyWordIndex++
        this.historyWords.push(new HistoryWordModel(this.historyWordIndex, wordModel.word, wordModel.link))
      }

      let Test: Array<HistoryWordModel> = []

      this.historyWords.forEach((item, index) => {
        Test.push(item)
      })

      Test.sort((a: HistoryWordModel, b: HistoryWordModel) => {
        return b.index - a.index
      })

      this.historyWords.length = 0

      Test.forEach((item, index) => {
        this.historyWords.push(item)
      })

      this.currentInputBoxContent = ''
      this.searchButtonText = '取消'
      this.showThinkWord = false
    } else {
      Prompt.showToast({
        message: '请输入关键词',
        bottom: px2vp(this.toastBottom)
      })
    }
  }

  build() {

    Column() {

      //一. 输入框 + 搜索按钮
      Row() {
        Stack() {
          TextInput({ placeholder: '热词搜索', controller: this.controller, text: this.currentInputBoxContent })
            .height('40vp')
            .fontSize('20fp')
            .enterKeyType(EnterKeyType.Search)
            .placeholderColor(Color.Grey)
            .placeholderFont({ size: '14vp', weight: 400 })
            .width('100%')
            .padding({ left: '35vp', right: '35vp' })
            .borderStyle(BorderStyle.Solid)
            .borderWidth('1vp')
            .borderColor(this.currentInputBoxContent.length != 0 ? YWConstants.COLOR_333333 : YWConstants.COLOR_EEEEEE)
            .onChange((currentContent) => {

              this.currentInputBoxContent = currentContent
              if (this.currentInputBoxContent.length != 0) {
                this.searchButtonText = '搜索'
                this.showThinkWord = true
                this.simulatorThinkWord()
              } else {
                this.searchButtonText = '取消'
                this.showThinkWord = false
              }
            })
            .onSubmit((enterKey: EnterKeyType) => {
              this.submitData(new HistoryWordModel(0, this.currentInputBoxContent));
            })

          Row() {
            Image($r('app.media.search_gray')).width('20vp').height('20vp')
            if (this.currentInputBoxContent.length != 0) {
              Image($r('app.media.search_close')).width('20vp').height('20vp')
                .onClick(() => {
                  this.currentInputBoxContent = ''
                })
            }
          }.width('100%')
          .hitTestBehavior(HitTestMode.None)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ left: '10vp', right: '10vp' })

        }.alignContent(Alignment.Start)
        .width('83%')

        Text(this.searchButtonText)
          .fontSize('15fp')
          .borderRadius('10vp')
          .padding('5vp')// .backgroundColor(Color.Red)
          .fontColor(YWConstants.COLOR_333333)
          .width('15%')
          .textAlign(TextAlign.Center)
          .onClick(() => {
            if ('搜索' === this.searchButtonText) {
              this.submitData(new HistoryWordModel(0, this.currentInputBoxContent));
            } else {
              if ("1" === router.getLength()) {
                this.context.terminateSelf() //停止当前UIAbility实例
              } else {
                router.back()
              }
            }
          })
          .stateStyles({
            focused: {
              .backgroundColor(Color.Orange)
            },
            pressed: {
              .backgroundColor(Color.Orange)
            },
            normal: {
              .backgroundColor(Color.Red)
            }
          })

      }.justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: '10vp', right: '10vp' })
      .width('100%')

      Scroll() {
        Stack() {

          if (this.showThinkWord) {//搜索联想列表
            Column() {
              ForEach(this.thinkWords, (item: ThinkWordModel, index) => {

                Text() {
                  if (item.wordStart && item.wordStart.length != 0) {
                    Span(item.wordStart)
                      .fontSize(18)
                      .fontColor(item.highLightIndex == 0 ? item.highLightColor : item.normalColor)
                  }
                  if (item.wordMid && item.wordMid.length != 0) {
                    Span(item.wordMid)
                      .fontSize(18)
                      .fontColor(item.highLightIndex == 1 ? item.highLightColor : item.normalColor)
                  }
                  if (item.wordEnd && item.wordEnd.length != 0) {
                    Span(item.wordEnd)
                      .fontSize(18)
                      .fontColor(item.highLightIndex == 2 ? item.highLightColor : item.normalColor)
                  }
                }
                .width('100%')
                .height(50)
                .textAlign(TextAlign.Center)
                .fontSize(18)
                .textAlign(TextAlign.Start)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .onClick(() => {
                  RouterUtils.jumpRouter('pages/web/WebPage')
                })

                Divider().width('100%').height(1).color(Color.Grey)
              })


            }
            .width('100%').height('100%')
            .padding({ left: '12vp', right: '12vp' })
            .backgroundColor(Color.White)

          } else {

            Column() {
              //二. 搜索历史
              if (this.historyWords.length != 0) {

                Row() {

                  Text('历史搜索')
                    .fontSize('20fp')
                    .fontWeight(FontWeight.Bold)

                  Image($r('app.media.ic_public_delete'))
                    .width('20vp')
                    .height('20vp')
                    .backgroundColor(Color.Blue)
                    .onClick(() => {
                      this.dialogController.open()
                    })

                }.width('100%')
                .margin({ top: '20vp' })
                .padding({ left: '10vp', right: '10vp' })
                .justifyContent(FlexAlign.SpaceBetween)

                Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
                  ForEach(this.historyWords, (item: HistoryWordModel, index) => {

                    Text(item.word)
                      .fontSize(15)
                      .margin(5)
                      .fontColor('#5d5d5d')
                      .maxLines(1)
                      .backgroundColor('#f6f6f6')
                      .padding({ left: 20, right: 20, top: 5, bottom: 5 })
                      .borderRadius('30vp')
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .onClick(() => {
                        this.submitData(item);
                      })
                      .onClick(()=>{
                        RouterUtils.jumpRouter('pages/web/WebPage')
                      })
                  })
                }.width('100%')
                .margin({ top: '12vp' })
                .onAreaChange((oldValue: Area, newValue: Area) => {

                  let newHeight = newValue.height as number

                  if (this.currentHistoryHeight == 0) {
                    this.currentHistoryHeight = newHeight
                  }

                  this.currentLineNumbs = newHeight / this.currentHistoryHeight

                  console.log('当前行数: ' + this.currentLineNumbs)

                  if (this.currentLineNumbs >= MAX_LINES) {
                    this.historyWords = this.historyWords.slice(0, this.historyWords.length - 1)
                  }

                })

              }

              //三. 热门搜索
              Text('热门搜索')
                .fontSize('20fp')
                .width('100%')
                .fontWeight(FontWeight.Bold)
                .margin({ left: '10vp', top: '20vp' })

              Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
                ForEach(this.hotWords, (item: HotWordsModel, index) => {

                  Text(item.word)
                    .fontSize(15)
                    .margin(5)
                    .fontColor(item.wordColor)
                    .backgroundColor('#f6f6f6')
                    .padding({ left: 20, right: 20, top: 5, bottom: 5 })
                    .borderRadius('30vp')
                    .onClick(() => {
                      if (this.hotWords[index].wordLink && this.hotWords[index].wordLink.length != 0) {

                        router.pushUrl({
                          url: 'pages/web/WebPage', params: {
                            "targetUrl": this.hotWords[index].wordLink,
                          }
                        })
                          .then(() => {
                            console.info('Succeeded in jumping to the second page.')
                          }).catch((error: string) => {
                          console.log(error)
                        })
                      } else if (this.hotWords[index].word) {
                        this.submitData(new HistoryWordModel(0, this.hotWords[index].word));
                      }
                    })
                })
              }
              .width('100%')
              .margin({ top: '12vp' })
              .onAreaChange((oldValue: Area, newValue: Area) => {
                console.log('热词高度：' + newValue.height + '')
              })

              //四. 热门帖子
              Text('热门帖子')
                .fontSize('20fp')
                .width('100%')
                .fontWeight(FontWeight.Bold)
                .margin({ left: '10vp', top: '20vp' })

              Swiper(this.swiperController) {

                LazyForEach(this.data, (item: string, index: number) => {

                  if (index == 0) {
                    this.swiperList(this.hotTopicList1)
                  } else if (index == 1) {
                    this.swiperList(this.hotTopicList2)
                  } else if (index == 2) {
                    this.swiperList(this.hotTopicList3)
                  }

                }, (item: string) => item)

              }
              .padding({ bottom: '50vp' })
              .displayMode(SwiperDisplayMode.AUTO_LINEAR)
              .margin({ top: '12vp' })
              .cachedCount(2)
              .index(1)
              .indicator(false)
              .loop(true)
              .itemSpace(0)
              .curve(Curve.Linear)
            }

          }

        }
      }.scrollBar(BarState.Off)

    }
    .padding({ top: 10 })
  }

  @Builder
  swiperList(data: string[]) {
    Column() {
      ForEach(data, (da: string, i) => {

        if (i == 0) {
          Text() {
            Span((i + 1) + '. ').fontColor('#E84026').fontSize(20)
            Span(da).fontColor('#5d5d5d').fontSize(18)
          }.width('100%').height(50)
          .onClick(()=>{
            RouterUtils.jumpRouter('pages/web/WebPage')
          })
        } else if (i == 1) {
          Text() {
            Span((i + 1) + '. ').fontColor('#ED6F21').fontSize(20)
            Span(da).fontColor('#5d5d5d').fontSize(18)
          }.width('100%').height(50)
          .onClick(()=>{
            RouterUtils.jumpRouter('pages/web/WebPage')
          })
        } else if (i == 2) {
          Text() {
            Span((i + 1) + '. ').fontColor('#F9A01E').fontSize(20)
            Span(da).fontColor('#5d5d5d').fontSize(18)
          }.width('100%').height(50)
          .onClick(()=>{
            RouterUtils.jumpRouter('pages/web/WebPage')
          })
        } else {
          Text((i + 1) + '. ' + da)
            .fontColor('#5d5d5d')
            .width('100%')
            .height(50)
            .textAlign(TextAlign.Center)
            .fontSize(18)
            .textAlign(TextAlign.Start)
            .onClick(()=>{
              RouterUtils.jumpRouter('pages/web/WebPage')
            })
        }

        if (i != this.hotTopicList1.length - 1) {
          Divider().width('100%').vertical(false)
        }

      })
    }.borderRadius('10vp')
    .margin({ left: '10vp', right: '10vp', bottom: '25vp' })
    .backgroundColor('#f6f6f6')
    .padding('10vp')

  }
}

@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController
  title: string = ''
  @Link historyWords: Array<string>
  cancel: (() => void) | undefined
  confirm: (() => void) | undefined

  build() {
    Column() {
      Text(this.title).fontSize(20).margin({ top: 10, bottom: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller.close()
            this.cancel ? this.cancel() : null
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确认')
          .onClick(() => {
            this.controller.close()
            this.confirm ? this.confirm() : null
            this.historyWords = []
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
  }
}

class MyDataSource implements IDataSource {
  private list: number[] = []
  private listener: DataChangeListener | undefined

  constructor(list: number[]) {
    this.list = list
  }

  totalCount(): number {
    return this.list.length
  }

  getData(index: number): number {
    return this.list[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    this.listener = listener
  }

  unregisterDataChangeListener() {
  }
}
