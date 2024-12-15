import { TestVoiceState } from './TestVoiceState';
import { audio } from '@kit.AudioKit';
import { speechRecognizer } from '@kit.CoreSpeechKit';
import { PermissionUtil } from '@pura/harmony-utils';
import { KeyboardAvoidMode, router, window } from '@kit.ArkUI';
import { KLogger, RouterUtils } from '@learn/common_har';

@Component
struct TestAudioSearchComp {
  @State message: string = 'Hello World';

  @State voiceState: TestVoiceState = TestVoiceState.DEFAULT
  keyword: string = ""
  audioCapturer: audio.AudioCapturer | null = null
  asrEngine: speechRecognizer.SpeechRecognitionEngine | null = null

  onChange:(keyowrd: string) => void = () => {

  }

  onComplete:(keyword: string) => void = () => {

  }

  aboutToAppear(): void {
    PermissionUtil.requestPermissions('ohos.permission.MICROPHONE').then(()=> {
      window.getLastWindow(getContext())
        .then(win => {
          win.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
        })
    })
  }

  build() {
    RelativeContainer() {
      Column() {
        // 根据状态 更改显示的文本
        if (this.voiceState !== TestVoiceState.DEFAULT) {
          Column({ space: 16 }) {
            if (this.voiceState === TestVoiceState.VOICING) {
              Text('请说，我在聆听...')
                .fontSize(14)
            } else if (this.voiceState === TestVoiceState.VOICEOVER && this.keyword === '') {
              Text('未检测到语音，请长按按钮重试')
                .fontSize(14)
            }
            Text() {
              Span('你可以这样说：')
              Span('太阳眼镜/冬款连衣裙')
                .fontColor($r('app.color.theme_color_green'))
            }
            .fontSize(12)
          }
          .justifyContent(FlexAlign.Center)
          .height(150)
        }
        Blank()
        Button() {
          Row({ space: 4 }) {
            Image($r('sys.media.ohos_ic_public_voice'))
              .width(16)
              .aspectRatio(1)
              .fillColor($r('app.color.white'))
            if (this.voiceState === TestVoiceState.VOICING) {
              Text('松开立即搜索')
                .fontSize(14)
                .fontColor($r('app.color.white'))
            } else {
              Text('长按语音搜索')
                .fontSize(14)
                .fontColor($r('app.color.white'))
            }
          }
        }
        .padding({ left: 12, right: 12 })
        .height(36)
        .linearGradient({ angle: 135, colors: [[$r('app.color.tabs_text_unselect_color'), 0], [$r('app.color.sections_tab_color_selected'), 1]] })
        .margin({ bottom: 16 })
        .gesture(LongPressGesture()// 长按手势
          .onAction(() => {
            this.startRecord()
            // 开启
            // this.voiceState = VoiceState.VOICING
          })
          .onActionEnd(() => {
            this.closeRecord()
            // 结束
            // this.voiceState = VoiceState.VOICEOVER
            // this.keyword = '么么哒'
          })
          .onActionCancel(() => {
            this.closeRecord()
            // 取消
          }))
      }
      .layoutWeight(1)
      .width('100%')
      .backgroundImage($r('app.media.yonghu'))
      .backgroundImageSize(ImageSize.Contain)
      .backgroundImagePosition(Alignment.Bottom)
      .onVisibleAreaChange([0, 1], () => {
        this.keyword = ''
        this.voiceState = TestVoiceState.DEFAULT
      })
    }
    .height('100%')
    .width('100%')
  }

  // 开启录制
  async startRecord() {
    // 开始识别
    this.asrEngine = await speechRecognizer.createEngine({
      language: 'zh-CN',
      online: 1
    })
    // 保存组件的 this，后续通过_this来使用组件
    const _this = this
    // 语音转换文字的回调函数
    this.asrEngine.setListener({
      onStart(sessionId: string, eventMessage: string) {
        console.info(`onStart, sessionId: ${sessionId} eventMessage: ${eventMessage}`);
      },
      onEvent(sessionId: string, eventCode: number, eventMessage: string) {
        console.info(`onEvent, sessionId: ${sessionId} eventCode: ${eventCode} eventMessage: ${eventMessage}`);
      },
      // 有转换结果了
      onResult(sessionId: string, result: speechRecognizer.SpeechRecognitionResult) {
        console.info(`onResult, sessionId: ${sessionId} sessionId: ${JSON.stringify(result)}`);
        // 把 录制结果传递出去即可，使用 上面保存的_this
        _this.onChange(result.result)
        _this.voiceState=TestVoiceState.VOICING
        // 录音的文本保存到 keyword 变量中，后续即可通过 keyword 来获取
        _this.keyword = result.result
      },
      // 转换完毕了
      onComplete(sessionId: string, eventMessage: string) {
        _this.voiceState = TestVoiceState.DEFAULT
        _this.onComplete(_this.keyword)
        console.info(`onComplete, sessionId: ${sessionId} eventMessage: ${eventMessage}`);
      },
      onError(sessionId: string, errorCode: number, errorMessage: string) {
        console.error(`onError, sessionId: ${sessionId} errorCode: ${errorCode} errorMessage: ${errorMessage}`);
      }
    })

    const recognizerParams: speechRecognizer.StartParams = {
      sessionId: '10000',
      audioInfo: {
        audioType: 'pcm',
        sampleRate: 16000,
        soundChannel: 1,
        sampleBit: 16
      }
    }
    // 开启监听 结合啥概念茶农的参数
    this.asrEngine?.startListening(recognizerParams)

    // 开始录音
    const audioStreamInfo: audio.AudioStreamInfo = {
      samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000,
      channels: audio.AudioChannel.CHANNEL_1,
      sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
      encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
    }
    const audioCapturerInfo: audio.AudioCapturerInfo = {
      source: audio.SourceType.SOURCE_TYPE_MIC,
      capturerFlags: 0
    }
    const audioCapturerOptions: audio.AudioCapturerOptions = {
      streamInfo: audioStreamInfo,
      capturerInfo: audioCapturerInfo
    }

    this.audioCapturer = await audio.createAudioCapturer(audioCapturerOptions)
    // 录音的数据 传递给 语音转文字的工具
    this.audioCapturer.on('readData', (buffer) => {
      console.log('mk-logger', buffer.byteLength)
      this.asrEngine?.writeAudio('10000', new Uint8Array(buffer))
    })
    await this.audioCapturer.start()
    this.voiceState = TestVoiceState.VOICING
  }

  // 关闭录制
  async closeRecord() {
    this.audioCapturer?.stop()
    this.audioCapturer?.release()
    this.asrEngine?.finish('10000')
    this.asrEngine?.cancel('10000')
    this.asrEngine?.shutdown()
    if (this.keyword) {
      this.voiceState = TestVoiceState.DEFAULT
      this.keyword = ''
    } else {
      this.voiceState = TestVoiceState.VOICEOVER
    }
  }



}

@Entry
@Component
struct TestAudioSearchCompPage {

  @StorageProp('safeTop') safeTop: number = 0
  // 关键词
  @State keyword: string = '鞋子，帽子，裤子'
  // 修改 状态栏的文字的颜色
  aboutToAppear(): void {
    window.getLastWindow(getContext())
      .then((win) => {
        win.setWindowSystemBarProperties({ statusBarContentColor: '#FFFFFF' })
      })
  }
  aboutToDisappear(): void {
    window.getLastWindow(getContext())
      .then((win) => {
        win.setWindowSystemBarProperties({ statusBarContentColor: '#000000' })
      })
  }
  toSearchResult(value: string) {
    router.pushUrl({
      url: 'pages/SearchResultPage',
      params: {
        keyword: value
      }
    })
  }
  build() {
    Column() {
      // search
      Row() {
        Image($r('app.media.arrow_left_new'))
          .width(24)
          .aspectRatio(1)
          .fillColor($r('app.color.white'))
          .margin(13)
          .onClick(() => {
            RouterUtils.backPage()
          })
        Search({ placeholder: '商品关键字...', value: this.keyword })
          .searchIcon({ src: $r('app.media.ic_search'), color: $r('app.color.tab_bar_normal_color') })// 搜索图标
          .placeholderColor($r('app.color.tab_normal_color'))// 提示文本颜色
          .placeholderFont({ size: 14 })// 提示文本大小
          .searchButton('搜索', { fontSize: 14, fontColor: $r('app.color.theme_color_green') })// 搜索按钮
          .backgroundColor($r('app.color.white'))// 背景色
          .textFont({ size: 14 })// 文字大小
          .layoutWeight(1)// 占比
          .padding(0)
          .margin(0)
          .height(36)
          .caretStyle({ color: $r('app.color.theme_color_green') })
          .defaultFocus(true)// 默认获取焦点
          .onSubmit((value) => {
            // Log.info(value)// value可以获取输入的内容
            this.toSearchResult(value)
          })

      }
      .padding({ top: this.safeTop, right: 16 })
      .linearGradient({ angle: 135, colors: [[$r('app.color.tab_bar_normal_color'), 0], [$r('app.color.tab_bar_select_color'), 1]] })
      // .linearGradient({ angle: 135, colors: [[$r('app.color.linear_begin'), 0], [$r('app.color.linear_end'), 1]] })
      // 语音搜索组件
      TestAudioSearchComp({
        onChange: (keyword: string) => {
          KLogger.info('转换的文本是:' + keyword)
          this.keyword = keyword
        },
        onComplete: (keyword: string) => {
          // AlertDialog.show({
          //   message: '最后的信息为:' + keyword
          // })
          // 跳转到搜索页即可
          this.toSearchResult(keyword)
        }
      })
    }
  }

}