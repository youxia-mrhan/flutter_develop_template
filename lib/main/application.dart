import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/res/string/strings.dart';

import '../common/router/routers.dart';
import 'app.dart';

enum ApplicationPlatform {
  /// 手机应用
  app,

  /// Web
  web,

  /// PC应用
  pc
}

enum EnvTag {
  /// 开发
  develop,

  /// 预发布
  preRelease,

  /// 正式
  release,
}

/// 环境配置实体
class EnvConfig {
  /// 域名
  static String baseUrl = '';

  /// 开发环境
  static EnvTag envTag = EnvTag.develop;

  /// 是否开启抓包
  static bool proxyEnable = false;

  /// 抓包工具的代理地址 + 端口
  static String? caughtAddress;

  /// 平台
  static ApplicationPlatform platform = ApplicationPlatform.app;

  /// 是否有全局通知操作，比如切换用户
  static bool isGlobalNotification = false;

  /// 异常抛出，会在终端会显示，可帮助开发阶段，快速定位异常所在
  /// 但会阻断，后续代码执行，建议 非开发阶段 关闭
  static bool throwError = false;
}

class Application {

  Application.runApplication({
    required EnvTag envTag, // 开发环境
    required String baseUrl, // 域名
    required ApplicationPlatform platform, // 平台
    bool proxyEnable = false, // 是否开启抓包
    String? caughtAddress, // 抓包工具的代理地址 + 端口
    bool isGlobalNotification = false, // 是否有全局通知操作，比如切换用户
    bool throwError = false // 异常抛出，会在终端会显示，可帮助开发阶段，快速定位异常所在，但会阻断，后续代码执行
  }) {
    EnvConfig.envTag = envTag;
    EnvConfig.baseUrl = baseUrl;
    EnvConfig.platform = platform;
    EnvConfig.proxyEnable = proxyEnable;
    EnvConfig.caughtAddress = caughtAddress;
    EnvConfig.isGlobalNotification = isGlobalNotification;
    EnvConfig.throwError = throwError;

    /// runZonedGuarded 全局异常监听，实现异常上报
    runZonedGuarded(() {
      /// 确保一些依赖，全部初始化
      WidgetsFlutterBinding.ensureInitialized();

      /// 监听全局Widget异常，如果发生，将该Widget替换掉
      ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
        return Material(
          child: Center(
            child: Text(Strings.pleaseService),
          ),
        );
      };

      /// 初始化路由
      Routers.configureRouters();

      /// 运行App
      runApp(App());

    }, (Object error, StackTrace stack) {
      /// 使用第三方服务（例如Sentry）上报错误
      /// Sentry.captureException(error, stackTrace: stackTrace);
    });
  }

}
