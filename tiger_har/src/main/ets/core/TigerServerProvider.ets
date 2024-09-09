import { ITigerAppContext } from './ITigerAppContext'
import { ITigerAppServer } from './ITigerAppServer'
import { StepLauncher } from './launchexecute/StepLanucher'
import { TigerServerType } from './launchexecute/TigerServerType'

const tigerServerMap:Map<TigerServerType,(appContext:ITigerAppContext) => ITigerAppServer> =
  new Map<TigerServerType,(appContext:ITigerAppContext) => ITigerAppServer>()

tigerServerMap.set(TigerServerType.launcher,(appContext:ITigerAppContext) => {
  return new StepLauncher(appContext)
})

// tigerServerMap.set(TigerServerType.router,(appContext:ITigerAppContext) => {
//   return appContext.onGetMainAppServer(TigerServerType.router)
// })

// ....

export namespace TigerServerProvider {

  export function bundleAppService(context:ITigerAppContext) {
    for (const key of tigerServerMap.keys()) {
      const value = tigerServerMap.get(key)
      if (value) {
        let appServer = value(context)
        context.registerAppServer(key,appServer)
      }
    }

  }

  export function unBundleAppService() {
    tigerServerMap.clear()
  }
}