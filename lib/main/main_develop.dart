import 'package:flutter_develop_template/main/application.dart';

/// 开发环境 入口函数
void main() => Application.runApplication(
      envTag: EnvTag.develop, // 开发环境
      platform: ApplicationPlatform.app, // 手机应用
      baseUrl: 'https://www.wanandroid.com/', // 域名
      proxyEnable: true, // 是否开启抓包
      caughtAddress: '192.168.1.3:8888', // 抓包工具的代理地址 + 端口
      isGlobalNotification: true, // 是否有全局通知操作，比如切换用户
      /// 异常抛出，会在终端会显示，可帮助开发阶段，快速定位异常所在，
      /// 但会阻断，后续代码执行，建议 非开发阶段 关闭
      throwError: false,
    );
