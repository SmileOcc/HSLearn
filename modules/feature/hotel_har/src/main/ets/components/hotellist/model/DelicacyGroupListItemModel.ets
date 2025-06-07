class ShopInfo{
  shopId: number | undefined
  shopName:string|undefined
  image:string|undefined
  address:string|undefined
}

export class PackageItem{
  images:string|undefined
  monthlySell: number | undefined
  discountedPrice: number | undefined
  price: number | undefined
  packageName:string|undefined
  id: number | undefined
}

class PackageInfo{
  shopMonthlySell: number | undefined
  packages: PackageItem[] = []
}

@ObservedV2
export class DelicacyGroupListItemModel {
  shopInfo:ShopInfo = new ShopInfo()
  packageInfo:PackageInfo = new PackageInfo()
  id: number | undefined
}