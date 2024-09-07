
export class CategoryModel {
  title:string|undefined
  list:Array<CategorySecondModel> = []
  id:string|undefined
}

export class CategorySecondModel {
  img:string|undefined
  title:string|undefined
  id:string|undefined
}