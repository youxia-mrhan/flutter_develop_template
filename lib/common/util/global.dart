import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 状态栏样式
SystemUiOverlayStyle _systemOverlayStyleForBrightness(Brightness brightness,
    [Color? backgroundColor]) {
  final SystemUiOverlayStyle style = brightness == Brightness.dark
      ? SystemUiOverlayStyle.light
      : SystemUiOverlayStyle.dark;
  // For backward compatibility, create an overlay style without system navigation bar settings.
  return SystemUiOverlayStyle(
    statusBarColor: backgroundColor,
    statusBarBrightness: style.statusBarBrightness,
    statusBarIconBrightness: style.statusBarIconBrightness,
    systemStatusBarContrastEnforced: style.systemStatusBarContrastEnforced,
  );
}

/// 下面 注解 没写反！！！，给白色，图标/字体 实际情况是 黑色，反之 给黑色，图标/字体 是 白色

/// 状态栏 背景透明，图标/字体 白色
SystemUiOverlayStyle get overlayBlackStyle =>
    _systemOverlayStyleForBrightness(
      ThemeData.estimateBrightnessForColor(Colors.white), // 状态栏图吧字体颜色
      const Color(0x00000000), // 状态栏背景色
    );

/// 状态栏 背景透明，图标/字体 黑色
SystemUiOverlayStyle get overlayWhiteStyle =>
    _systemOverlayStyleForBrightness(
      ThemeData.estimateBrightnessForColor(Colors.black), // 状态栏图吧字体颜色
      const Color(0x00000000), // 状态栏背景色
    );