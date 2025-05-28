import { YWConstants } from "@learn/constants_har"

@Builder
export function TestDrawPathPageBuilder() {

  NavDestination(){
    TestDrawPathPage()
  }
}

@ComponentV2
export struct TestDrawPathPage {

  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private context22: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  build() {
    Column(){
      Scroll(){
        Column(){
          Polyline()
            .width(300)
            .height(300)
            .points([[0, 0], [100, 80], [200, 40], [150, 150], [300, 300]])
            .backgroundColor(Color.Red)
            .stroke(Color.White)
            .fill(Color.Transparent)
            .antiAlias(true)

          Polyline()
            .width(40)
            .height(40)
            .points([[20, 0], [18, 13], [30, 11],
              [20, 40], [23, 20], [10,22],[20,0]])
            .backgroundColor(Color.Blue)
            .stroke(Color.Orange)
            .fill(Color.Yellow)
            .antiAlias(true)

          Canvas(this.context22).width(100).height(100).onReady(() => {
            this.context22.fillStyle = Color.Red
            this.context22.fillRect(25, 0, 50, 50)
            this.context22.strokeStyle = Color.White
            this.context22.lineWidth = 5
            this.context22.beginPath()
            this.context22.moveTo(25, 0)
            this.context22.lineTo(75, 50)
            this.context22.moveTo(75, 0)
            this.context22.lineTo(25, 50)
            this.context22.stroke()
          })
            .backgroundColor(Color.Yellow)

          Canvas(this.context).width('100%').height('100%').onReady(() => {
            this.context.strokeStyle = Color.Blue
            this.context.fillStyle = Color.Red
            this.context.font = '100px'
            /**
             * 绘制填充文本或描边文本
             * 参数(文本内容,文本起始x坐标,文本起始y坐标)
             */
            this.context.strokeText("纯血", 88, 100)
            this.context.fillText("鸿蒙", 88, 200)

            /**
             * 渐变色，createLinearGradient(线性渐变的起点x坐标,线性渐变的起点y坐标,线性渐变的终点x坐标,线性渐变的终点y坐标)
             */
            let gradient = this.context.createLinearGradient(88, 300, 288, 300)
            gradient.addColorStop(0.0, '#fff32405')
            gradient.addColorStop(0.5, '#ff617ef3')
            gradient.addColorStop(1.0, '#ffafec06')
            this.context.fillStyle = gradient
            this.context.fillRect(88, 300, 200, 200)


            this.context.strokeStyle = Color.Red
            this.context.lineWidth = 3
            let path = new Path2D()
            path.moveTo(100, 100)
            path.lineTo(100, 200)
            path.lineTo(200, 300)
            path.closePath()
            this.context.stroke(path)

          })
            .backgroundColor(YWConstants.RandomColor())
        }
      }
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)

  }
}