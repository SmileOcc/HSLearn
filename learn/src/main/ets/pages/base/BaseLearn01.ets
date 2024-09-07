
/**
 命名规则
 (1)字母，下划线，数字，字符串，$和他们的组合，数字不能在前面
 (2)不能是关键字命名
 (3)严格区分大小写
 * */


//function 函数名() { 代码块 }
function sayHi() { console.log('你好') }  sayHi()

function add(num1:number,num2:number) {
  let result:number = num1+num2
  return result
}


//函数的可选参数
function fn(a?:string,b?:number ) { console.log(a||'ab',b|| 123 ) }
//函数的默认参数
function fun2(a:string='哈哈',b:number=123) {console.log(a,b)}
fun2('haha',567)

//箭头函数
//let xx = () => { 代码块 }     xx()
// let xx1 = (num：number) => { 代码块 }   let  yy: number = xx1(123)  console.log('数字是',yy)
let xx1 = (num1:number,num2:number) => {
  return num1+num2 }
  console.log('和是',xx1(1,2)
)


//对象三步走
//(1)定义对象的类型
interface Person { name:string,age:number|string,gender:'男'|'女',bobby:string[]|string, eat:(food:string) => void }
//(2) 定义对象
let xiaoli:Person = {
  name:'小李',age:18,gender:'男',bobby:['滑雪','吃火锅'],eat:(food:string)=>{
    console.log(`我要吃${food}`)}
}
console.log('名字',xiaoli.name)
xiaoli.eat('海底捞')


//联合类型
let score: number|string = 'A'
score = 98
//枚举
enum Gender {
  nan=1,
  nv=0
}
//对象和枚举的名字首字母一般大写


//类型转换
//字符串转数字
//Number() => 字符串转换成数字，转换失败返回NaN
//NaN(not a number)
//转整数
//parseInt() 去掉小数部分将字符串类型转成数字型，转换失败返回NaN, 数字开头的可以转
// 三步：去掉引号，找数字开头的，去掉小数，失败就返回NaN
let str3 = "11"
let str5 = "22"
console.log('结果是：', parseInt(str3))
console.log('结果是：', parseInt(str5))

//parseFloat()
//取小数
// parseFloat()
let str6:string = '1.00'
let str7:string = 'a1.01'
console.log('结果是：',parseFloat(str6))
console.log('结果是：',parseFloat(str7))


//数字转字符串  数字是一定转成字符串
//toString()
//数字 => 字符串  对象.方法()
let numb11 = 16
let xstr = numb11.toString()
//toFixed()   四舍五入转字符串
//加引号，小数部分四舍五入