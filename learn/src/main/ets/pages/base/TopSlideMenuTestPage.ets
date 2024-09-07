import { Constants } from '../../../../../../modules/common_har/src/main/ets/common/Constants';
import KLogger from '../../../../../../modules/common_har/src/main/ets/common/KLogger';

@Entry
@Component
struct TopSlideMenuTestPage {
  @State message: string = 'Hello World';
  @State menusList: SlideTitle[] = []
  @State currentIndex: number = 0

  private tWidth = Constants.SCREEN_WIDTH()
  aboutToAppear(): void {
    for (let i = 0; i < 4; i++) {
      let tModel: SlideTitle = { titles: 'title' + i, id: i + '' }
      this.menusList.push(tModel)
    }
  }

  private scrollView: Scroller = new Scroller()

  build() {
    Row() {
      Column() {
        List() {
          ForEach(this.menusList, (model: SlideTitle, index) => {
            ListItem() {
              Column() {
                Text(model.titles)
                  .fontColor(this.currentIndex == index ? Color.Blue : Color.Black)
                  .fontWeight(this.currentIndex == index ? FontWeight.Bold : FontWeight.Normal)
                  .height(30)
                if (this.currentIndex == index) {
                  Divider().width(20).height(4).backgroundColor(Color.Blue)
                }
              }
              .justifyContent(FlexAlign.Start)
            }
            .width('25%')
            .height(44)
            .onClick(() => {
              if (this.currentIndex != index) {

                this.currentIndex = index;
                this.scrollView.scrollTo({xOffset:this.currentIndex * this.tWidth,yOffset:0, animation:true});
                KLogger.debug(`==== tap: ${this.currentIndex}`)

                // 记录点击index
                // this.currentIndex = index;
                // 动画效果
                // animateTo({
                //   duration: Math.abs(index - this.currentIndex) * 300,
                //   curve: Curve.EaseInOut,
                //   iterations: 3, //this.iterationsDefault,
                //   playMode: PlayMode.Normal,
                //   onFinish: () => {
                //     // this.currentIndex = index;
                //     // this.scrollView.scrollTo({xOffset:this.currentIndex * this.tWidth,yOffset:0});
                //   }
                // }, () => {
                //   // this.transitionX = this.getTransitionX(idx);
                // })
              }
            })
          })
        }
        .height(44)
        .width('100%')
        .listDirection(Axis.Horizontal)
        .backgroundColor(Color.Green)

        Scroll(this.scrollView) {
          Row() {
            ForEach(this.menusList, (model: SlideTitle, index) => {
              Column() {

                Text(model.titles)
              }
              .width('25%')
              .backgroundColor(Constants.RandomColor())
              .height('100%')
            })
          }
          .width('400%')
          .height('100%')

        }
        .scrollable(ScrollDirection.Horizontal)
        .enablePaging(true) //以页滑动
        .layoutWeight(1)
        .width('100%')
        .backgroundColor(Color.Gray)
        .onScrollStart(()=>{

        })
        .onScroll((offsetX)=>{
          let offsetXX = this.scrollView.currentOffset().xOffset
          let index = (offsetX + this.tWidth / 2.0) / this.tWidth

          KLogger.debug(`==== scroll end: ${offsetX}  ==  ${offsetXX}  ${index}`)

          if (this.currentIndex != index && index < 4) {
            this.currentIndex = index
          }
        })

        .onScrollStop(()=>{

        })
      }
      .height('100%')
      .width('100%')
    }
    .height('100%')
  }
}

class SlideTitle {
  titles: string | undefined
  id: string | undefined
}