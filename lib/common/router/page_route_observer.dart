import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/router/routers.dart';

import '../../main/app.dart';
import 'navigator_util.dart';

/// 监听路由栈状态
class PageRouteObserver extends NavigatorObserver {
  static List<Route<dynamic>> routeStack = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    /// 当前所在页面 Path
    String? currentRoutePath = getOriginalPath(previousRoute);

    /// 要前往的页面 Path
    String? newRoutePath = getOriginalPath(route);

    /// 拦截指定页面
    /// 如果从 PageA 页面，跳转到 PageD，将其拦截
    if(currentRoutePath == Routers.pageA) {

      if(newRoutePath == Routers.pageD) {
        assert((){
          debugPrint('准备从 PageA页面 进入 pageD页面，进行登陆信息验证');

          // if(验证不通过) {
            /// 注意：要延迟一帧
            WidgetsBinding.instance.addPostFrameCallback((_){
              // 我这里是pop，视觉上达到无法进入新页面的效果，
              // 正常业务是跳转到 登陆页面
              NavigatorUtil.back(navigatorKey.currentContext!);
            });
          // }

          return true;
        }());
      }
    }

    routeStack.add(route);
    printRouteStack();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    routeStack.remove(route);
    printRouteStack();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    routeStack.remove(route);
    printRouteStack();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null) {
      routeStack.remove(oldRoute);
    }
    if (newRoute != null) {
      routeStack.add(newRoute);
    }
    printRouteStack();
  }

  void printRouteStack() {
    assert((){
      debugPrint('当前路由栈: ${routeStack.map((route) => route.settings.name).toList()}');
      debugPrint('当前路由栈长度: ${routeStack.length}');
      return true;
    }());
  }

  /// 获取原生路径
  /// 使用 path拼接方式 传递 参数，会改变原来的 路由页面 Path
  ///
  /// 比如：NavigatorUtil.push(context,'${Routers.pageA}?name=$name&title=$title&url=$url&age=$age&price=$price&flag=$flag');
  /// path会变成：/pageA?name=jk&title=%E5%BC%A0%E4%B8%89&url=https%3A%2F%2Fwww.baidu.com&age=99&price=9.9&flag=true
  /// 所以需要还原一下
  String? getOriginalPath(Route<dynamic>? route) {
    // 获取原始的路由路径
    String? fullPath = route?.settings.name;

    if(fullPath != null) {
      // 使用正则表达式去除查询参数
      return fullPath.split('?')[0];
    }

    return fullPath;
  }

  /// 返回当前路由栈的长度
  int getRouteStackLength() {
    return routeStack.length;
  }
}
