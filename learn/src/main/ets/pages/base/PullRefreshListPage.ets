import { PullToRefresh } from '@ohos/pulltorefresh'
import util from '@ohos.util';
@Entry
@Component
struct Index {
  // 需绑定列表或宫格组件
  private scroller: Scroller = new Scroller();
  @State newsData: NewsData[] = []


  aboutToAppear(): void {
    for (let i = 0; i <= 20; i++) {
      let model = new NewsData(`atitle ${i}`,'desc','desc')
      this.newsData.push(model)
    }
  }
  onPageShow(): void {
    // this.getData('news.json')
  }

  getData(contentFile:string){
    // let data = getContext(this).resourceManager.getRawFileContent(contentFile,(err,value)=> {
    //   let view: Uint8Array = new Uint8Array(value); // 使用Uint8Array读取arrayBuffer的数据
    //   let textDecoder: util.TextDecoder = util.TextDecoder.create(); // 调用util模块的TextDecoder类
    //   let res: string = textDecoder.decodeWithStream(view); // 对view解码
    //   let strArr:object[] = JSON.parse(res)
    //   let list:object[] = strArr['data']['list'];
    //   for (let i = 0; i < list.length; i++) {
    //     const contactTemp = new NewsData(list[i]['title'], list[i]['time'],list[i]['pic']);
    //     this.newsData.push(contactTemp);
    //   }
    // })
  }

  build() {
    Row() {

      PullToRefresh({
        // 必传项，列表组件所绑定的数据
        data: $newsData,
        // 必传项，需绑定传入主体布局内的列表或宫格组件
        scroller: this.scroller,
        // 必传项，自定义主体布局，内部有列表或宫格组件
        customList: () => {
          // 一个用@Builder修饰过的UI方法
          this.getListView();
        },
        // 可选项，下拉刷新回调
        onRefresh: () => {
          return new Promise<string>((resolve, reject) => {
            // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
            setTimeout(() => {
              resolve('刷新成功');
              this.newsData = [];
              // this.getData('news.json')
            }, 2000);
          });
        },
        // 可选项，上拉加载更多回调
        onLoadMore: () => {
          return new Promise<string>((resolve, reject) => {
            // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
            setTimeout(() => {
              resolve('');
              // this.getData('newsmore.json')
            }, 2000);
          });
        },
        customLoad: null,
        customRefresh: null,
      })
    }
    .height('100%')
  }

  // 必须使用@Builder修饰方法
  @Builder
  private getListView() {
    List({
      space: 3, scroller: this.scroller
    }) {
      ForEach(this.newsData, (item: NewsData,index) => {
        ListItem() {
          Row(){
            Image(item.newsPic)

              .width(80)
              .height(80)
            Column(){
              Text(item.newsTitle)
                .fontSize(18)
                .fontColor(Color.Black)
              Text(item.newsTime)
                .fontSize(16)
                .fontColor(Color.Gray)
            }
            .padding({top:10,bottom:10})
            .margin({left:10})
            .justifyContent(FlexAlign.SpaceBetween)
            .height(90)
            .alignItems(HorizontalAlign.Start)
          }
          .height(90)
          .padding({left:10,right:30,top:5,bottom:5})
          .width('100%')
        }
        .height(90)
      }, (item: NewsData, index?: number) => JSON.stringify(item) + index);
    }
    .divider({ strokeWidth: 0.5, color: Color.Gray, startMargin: 20, endMargin: 0 })
    .width('100%')
    .height('100%')
    // .backgroundColor('#f1f3f5')
    .backgroundColor(Color.Orange)
    // TODO: 知识点：必须设置列表为滑动到边缘无效果，否则无法触发pullToRefresh组件的上滑下拉方法。
    .edgeEffect(EdgeEffect.None)
  }



  aboutToDisappear() {
    this.newsData = [];

  }
}

// 新闻数据对象
class NewsData {
  newsTitle: string
  newsTime: string
  newsPic: string

  constructor( newsTitle: string, newsTime: string, newsPic: string) {
    this.newsTitle = newsTitle;
    this.newsTime = newsTime;
    this.newsPic = newsPic;
  }
}
