export type YWNavIDType = YWLocalNavType | string

export type YWNavCustomIDType = string

export type CustomerNavAnimation = (from: NavContentInfo, to: NavContentInfo,
  operation: NavigationOperation) => NavigationAnimatedTransition | undefined

export enum YWNavParamsKey {
  SESSION = "session",
  NAV_ULR_KEY = "navUrlKey"
}

export enum YWLocalNavType {


  NAV_ROOT = "NAV_ROOT",
    //主导航
  NAV_ROOT_MAIN_NAV = "NAV_ROOT_MAIN_NAV",
    //主tab
  NAV_ROOT_MAIN_TAB = "NAV_ROOT_MAIN_TAB",



  NAV_ROOT_LOGIN_NAV = "NAV_ROOT_LOGIN_NAV",

  NAV_ROOT_LEARN_SETTING = "NAV_ROOT_LEARN_SETTING",


  NAV_SETTING = "NAV_SETTING",

  NAV_MAIN_HOME = "NAV_MAIN_HOME",
  NAV_MAIN_CATEGORY = "NAV_MAIN_CATEGORY",
  NAV_MAIN_CAR = "NAV_MAIN_CAR",
  NAV_MAIN_MINE = "NAV_MAIN_MINE",


  //普通tab
  NAV_COMMON_TAB = "NAV_COMMON_TAB",

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


  //demo
  NAV_DEMO_MAIN_NAV = "NAV_DEMO_MAIN_NAV",

}

export type YWNavParams = Map<string, Object>