// import commonEvent from '@ohos.commonEventManager';
// import CommonEventManager from '@ohos.commonEventManager';
//
//
// export class SubscribeEvent {
//   private static subscriber:CommonEventManager.CommonEventSubscriber; // 用于保存创建成功的订阅者对象，后续使用其完成订阅及退订的动作
//   // 自定义的回调函数变量
//   private static commonCallback:(a:string,b:CommonEventData) => void
//   /**
//    * 创建订阅者
//    * @param subscribeInfo 订阅事件
//    * @callback 用户自定义回调函数
//    */
//   static createSubscriber(subscribeInfo:CommonEventManager.CommonEventSubscribeInfo, callback:(a:string,b:string)=>void) {
//     SubscribeEvent.commonCallback = callback
//     commonEvent.createSubscriber(subscribeInfo, (err, subscriber) => {
//       if (err) {
//         console.error('CreateSubscriberCallBack err = ' + JSON.stringify(err))
//       } else {
//         SubscribeEvent.subscriber = subscriber;
//         SubscribeEvent.subscribe(SubscribeEvent.subscriber)
//         console.info('Create subscriber succeed')
//       }
//     })
//   }
//
//   /**
//    * 订阅公共事件
//    * @param subscriber 订阅者
//    */
//   private static subscribe(subscriber:CommonEventManager.CommonEventSubscriber) {
//     if (subscriber != null) {
//       commonEvent.subscribe(subscriber, (err, data) => {
//         if (err) {
//           console.error('subscribe err = ' + JSON.stringify(err))
//         } else {
//           console.info('SubscribeCallBack data= ' + JSON.stringify(data))
//           SubscribeEvent.commonCallback('hello callback', data)
//         }
//       })
//     } else {
//       console.info("Need create subscriber")
//     }
//   }
// }
//
// @Entry
// @Component
// struct Faq10_1 {
//   @State message: string = ''
//
//   build() {
//     Row() {
//       Column() {
//         Text('订阅：' + this.message)
//           .fontSize(30)
//           .fontWeight(FontWeight.Bold)
//           .onClick(() => {
//             let subscribeInfo = {
//               events: ["myEvent"]
//             };
//             let callback = (a:string,b:string) => {
//               this.message = a
//             }
//             SubscribeEvent.createSubscriber(subscribeInfo,callback)
//           })
//         Text('发布')
//           .fontSize(30)
//           .fontWeight(FontWeight.Bold)
//           .onClick(() => {
//             //公共事件相关信息
//             let options = {
//               code: 0,    //公共事件的初始代码
//               data: "initial data",//公共事件的初始数据
//               isOrdered: true  //有序公共事件
//             }
//             //发布公共事件回调
//             publishCB(err) {
//               if (err) {
//                 console.error(`publish failed, code is ${err.code}, message is ${err.message}`);
//               } else {
//                 console.info("publish");
//               }
//             }
//             //发布公共事件
//             try {
//               commonEvent.publish("myEvent", options, publishCB);
//             } catch (err) {
//               console.error(`publish failed, code is ${err.code}, message is ${err.message}`);
//             }
//           })
//       }
//       .width('100%')
//     }
//     .height('100%')
//   }
// }
