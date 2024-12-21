import { BasicDataModel, MyDataSource } from '../../../../../../modules/common_har/src/main/ets/common/BasicDataSource';
import { YWConstants } from '@learn/constants_har';

@Entry
@Component
struct SwiperStackPage {
  @State message: string = 'Hello World';

  @State swiperDataSource:MyDataSource<BasicDataModel> = new MyDataSource()

  @State currentIndex:number = 0

  aboutToAppear(): void {
    for (let i=0;i<6;i++) {
      let model:BasicDataModel = {title:'title'+i,img: i%2 == 0? $r('app.media.logo') : $r('app.media.placeholder')}
      this.swiperDataSource.pushData(model)
    }
  }

  //通过stack和offsetx实现多层级堆叠
  build() {
    Stack() {
      LazyForEach(this.swiperDataSource, (item: BasicDataModel, index: number) => {
        Stack({ alignContent: Alignment.BottomStart }) {
          Image(item.img)
            .objectFit(ImageFit.Auto)
            .width('100%')
            .height('100%')
            .borderRadius(12)
          // 轮播图底部蒙层
          Stack() {
            Column() {
            }
            .width('100%')
            .height('100%')
            .backgroundColor(Color.Black)
            .opacity(0.3)
            .borderRadius({
              topLeft: 0,
              topRight: 0,
              bottomLeft: 8,
              bottomRight: 8
            })

            Text(item.title)
              .width('100%')
              .height('100%')
              .fontSize(16)
              .fontColor(Color.White)
              .textAlign(TextAlign.Start)
              .padding(5)
          }
          .height('17%')
        }
        .gesture(
          PanGesture({ direction: PanDirection.Horizontal })
            .onActionStart((event: GestureEvent) => {
              this.startAnimation(event.offsetX < 0);
            })
        )
        .backgroundColor(YWConstants.RandomColor())
        .zIndex(this.currentIndex == index ? 1 : 0)
      })
    }
    .backgroundColor(Color.Green)
    .height(200)
    .width('100%')

  }

  startAnimation(isLeft: boolean): void {
    animateTo({
      duration: 300,
    }, () => {
      let dataLength: number = this.swiperDataSource.totalCount();
      let tempIndex: number = isLeft ? this.currentIndex + 1 : this.currentIndex - 1 + dataLength;
      this.currentIndex = tempIndex % dataLength;
    }
    )
  }

}
