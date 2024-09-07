// import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
// import { bundleManager, common } from '@kit.AbilityKit';
// import Want from '@ohos.app.ability.Want';
//
// let atManager = abilityAccessCtrl.createAtManager();
// // import bundleManager from '@ohos.bundle.bundleManager';
// // import { request } from '@kit.BasicServicesKit';
// // import { common } from '@kit.AbilityKit';
//
// // let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
// let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;
// // let tokenID = bundleFlags;
// let tokenID = 0
// // import common from '@ohos.app.ability.common';
// // import picker from '@ohos.file.picker';
// // import request from '@ohos.request';
// let context = getContext(this) as common.UIAbilityContext;
// /**
//  * 对应用权限进行校验封装 我这边默认只能一个一个授权，多个授权自己封装
//  */
// export const permissionsIsAllow = async (type: Permissions, cb:Function) => {
//   let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleFlags);
//   let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
//   tokenID = appInfo.accessTokenId;
//   console.log('tokenID', tokenID)
//   try {
//     atManager.checkAccessToken(tokenID, type).then((data) => {
//       console.log(`${type} success, data->${JSON.stringify(data)}`);
//       if (data === 0) { // 已授权
//         cb()
//       } else { // 未授权
//         AlertDialog.show(
//           {
//             title: '温馨提示',
//             message: '您还没有授权',
//             autoCancel: false,
//             alignment: DialogAlignment.Bottom,
//             gridCount: 4,
//             primaryButton: {
//               value: '取消授权',
//               action: () => {
//                 console.info('Callback when the first button is clicked')
//                 AlertDialog.show(
//                   {
//                     title: '温馨提示',
//                     message: '必须要授权才能使用，是否前往应用进行授权',
//                     autoCancel: false,
//                     alignment: DialogAlignment.Bottom,
//                     gridCount: 4,
//                     primaryButton: {
//                       value: '取消',
//                       action: () => {
//                         console.warn('用户再次取消授权')
//                       }
//                     },
//                     secondaryButton: {
//                       value: '前往授权',
//                       action: () => {
//                         //测试数据
//                         // let wantInfo = {
//                         //   action: 'action.settings.app.info',
//                         //   parameters: {
//                         //     settingsParamBundleName: 'com.example.medicaltreatment' // 打开指定应用的详情页面
//                         //   }
//                         // }
//                         let wantInfo: Want = {
//                           deviceId: '',
//                           bundleName: 'com.example.medicaltreatment',
//                           moduleName: 'entry',
//                           abilityName: 'DocAbility',
//                           parameters: {
//                             "instanceKey":'aaa' + '1'
//                           }
//
//                         }
//
//                         context.startAbility(wantInfo).then((data) => {
//                           // ...
//                           console.info('前往授权页面成功', JSON.stringify(data))
//                         }).catch((err:Error) => {
//                           // ...
//                           console.error('前往授权页面失败', JSON.stringify(err))
//                         })
//                       }
//                     }
//                   }
//                 )
//               }
//             },
//             secondaryButton: {
//               value: '确认授权',
//               action: () => {
//                 atManager.requestPermissionsFromUser(context, [type]).then((data) => {
//                   console.info("data:" + JSON.stringify(data));
//                   console.info("data permissions:" + data.permissions);
//                   console.info("data authResults:", JSON.stringify(data.authResults));
//                   let length: number = data.authResults.length;
//                   for (let i = 0; i < length; i++) {
//                     if (data.authResults[i] === 0) {
//                       // 用户授权，可以继续访问目标操作
//                       cb()
//                     } else {
//                       // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
//                       return;
//                     }
//                   }
//                 }).catch((err:Error) => {
//                   console.info("data:" + JSON.stringify(err));
//                 })
//               }
//             },
//             cancel: () => {
//               console.info('Closed callbacks')
//             }
//           }
//         )
//       }
//     }).catch((err:Error) => {
//       console.warn(`${type} fail, err->${JSON.stringify(err)}`);
//     });
//   } catch(err) {
//     console.log(`catch err->${JSON.stringify(err)}`);
//   }
// }
