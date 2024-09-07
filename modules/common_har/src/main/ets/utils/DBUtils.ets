// 1. 导入数据库模块
import relationalStore from '@ohos.data.relationalStore'
import { common } from '@kit.AbilityKit'

export  class DBUtils {
  // 表名
  private tableName: string = 'accountTable'
  // 建表语句
  private sqlCreate: string =
    'CREATE TABLE IF NOT EXISTS accountTable(' +
      'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'accountType INTEGER, ' +
      'typeText TEXT, amount INTEGER)'
  // 表字段
  private columns: string[] = ['id', 'accountType', 'typeText', 'amount']
  // 数据库核心类
  private rdbStore: relationalStore.RdbStore | null = null
  // 数据库配置
  DB_CONFIG: relationalStore.StoreConfig = {
    name: 'RdbTest.db', // 数据库文件名
    securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
  };

  /**
   * 2. 获取Rdb实例，并创建数据表
   * @param context：上下文
   * @param callback：回调函数，我们第一次获取数据时，
   * 需要在获取到rdb之后才能获取，所以有此回调
   */
  getRdbStore(context: common.UIAbilityContext, callback: Function) {
    relationalStore.getRdbStore(context, this.DB_CONFIG, (error, store) => {
      if (this.rdbStore !== null) {
        //如果已经有rdb，直接建表
        store.executeSql(this.sqlCreate)
        return
      }
      //保存rdb，下边会用
      this.rdbStore = store
      //建表
      store.executeSql(this.sqlCreate)
      console.log("test123", "successed get dbStore")
      if (callback) callback()
    })
  }

  /**
   * 3. 插入数据
   * @param data：数据对象
   * @param callback：回调函数，这里的结果是通过回调函数返回的（也可使用返回值）
   */
  insertData(data: AccountData, callback: Function) {
    //将数据对象，转换为ValuesBucket类型
    const valueBucket: relationalStore.ValuesBucket = generateBucket(data);
    // 调用insert插入数据
    this.rdbStore && this.rdbStore.insert(this.tableName, valueBucket, (err, res) => {
      if (err) {
        console.log("test123，插入失败", err)
        callback(-1)
        return
      }
      console.log("test123，插入成功", res)
      callback(res) //res为行号
    })

  }

  /**
   * 4. 获取数据
   * @param callback：接收结果的回调函数
   */
  query(callback: Function) {
    //predicates是用于添加查询条件的
    let predicates = new relationalStore.RdbPredicates(this.tableName)
    // 查询所有，不需要条件
    // predicates.equalTo("字段",数据)
    this.rdbStore && this.rdbStore.query(predicates, this.columns,
      (error, resultSet: relationalStore.ResultSet) => {
        if(error){
          console.log("test,获取数据失败",JSON.stringify(error))
          callback([])
          return
        }
        let count: number = resultSet.rowCount
        console.log("test","数据库中数据数量："+count) //没数据时返回-1或0
        if (count <= 0 || typeof count === 'string') {
          callback([])
          return
        }
        let result: AccountData[] = []
        //上来必须调用一次goToNextRow，让游标处于第一条数据，while(resultSet.goToNextRow())是最优写法
        while(resultSet.goToNextRow()) {
          let accountData:AccountData = {id:0,accountType:0,typeText:'',amount:0}
          accountData.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          accountData.typeText = resultSet.getString(resultSet.getColumnIndex('typeText'))
          accountData.accountType = resultSet.getDouble(resultSet.getColumnIndex('accountType'))
          accountData.amount = resultSet.getDouble(resultSet.getColumnIndex('amount'))
          result.push(accountData)
        }
        callback(result)
        resultSet.close()//释放数据集内容
      })
  }
}
function generateBucket(account: AccountData): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {};
  obj.accountType = account.accountType;
  obj.typeText = account.typeText;
  obj.amount = account.amount;
  return obj;
}

export class AccountData {
  id: number = -1;
  accountType: number = 0;
  typeText: string = '';
  amount: number = 0;
}