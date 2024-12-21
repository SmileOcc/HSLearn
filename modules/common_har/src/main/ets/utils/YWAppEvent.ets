// @Desc: 对hiAppEvent的使用，监听应用崩溃情况、点击等
import { hiAppEvent } from "@kit.PerformanceAnalysisKit";
import { BusinessError } from '@kit.BasicServicesKit';

import KLogger from "../common/KLogger"
const TAG = 'AppEvent';

export class YWAppEvent {
  static crashSubscribe() {
    // 开发者完成参数键值对赋值
    let params: Record<string, hiAppEvent.ParamType> = {
      "test_data": 100,
    };
    // 开发者可以设置崩溃事件的自定义参数
    hiAppEvent.setEventParam(params, hiAppEvent.domain.OS, hiAppEvent.event.APP_CRASH).then(() => {
      KLogger.info(TAG, `HiAppEvent success to set svent param`);
    }).catch((err: BusinessError) => {
      KLogger.error(TAG, `HiAppEvent code: ${err.code}, message: ${err.message}`);
    });
    // 添加应用事件观察者方法，可用于订阅应用事件
    hiAppEvent.addWatcher({
      // 开发者可以自定义观察者名称，系统会使用名称来标识不同的观察者
      name: "watcherAppCrash",
      // 开发者可以订阅感兴趣的系统事件，此处是订阅了崩溃事件
      appEventFilters: [
        {
          domain: hiAppEvent.domain.OS,
          names: [hiAppEvent.event.APP_CRASH, hiAppEvent.event.APP_FREEZE]
        }
      ],
      // TODO：知识点：获取事件组信息。开发者可以自行实现订阅回调函数，崩溃和卡死事件下次应用启动时会回调给开发者
      onReceive: async (domain: string, appEventGroups: Array<hiAppEvent.AppEventGroup>) => {
        KLogger.info(TAG, `HiAppEvent onReceive: domain=${domain}`);
        /**
         * 获取事件组信息，与ApplicationException文件中的@StorageLink('faultMessage') faultMessage进行双向数据绑定
         * 性能关注：如果开发者有同步的代码需要执行耗时操作，建议起worker或者taskpool线程来处理。但如果开发者使用storage和preferences，直接调用即可。
         */
        for (const eventGroup of appEventGroups) {
          // 开发者可以根据事件集合中的事件名称区分不同的系统事件
          KLogger.info(TAG, `HiAppEvent eventName=${eventGroup.name}`);
          for (const eventInfo of eventGroup.appEventInfos) {
            // 开发者可以对事件集合中的事件数据进行自定义处理，此处是将事件数据打印在日志中
            KLogger.info(TAG, `HiAppEvent eventInfo.domain=${eventInfo.domain}`);
            KLogger.info(TAG, `HiAppEvent eventInfo.name=${eventInfo.name}`);
            KLogger.info(TAG, `HiAppEvent eventInfo.eventType=${eventInfo.eventType}`);
            // 开发者可以获取到崩溃事件发生的时间戳
            KLogger.info(TAG, `HiAppEvent eventInfo.params.time=${eventInfo.params['time']}`);
            // 开发者可以获取到崩溃事件发生的崩溃类型
            KLogger.info(TAG, `HiAppEvent eventInfo.params.crash_type=${eventInfo.params['crash_type']}`);
            // 开发者可以获取到崩溃应用的前后台状态
            KLogger.info(TAG, `HiAppEvent eventInfo.params.foreground=${eventInfo.params['foreground']}`);
            // 开发者可以获取到崩溃应用的版本信息
            KLogger.info(TAG, `HiAppEvent eventInfo.params.bundle_version=${eventInfo.params['bundle_version']}`);
            // 开发者可以获取到崩溃应用的包名
            KLogger.info(TAG, `HiAppEvent eventInfo.params.bundle_name=${eventInfo.params['bundle_name']}`);
            // 开发者可以获取到崩溃应用的进程id
            KLogger.info(TAG, `HiAppEvent eventInfo.params.pid=${eventInfo.params['pid']}`);
            KLogger.info(TAG, `HiAppEvent eventInfo.params.uid=${eventInfo.params['uid']}`);
            KLogger.info(TAG, `HiAppEvent eventInfo.params.uuid=${eventInfo.params['uuid']}`);
            // 开发者可以获取到崩溃事件发生的异常类型、异常原因和异常调用栈
            KLogger.info(TAG, `HiAppEvent eventInfo.params.exception=${JSON.stringify(eventInfo.params['exception'])}`);
            // 开发者可以获取到崩溃事件发生时日志信息
            KLogger.info(TAG, `HiAppEvent eventInfo.params.hilog.size=${eventInfo.params['hilog'].length}`);
            // 开发者可以获取到崩溃事件发生时的故障日志文件
            KLogger.info(TAG, `HiAppEvent eventInfo.params.external_log=${JSON.stringify(eventInfo.params['external_log'])}`);
            KLogger.info(TAG, `HiAppEvent eventInfo.params.log_over_limit=${eventInfo.params['log_over_limit']}`);
            // 开发者可以获取到崩溃事件的自定义数据test_data
            KLogger.info(TAG, `HiAppEvent eventInfo.params.test_data=${eventInfo.params['test_data']}`);
          }
        }
      }
    });
  }

  static clickSubscribe() {
    hiAppEvent.addWatcher({
      // 开发者可以自定义观察者名称，系统会使用名称来标识不同的观察者
      name: "watcherClick",
      // 开发者可以订阅感兴趣的应用事件，此处是订阅了按钮事件
      appEventFilters: [{ domain: "button" }],
      // 开发者可以设置订阅回调触发的条件，此处是设置为事件打点数量满足1个
      triggerCondition: { row: 1 },
      // 开发者可以自行实现订阅回调函数，以便对订阅获取到的事件打点数据进行自定义处理
      onTrigger: (curRow: number, curSize: number, holder: hiAppEvent.AppEventPackageHolder) => {
        // 返回的holder对象为null，表示订阅过程发生异常，因此在记录错误日志后直接返回
        if (holder == null) {
          KLogger.error(TAG, 'testTag', "HiAppEvent holder is null");
          return;
        }
        KLogger.info(TAG, `HiAppEvent onTrigger: curRow=${curRow}, curSize=${curSize}`);
        let eventPkg: hiAppEvent.AppEventPackage | null = null;
        // 根据设置阈值大小（默认为512KB）去获取订阅事件包，直到将订阅数据全部取出
        // 返回的事件包对象为null，表示当前订阅数据已被全部取出，此次订阅回调触发结束
        while ((eventPkg = holder.takeNext()) != null) {
          // 开发者可以对事件包中的事件打点数据进行自定义处理，此处是将事件打点数据打印在日志中
          KLogger.info(TAG, `HiAppEvent eventPkg.packageId=${eventPkg.packageId}`);
          KLogger.info(TAG, `HiAppEvent eventPkg.row=${eventPkg.row}`);
          KLogger.info(TAG, `HiAppEvent eventPkg.size={eventPkg.size}`);
          for (const eventInfo of eventPkg.data) {
            KLogger.info(TAG, `HiAppEvent eventPkg.info=${eventInfo}`);
          }
        }
      }
    });
  }

  /**
   * 页面埋点：使用 Navigation 组件时，监听每个页面的逗留时间
   * @param context
   */
  static onNavigationPageSubscribe(context: UIContext) {
    context.getUIObserver().on('navDestinationUpdate', (info) => {
      KLogger.info(TAG, `page: ${info.name} | status: ${info.state.valueOf()}`);
    })
  }
}