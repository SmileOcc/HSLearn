
export function NodeInvokeApi(api:string, plug:object, context?: object, data?: object, callBack?:(params?: object)=>void) {
  plug[api](context, data, callBack)

}