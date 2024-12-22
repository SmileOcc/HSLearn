import NotificationManager from '@ohos.notificationManager';
import { hsLog } from '@learn/logger_har';
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';

let notificationRequest: NotificationManager.NotificationRequest = {

  id: 1,
  content: {
    notificationContentType: NotificationManager.ContentType.NOTIFICATION_CONTENT_LONG_TEXT, // 长文本类型通知
    longText: {
      title: 'test_title',
      text: 'test_text',
      additionalText: 'test_additionalText',
      longText: 'test_longText',
      briefText: 'test_briefText',
      expandedTitle: 'test_expandedTitle',
    }
  }
}


@Entry
@Component
struct NotificationPage {
  @State message: string = 'Hello World 通知 点击';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{

            // 发布通知
            NotificationManager.publish(notificationRequest, (err) => {
              if (err) {
                hsLog.e(`[ANS] failed to publish, error[${err}]`);
                return;
              }
              hsLog.d(`[ANS] publish success`);
            });


          })
        Text('图片通知')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{

            // 发布通知
            this.publishPictureNotification()


          })
      }
      .width('100%')
    }
    .height('100%')
  }

  async publishPictureNotification() {
    // 将资源图片转化为PixelMap对象
    let resourceManager = getContext(this).resourceManager;
    let imageArray = await resourceManager.getMediaContent($r('app.media.logo').id);
    let imageResource = image.createImageSource(imageArray.buffer);
    let pixelMap = await imageResource.createPixelMap();

    let notificationRequest: NotificationManager.NotificationRequest = {
      // 描述通知的请求
      id: 1,
      content: {
        notificationContentType: NotificationManager.ContentType.NOTIFICATION_CONTENT_PICTURE, // 长文本类型通知

        picture: {
          title: '好物热销中', // 通知内容标题
          text: '展开查看详情', // 通知内容
          expandedTitle: '今日热门推荐', // 通知展开时的内容标题
          briefText: '这里一定有您喜欢的', // 通知概要内容，是对通知内容的总结
          picture: pixelMap // 通知的图片内容
        }
      }
    }

    NotificationManager.publish(notificationRequest).then(() => { // 发布通知
      hsLog.d('publish success');
    }).catch((err:BusinessError) => {
      hsLog.d(`publish failed, dcode:${err.code}, message:${err.message}`);
    });

  }
}