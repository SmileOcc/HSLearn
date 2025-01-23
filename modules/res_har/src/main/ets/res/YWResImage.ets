
export class YWResImage {
  static appIcon(): Resource {
    return $r('app.media.app_icon');
  }

  static tab_home():Resource {
    return $r('app.media.tab_home_normal')
  }

  static tab_home_h():Resource {
    return $r('app.media.tab_home_select')
  }

  static tab_category():Resource {
    return $r('app.media.category_normal')
  }

  static tab_category_h():Resource {
    return $r('app.media.category_select')
  }

  static tab_car():Resource {
    return $r('app.media.tab_bag_normal')
  }

  static tab_car_h():Resource {
    return $r('app.media.tab_bag_select')
  }

  static tab_mine():Resource {
    return $r('app.media.tab_me_normal')
  }

  static tab_mine_h():Resource {
    return $r('app.media.tab_me_select')
  }

  static arrowLeftIcon():Resource {
    return $r('app.media.arrow_left')
  }

  static arrowRightIcon():Resource {
    return $r('app.media.arrow_right')
  }

  static userAvatar():Resource {
    return $r('app.media.user_avatar')
  }

  static defaultPlaceholder():Resource {
    return $r('app.media.placeholder')
  }

  static backArrow():Resource {
    return $r('app.media.tab_bag_normal')//todo 返回按钮
  }
}