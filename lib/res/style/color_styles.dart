/// 错误的包，这种在Widget使用时，Widget找不到 样式实例
/// import 'dart:ui';

/// 导入正确的包
import 'package:flutter/material.dart';
/// 或者 import 'package:flutter/cupertino.dart';

/// 全局颜色样式 统一放置的地方
/// 根据颜色大概种类，进行归类
class ColorStyles {

  static const Color color_transparent = Color(0x00000000);

  static const Color color_FFFFFF = Color(0xFFFFFFFF);

  static const Color color_000000 = Color(0xFF000000);
  static const Color color_222222 = Color(0xFF222222);
  static const Color color_474747 = Color(0xff474747);

  static const Color color_F94B30 = Color(0xFFF94B30);
  static const Color color_EA5034 = Color(0xFFEA5034);
  static const Color color_FF4D4F = Color(0xFFFF4D4F);

  static const Color color_3A65E6 = Color(0xFF3A65E6);
  static const Color color_456FEF = Color(0xFF456FEF);
  static const Color color_0E6ED9 = Color(0xFF0E6ED9);
  static const Color color_1E88E5 = Color(0xFF1E88E5);

  static const Color color_388E3C = Color(0xFF388E3C);
  static const Color color_2E7D32 = Color(0xFF2E7D32);

}