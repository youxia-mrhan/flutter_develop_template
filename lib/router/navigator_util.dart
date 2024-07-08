import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import '../../../../router/routers.dart';

import '../../main/app.dart';

/// 路由工具类
/// 如果所在类没有 context，可以使用 全局context：navigatorKey.currentContext
class NavigatorUtil {

  /// 前往页面
  static Future<dynamic> push(
    BuildContext context,
    path, {
    bool replace = false, // 替换，进入新的页面时，将当前页面销毁
    bool clearStack = false, // 清空路由栈，进入新的页面时，其他实例的页面全部销毁
    Object? arguments, // 传递的参数
    TransitionType? transition, // 页面跳转的动画 类型
  }) {
    return Routers.router.navigateTo(
      context,
      path,
      replace: replace,
      clearStack: clearStack,
      transition: transition ?? TransitionType.inFromRight, // 默认跳转动画，从右侧进入
      routeSettings: RouteSettings(
        arguments: arguments,
      ),
    );
  }

  /// 返回
  static void back<T>(
    BuildContext context, {
    int count = 1, // 指定返回多少层
    bool toRoot = false, // 直接返回根目录
    Object? arguments,
  }) {
    if(toRoot) {
      /// 获取路由栈里，页面总数量
      int? routeStackLength = pageRouteObserver?.getRouteStackLength() ?? 1;
      count = routeStackLength;
      if(count == 1) {
        /// 路由栈里，只有1个页面
        return;
      } else {
        /// 减1，保留 根页面
        count--;
      }
    }
    NavigatorState state = Navigator.of(context);
    while(count-- > 0) {
      state = state..pop(arguments);
    }
  }

}
