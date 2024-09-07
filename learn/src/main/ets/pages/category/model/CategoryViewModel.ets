import { CategoryModel, CategorySecondModel } from './CategoryModel'

export class CategoryViewModel {

  static getData(){
    let datas:Array<CategoryModel> = []
    for (let i=0;i< 9; i++) {

      let subList:Array<CategorySecondModel> = []
      for (let j=0; j<15; j++) {
        let subItem:CategorySecondModel = {
          title:'学习二级 ' + i + '_' + j,
          img:'https://image1.8264.com/forum/201811/26/0102079ia34ia44ne2lu5z.jpg%21t1w1500h1500x9m1',
          id:'id' + i + '_' + j
        }
        subList.push(subItem)
      }

      let tModel:CategoryModel = {
        title:'科目 ' + i,
        id:'id'+i,
        list:subList

      }
      datas.push(tModel)
    }
    return datas
  }
}
