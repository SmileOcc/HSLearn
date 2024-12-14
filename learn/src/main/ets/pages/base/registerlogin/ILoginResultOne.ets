export interface IUserOne {
  admin: boolean;
  chapterTops: ESObject[];
  coinCount: number;
  collectIds: ESObject[];
  email: string;
  icon: string;
  id: number;
  nickname: string;
  password: string;
  publicName: string;
  token: string;
  type: number;
  username: string;
}

export interface IServerResponseOne {
  data: IUserOne;
  errorCode: number;
  errorMsg: string;
}