import 'package:flutter_develop_template/main/application.dart';

/// 正式环境 入口函数
void main() => Application.runApplication(
      envTag: EnvTag.release, // 正式环境
      platform: ApplicationPlatform.app, // 手机应用
      baseUrl: 'https://www.wanandroid.com/', // 域名
    );
