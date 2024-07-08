/// 错误的包，这种在Widget使用时，Widget找不到 样式实例
/// import 'dart:ui';

/// 导入正确的包
import 'package:flutter/material.dart';
/// 或者 import 'package:flutter/cupertino.dart';

import 'color_styles.dart';

/// 全局字体样式 统一放置的地方
/// 根据字体是否是加粗，进行归类
class TextStyles {
  static final TextStyle style_000000_16 = TextStyle(
    color: ColorStyles.color_000000,
    fontSize: 16,
  );

  static final TextStyle style_222222_16 = TextStyle(
    color: ColorStyles.color_222222,
    fontSize: 16,
  );

  static final TextStyle style_222222_20 = TextStyle(
    color: ColorStyles.color_222222,
    fontSize: 20,
  );

  ///--------------------------- 字体加粗 -------------------------------
  static final TextStyle style_bold_000000_16 = TextStyle(
    color: ColorStyles.color_000000,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle style_bold_222222_16 = TextStyle(
    color: ColorStyles.color_222222,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
}
