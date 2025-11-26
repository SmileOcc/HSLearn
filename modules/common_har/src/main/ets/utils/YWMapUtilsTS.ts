
//Map转字符串 entries也只能转一层，嵌套的还是[object object]
//感觉是鸿蒙的bug
export function MapToStringTS(data: Map<string, Object>): string {
  let objectData = Object.entries(data)
  return JSON.stringify(objectData)
}