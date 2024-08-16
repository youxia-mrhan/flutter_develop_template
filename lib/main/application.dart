import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../res/string/str_common.dart';

import '../../router/routers.dart';
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

  /// 是否开启 异常上报到 Sentry
  static bool pushErrToSentry = false;

  /// Sentry DNS 标识
  static String? sentryDNS;
}

class Application {
  Application.runApplication(
      {required EnvTag envTag, // 开发环境
      required String baseUrl, // 域名
      required ApplicationPlatform platform, // 平台
      bool proxyEnable = false, // 是否开启抓包
      String? caughtAddress, // 抓包工具的代理地址 + 端口
      bool isGlobalNotification = false, // 是否有全局通知操作，比如切换用户
      bool throwError = false, // 异常抛出，会在终端会显示，可帮助开发阶段，快速定位异常所在，但会阻断，后续代码执行
      bool pushErrToSentry = false, // 是否开启 异常上报到 Sentry
      String? sentryDNS // Sentry DNS 标识
      }) {
    EnvConfig.envTag = envTag;
    EnvConfig.baseUrl = baseUrl;
    EnvConfig.platform = platform;
    EnvConfig.proxyEnable = proxyEnable;
    EnvConfig.caughtAddress = caughtAddress;
    EnvConfig.isGlobalNotification = isGlobalNotification;
    EnvConfig.throwError = throwError;
    EnvConfig.pushErrToSentry = pushErrToSentry;
    EnvConfig.sentryDNS = sentryDNS;

    /// 确保一些依赖，全部初始化
    WidgetsFlutterBinding.ensureInitialized();

    /// 初始化路由
    Routers.configureRouters();

    /// Flutter 框架中 Widget显示错误时，替换为当前组件
    ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
      return Material(
        child: Center(
          child: EnvConfig.envTag == EnvTag.develop
              ? Text(flutterErrorDetails.exceptionAsString())
              : Text(StrCommon.pleaseService),
        ),
      );
    };

    /// FlutterError.onError 是 Flutter 提供的一个全局错误处理回调，
    /// 用于捕获框架内发生的未处理异常。无论是同步还是异步异常，
    /// 只要它们发生在 Flutter 框架的上下文中，都会触发这个回调。
    FlutterError.onError = (FlutterErrorDetails flutterErrorDetails) async {
      if (EnvConfig.pushErrToSentry) {
        debugPrint('执行了异常 上报：${flutterErrorDetails.exception}');

        /// 使用第三方服务（例如Sentry）上报错误
        /// Sentry.captureException(error, stackTrace: stackTrace);
        await Sentry.captureException(
          flutterErrorDetails.exception,
          stackTrace: flutterErrorDetails.stack,
        );
      }
    };

    /// runZonedGuarded 捕获 Flutter 框架中的 异步异常
    /// 注意：它不是全局的，只能捕获指定范围
    runZonedGuarded(() async {
      if (EnvConfig.pushErrToSentry) {
        /// 初始化 Sentry
        await SentryFlutter.init(
          (options) {
            options.dsn = EnvConfig.sentryDNS;
            options.tracesSampleRate = 1.0;

            if (EnvConfig.envTag == EnvTag.develop) {
              /// 是否打印输出 Sentry 日志
              options.debug = true;
            }
          },
          appRunner: () => runApp(App()),
        );
      } else {
        runApp(App());
      }
    }, (Object error, StackTrace stack) async {
      if (EnvConfig.pushErrToSentry) {
        debugPrint('执行了异常 上报：$error');

        /// 使用第三方服务（例如Sentry）上报错误
        /// Sentry.captureException(error, stackTrace: stackTrace);
        await Sentry.captureException(
          error,
          stackTrace: stack,
        );
      }
    });
  }
}
