import { HSIBaseModel } from "@learn/base_model_har"

export interface HSIAdvModel extends HSIBaseModel {
  id: string | number
  title?: string
  content?: string
  imageUrl?: string
  url?: string
  start_date?: string
  end_date?: string
  enable?: boolean
  server_time?: string
  linkUrl?: string
  ratingNumber?: number

  // 宽高比
  ratio?: number

  confirm?: string
  cancel?: string
  bgColor?: ResourceColor
  type?: string
  interType?: number

  items?: HSIAdvModel[]
}