import 'package:flutter/material.dart';

/// 在执行全局操作后，所有继承 BaseStatefulPageState 的子页面，
/// 都会执行 didChangeDependencies() 方法，然后执行 build() 方法
///
/// 具体原理：是 InheritedWidget 的特性
/// https://loveky.github.io/2018/07/18/how-flutter-inheritedwidget-works/

/// 全局操作类型
enum GlobalOperate {
  /// 默认空闲
  idle,

  /// 切换登陆
  switchLogin,

  /// ... ...
}

/// 持有 全局操作状态 的 InheritedWidget
class GlobalNotificationWidget extends InheritedWidget {
  GlobalNotificationWidget({
    required this.globalOperate,
    required super.child});

  final GlobalOperate globalOperate;

  static GlobalNotificationWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GlobalNotificationWidget>();
  }

  /// 通知所有建立依赖的 子Widget
  @override
  bool updateShouldNotify(covariant GlobalNotificationWidget oldWidget) =>
      oldWidget.globalOperate != globalOperate &&
      globalOperate != GlobalOperate.idle;
}

/// 具体使用的 全局操作 Widget
///
/// 执行全局操作： GlobalOperateProvider.runGlobalOperate(context: context, operate: GlobalOperate.switchLogin);
/// 获取全局操作类型 GlobalOperateProvider.getGlobalOperate(context: context)
class GlobalOperateProvider extends StatefulWidget {
  const GlobalOperateProvider({super.key, required this.child});

  final Widget child;

  /// 执行全局操作
  static runGlobalOperate({
    required BuildContext? context,
    required GlobalOperate operate,
  }) {
    context
        ?.findAncestorStateOfType<_GlobalOperateProviderState>()
        ?._runGlobalOperate(operate: operate);
  }

  /// 获取全局操作类型
  static GlobalOperate? getGlobalOperate({required BuildContext? context}) {
    return context
        ?.findAncestorStateOfType<_GlobalOperateProviderState>()
        ?.globalOperate;
  }

  @override
  State<GlobalOperateProvider> createState() => _GlobalOperateProviderState();
}

class _GlobalOperateProviderState extends State<GlobalOperateProvider> {
  GlobalOperate globalOperate = GlobalOperate.idle;

  /// 执行全局操作
  _runGlobalOperate({required GlobalOperate operate}) {
    // 先重置
    globalOperate = GlobalOperate.idle;

    // 再赋值
    globalOperate = operate;

    /// 别忘了刷新，如果不刷新，子widget不会执行 didChangeDependencies 方法
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GlobalNotificationWidget(
      globalOperate: globalOperate,
      child: widget.child,
    );
  }
}
