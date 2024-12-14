
function camel_to_snake22(key:string, type?:boolean):string {
  if (type == true) {
    const result = key.replace(/([A-Z])/g,(x,y) => {
      return "_" + y.toLowerCase()
    })
    return result
  } else if (type == false) {
    const result = key.replace(/_([a-z|A-Z])/g,(x,y) => {//x = _a y = a
      return y.toUpperCase()
    })
    return result
  }
  return key
}

function camel_to_snake(key:string, type?:boolean): string {

  // const list = key.split("_")
  // var testResult = ""
  // for (const substr of list) {
  //   if (testResult.length == 0) {
  //     testResult = substr
  //   } else {
  //     testResult += substr.charAt(0).toUpperCase() + substr.substring(1)
  //   }
  // }

  if (type == true) {
    const result = key.replace(/([A-Z])/g,(...arg) => {
      return "_" + arg[1].toLowerCase()
    })
    return result
  } else if (type == false) {
    const result = key.replace(/_([a-z|A-Z])/g,(...arg) => {
      return arg[1].toUpperCase()
    })
    return result
  }
  return key


}

//obj中key转下划线为驼峰
export function objectToCamel(obj:object):object {

  if (obj instanceof Array) {

  }

  if (Array.isArray(obj)) {

  }


  if (typeof obj === 'object' && obj !== null) {

    return Object.keys(obj).reduce((result,key) =>({
      ...result,
      [camel_to_snake(key,false)]:objectToCamel(obj[key])
    }), {})

  }

  return obj
}

interface aaa {
  name?:string
}

interface  bbb {
  age?:number
}

type aabb = aaa & bbb & {sex?:number}