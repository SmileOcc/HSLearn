import { HSIAdvModel } from "../api/HSIAdvModel";

export class HSAdvModel implements HSIAdvModel {
  id?: string | number
  title?: string
  content?: string
  url?: string
  start_date?: string
  end_date?: string
  enable?: boolean
  server_time?: string

  confirm?: string
  cancel?: string
}
