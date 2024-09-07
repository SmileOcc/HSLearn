

export class ProvideModel {
  title:string|undefined
  name:string|undefined
  subModel:ProvideSubModel|undefined
  list:ProvideItemsModel[] = []

  constructor(title?:string, name?:string) {
    this.title = title
    this.name = name
  }
}

interface ProvideSubModel {
  title_sub:string|undefined
}

class ProvideItemsModel {
  title_name:string|undefined
}