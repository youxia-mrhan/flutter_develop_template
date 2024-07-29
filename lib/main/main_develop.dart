import 'package:flutter_develop_template/main/application.dart';

/// 开发环境 入口函数
void main() => Application.runApplication(
    envTag: EnvTag.develop, // 开发环境
    platform: ApplicationPlatform.app, // 手机应用
    baseUrl: 'https://www.wanandroid.com/', // 域名
    proxyEnable: false, // 是否开启抓包
    caughtAddress: '192.168.1.3:8888', // 抓包工具的代理地址 + 端口
    isGlobalNotification: true, // 是否有全局通知操作，比如切换用户
    /// 异常抛出，会在终端会显示，可帮助开发阶段，快速定位异常所在，
    /// 但会阻断，后续代码执行，建议 非开发阶段 关闭
    throwError: true,
    pushErrToSentry: false, // 是否开启 异常上报到 Sentry
    sentryDNS: 'https://123456789191111@xxx.com/2' // Sentry DNS 标识

    /// AndroidManifest.xml 中
    ///  开启网络权限
    ///  <uses-permission android:name="android.permission.INTERNET" />
    ///
    ///  如果使用 http，还需要配置
    ///     <application
    ///         android:usesCleartextTraffic="true"
    ///
    // 'http://123456789191111@IP:9000/2';

    /// 配置完 域名 和 SSL证书后，http 改为 https，IP 替换为 域名，
    // 'https://123456789191111@域名/2';
);

