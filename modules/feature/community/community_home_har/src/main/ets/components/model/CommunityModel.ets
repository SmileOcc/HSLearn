import { HSAccountModel } from "@learn/userinfo_har";

@ObservedV2
export class CommunityModel {
  items: CommunityArticleInfo[] = []
  banners: CommunityBannerInfo[] = []
  accountInfo?: HSAccountModel
}

export class CommunityBannerInfo {
  id: string = ""
  imageUrl?: string = ''
  advUrl?: string = ""
  desc?: string = ""
}

export class CommunityArticleInfo {
  id: number;
  uri: Resource;
  title: ResourceStr;
  content: ResourceStr;
  views: number;
  likes: number;
  isLike: boolean;
  collections: number;
  isCollection: boolean;
  type: number;

  constructor(id: number, uri: Resource, title: ResourceStr, content: ResourceStr, views: number, likes: number,
    isLike: boolean, collections: number, isCollection: boolean, type: number) {
    this.id = id;
    this.uri = uri;
    this.title = title;
    this.content = content;
    this.views = views;
    this.likes = likes;
    this.isLike = isLike;
    this.collections = collections;
    this.isCollection = isCollection;
    this.type = type;
  }

  toString(): string {
    return this.id.toString() + '  ' + this.title;
  }
}