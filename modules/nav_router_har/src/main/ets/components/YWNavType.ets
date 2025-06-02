export type YWNavIDType = YWLocalNavType | string

export type YWNavCustomIDType = string

export type CustomerNavAnimation = (from: NavContentInfo, to: NavContentInfo,
  operation: NavigationOperation) => NavigationAnimatedTransition | undefined

/*
 * 设置导航栏显示改变模式枚举值
 */
export enum YWNavMode {
  DefaultMode, // 默认模式
  FoldMode, // 折叠模式
  ChildPageMode, // 进入子页面模式
  HomePageMode // 返回首页模式
}

export enum YWNavParamsKey {
  SESSION = "session",
  NAV_ULR_KEY = "navUrlKey"
}

export enum YWLocalNavType {

  //APP最外层路由
  NAV_ROOT = "NAV_ROOT",
  //APP第二层主导航
  NAV_ROOT_MAIN_NAV = "NAV_ROOT_MAIN_NAV",
  //APP第三层主tab
  NAV_ROOT_MAIN_TAB = "NAV_ROOT_MAIN_TAB",


  //除了几个特殊的 配置在NAV_ROOT上，其他的都应该配置在NAV_ROOT_MAIN_TAB上

  //登录
  NAV_ROOT_LOGIN_NAV = "NAV_ROOT_LOGIN_NAV",
  //设置
  NAV_ROOT_LEARN_SETTING = "NAV_ROOT_LEARN_SETTING",

  // ================== 都在NAV_ROOT_MAIN_TAB下 =================== //
  NAV_MAIN_HOME = "NAV_MAIN_HOME",
  NAV_MAIN_CATEGORY = "NAV_MAIN_CATEGORY",
  NAV_MAIN_CAR = "NAV_MAIN_CAR",
  NAV_MAIN_MINE = "NAV_MAIN_MINE",


  //普通tab
  NAV_COMMON_TAB = "NAV_COMMON_TAB",

  // ================ 各模块内的路由(除了第一层路由，内部路由可以在内部重新设计） ============= //
  //cat tab
  NAV_CAT_HOME_NAV = "NAV_CAT_HOME_NAV",
  NAV_CAT_NEWS_NAV = "NAV_CAT_NEWS_NAV",
  NAV_CAT_ME_NAV = "NAV_CAT_ME_NAV",

  //lion tab
  NAV_LION_MAIN_NAV = "NAV_LION_MAIN_NAV",
  NAV_LION_MAIN_TAB_NAV = "NAV_LION_MAIN_TAB_NAV",


  NAV_LION_HOME_NAV = "NAV_LION_HOME_NAV",
  NAV_LION_NEWS_NAV = "NAV_LION_NEWS_NAV",
  NAV_LION_ME_NAV = "NAV_LION_ME_NAV",

  //hotel
  NAV_HOTEL_NAV = "NAV_HOTEL_NAV",

  //demo
  NAV_DEMO_MAIN_NAV = "NAV_DEMO_MAIN_NAV",

}
