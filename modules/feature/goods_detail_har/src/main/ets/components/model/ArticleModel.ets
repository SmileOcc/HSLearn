export class ArticleModel {
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