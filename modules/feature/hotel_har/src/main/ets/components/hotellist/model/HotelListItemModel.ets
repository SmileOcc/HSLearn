export class HotelListItemModel {
  "id": number | undefined
  "name": string | undefined
  "totalReviewsNum": string | undefined
  "address": string | undefined
  "imageUrl": string | undefined
  "price": string | undefined
  "labelList": string[] = []
}

export class RoomListItemModel {
  "id": number | undefined
  "roomName": string | undefined
  "imageUrl": string | undefined
  "price": string | undefined
  "labelList": string[] = []
}

export class OrderItemInfo {
  "id": number|undefined
  "orderStatus": string|undefined
  "hotelName": string|undefined
  "roomName": string|undefined
  "arrDate": string|undefined
  "depDate": string|undefined
  "nights": number
  "rmQty": number
  "actualPaidPrice": string|undefined
}