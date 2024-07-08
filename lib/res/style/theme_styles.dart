/// 错误的包，这种在Widget使用时，Widget找不到 样式实例
/// import 'dart:ui';

/// 导入正确的包
import 'package:flutter/material.dart';

import 'color_styles.dart';
/// 或者 import 'package:flutter/cupertino.dart';

/// 全局主题样式 统一放置的地方
class ThemeStyles {

  static ThemeData defaultTheme = ThemeData(
    // appBar主题
    appBarTheme: AppBarTheme(backgroundColor: ColorStyles.color_0E6ED9),
    // 去除水波纹效果
    splashColor: ColorStyles.color_transparent,
    // 去除长按效果
    highlightColor: ColorStyles.color_transparent,
    useMaterial3: true,
  );

}
