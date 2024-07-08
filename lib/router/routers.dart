import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_develop_template/main/app.dart';
import 'package:flutter_develop_template/module/test_fluro/page_a.dart';
import 'package:flutter_develop_template/module/test_fluro/page_b.dart';
import 'package:flutter_develop_template/module/test_fluro/page_c.dart';

import '../../module/order/view/order_v.dart';
import '../../module/test_fluro/page_d.dart';

class Routers {
  static FluroRouter router = FluroRouter();

  // 配置路由
  static void configureRouters() {
    router.notFoundHandler = Handler(handlerFunc: (_, __) {
      // 找不到路由时，返回指定提示页面
      return Scaffold(
        body: const Center(
          child: Text('404'),
        ),
      );
    });

    // 初始化路由
    _initRouter();
  }

  // 设置页面

  // 页面标识
  static String root = '/';

  // 页面A
  static String pageA = '/pageA';

  // 页面B
  static String pageB = '/pageB';

  // 页面C
  static String pageC = '/pageC';

  // 页面D
  static String pageD = '/pageD';

  // 注册路由
  static _initRouter() {

    // 根页面
    router.define(
      root,
      handler: Handler(
        handlerFunc: (_, __) => AppMainPage(),
      ),
    );

    // 页面A 需要 非对象类型 参数
    router.define(
      pageA,
      handler: Handler(
        handlerFunc: (_, Map<String, List<String>> params) {

          // 获取路由参数
          String? name = params['name']?.first;
          String? title = params['title']?.first;
          String? url = params['url']?.first;
          String? age = params['age']?.first ?? '-1';
          String? price = params['price']?.first ?? '-1';
          String? flag = params['flag']?.first ?? 'false';

          return PageAView(
            name: name,
            title: title,
            url: url,
            age: int.parse(age),
            price: double.parse(price),
            flag: bool.parse(flag)
          );

        },
      ),
    );

    // 页面B 需要 对象类型 参数
    router.define(
      pageB,
      handler: Handler(
        handlerFunc: (context, Map<String, List<String>> params) {
          // 获取路由参数
          TestParamsModel? paramsModel = context?.settings?.arguments as TestParamsModel?;
          return PageBView(paramsModel: paramsModel);
        },
      ),
    );

    // 页面C 无参数
    router.define(
      pageC,
      handler: Handler(
        handlerFunc: (_, __) => PageCView(),
      ),
    );

    // 页面D 无参数
    router.define(
      pageD,
      handler: Handler(
        handlerFunc: (_, __) => PageDView(),
      ),
    );
  }

}
