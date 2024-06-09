import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_develop_template/common/mvvm/base_model.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model_widget.dart';
import 'package:flutter_develop_template/common/paging/base_paging_model.dart';
import 'package:flutter_develop_template/main/application.dart';

import '../widget/global_notification_widget.dart';

abstract class BaseStatefulPage<VM extends PageViewModel> extends BaseViewModelStatefulWidget<VM> {
  BaseStatefulPage({super.key});

  @override
  BaseStatefulPageState<BaseStatefulPage, VM> createState();
}

abstract class BaseStatefulPageState<T extends BaseStatefulPage, VM extends PageViewModel>
    extends BaseViewModelStatefulWidgetState<T, VM>
    with AutomaticKeepAliveClientMixin {

  /// 定义对应的 viewModel
  VM? viewModel;

  /// 监听应用生命周期
  AppLifecycleListener? lifecycleListener;

  /// 获取应用状态
  AppLifecycleState? get lifecycleState =>
      SchedulerBinding.instance.lifecycleState;

  /// 是否打印 监听应用生命周期的 日志
  bool debugPrintLifecycleLog = false;

  /// 进行初始化ViewModel相关操作
  @override
  void initState() {
    super.initState();

    /// 初始化页面 属性、对象、绑定监听
    initAttribute();
    initObserver();

    /// 初始化ViewModel，并同步生命周期
    viewModel = viewBindingViewModel();

    /// 调用viewModel的生命周期，比如 初始化 请求网络数据 等
    viewModel?.onCreate();

    /// Flutter 低版本 使用 WidgetsBindingObserver，高版本 使用 AppLifecycleListener
    lifecycleListener = AppLifecycleListener(
      // 监听状态回调
      onStateChange: onStateChange,

      // 可见，并且可以响应用户操作时的回调
      onResume: onResume,

      // 可见，但无法响应用户操作时的回调
      onInactive: onInactive,

      // 隐藏时的回调
      onHide: onHide,

      // 显示时的回调
      onShow: onShow,

      // 暂停时的回调
      onPause: onPause,

      // 暂停后恢复时的回调
      onRestart: onRestart,

      // 当退出 并将所有视图与引擎分离时的回调（IOS 支持，Android 不支持）
      onDetach: onDetach,

      // 在退出程序时，发出询问的回调（IOS、Android 都不支持）
      onExitRequested: onExitRequested,
    );

    /// 页面布局完成后的回调函数
    lifecycleListener?.binding.addPostFrameCallback((_) {
      assert(context != null, 'addPostFrameCallback throw Error context');

      /// 初始化 需要context 的属性、对象、绑定监听
      initContextAttribute(context);
      initContextObserver(context);
    });
  }

  @override
  void didChangeDependencies() {
    assert((){
      debugPrint('BaseStatefulPage.didChangeDependencies --- ${GlobalOperateProvider.getGlobalOperate(context: context)}');
      return true;
    }());
  }

  /// 监听状态
  onStateChange(AppLifecycleState state) => mLog('app_state：$state');

  /// =============================== 根据应用状态的产生的各种回调 ===============================

  /// 可见，并且可以响应用户操作时的回调
  /// 比如从应用后台调度到前台时，在 onShow() 后面 执行
  onResume() => mLog('onResume');

  /// 可见，但无法响应用户操作时的回调
  onInactive() => mLog('onInactive');

  /// 隐藏时的回调
  onHide() => mLog('onHide');

  /// 显示时的回调，从应用后台调度到前台时
  onShow() => mLog('onShow');

  /// 暂停时的回调
  onPause() => mLog('onPause');

  /// 暂停后恢复时的回调
  onRestart() => mLog('onRestart');

  /// 这两个回调，不是所有平台都支持，

  /// 当退出 并将所有视图与引擎分离时的回调（IOS 支持，Android 不支持）
  onDetach() => mLog('onDetach');

  /// 在退出程序时，发出询问的回调（IOS、Android 都不支持）
  /// 响应 [AppExitResponse.exit] 将继续终止，响应 [AppExitResponse.cancel] 将取消终止。
  Future<AppExitResponse> onExitRequested() async {
    mLog('onExitRequested');
    return AppExitResponse.exit;
  }

  /// BaseStatefulPageState的子类，重写 dispose()
  /// 一定要执行父类 dispose()
  @override
  void dispose() {
    /// 销毁顺序
    /// 1、Model 销毁其持有的 ViewModel
    /// 2、ViewModel 销毁其持有的 View
    /// 3、View 销毁其持有的 ViewModel
    /// 4、销毁监听App生命周期方法

    if(viewModel?.pageDataModel?.data is BaseModel?) {
      BaseModel? baseModel = viewModel?.pageDataModel?.data as BaseModel?;
      baseModel?.onDispose();
    }
    if(viewModel?.pageDataModel?.data is BasePagingModel?) {
      BasePagingModel? basePagingModel = viewModel?.pageDataModel?.data as BasePagingModel?;
      basePagingModel?.onDispose();
    }
    viewModel?.onDispose();
    viewModel = null;

    lifecycleListener?.dispose();
    super.dispose();
  }

  /// 是否保持页面状态
  @override
  bool get wantKeepAlive => false;

  /// View 持有对应的 ViewModel
  VM viewBindingViewModel();

  /// 子类重写，初始化 属性、对象
  /// 这里不是 网络请求操作，而是页面的初始化数据
  /// 网络请求操作，建议在viewModel.onCreate() 中实现
  void initAttribute();

  /// 子类重写，初始化 需要 context 的属性、对象
  void initContextAttribute(BuildContext context) {}

  /// 子类重写，初始化绑定监听
  void initObserver();

  /// 子类重写，初始化需要 context 的绑定监听
  void initContextObserver(BuildContext context) {}

  /// 输出日志
  void mLog(String info) {
    if (debugPrintLifecycleLog) {
      assert(() {
        debugPrint('--- $info');
        return true;
      }());
    }
  }

  /// 手机应用
  Widget appBuild(BuildContext context) => SizedBox();

  /// Web
  Widget webBuild(BuildContext context) => SizedBox();

  /// PC应用
  Widget pcBuild(BuildContext context) => SizedBox();

  @override
  Widget build(BuildContext context) {
    /// 使用 AutomaticKeepAliveClientMixin 需要 super.build(context);
    ///
    /// 注意：AutomaticKeepAliveClientMixin 只是保存页面状态，并不影响 build 方法执行
    /// 比如 PageVie的 子页面 使用了AutomaticKeepAliveClientMixin 保存状态，
    /// PageView切换子页面时，子页面的build的还是会执行
    if(wantKeepAlive) {
      super.build(context);
    }

    /// 和 GlobalNotificationWidget，建立依赖关系
    if(EnvConfig.isGlobalNotification) {
      GlobalNotificationWidget.of(context);
    }

    switch (EnvConfig.platform) {
      case ApplicationPlatform.app: {
        if (Platform.isAndroid || Platform.isIOS) {
          // 如果，还想根据当前设备屏幕尺寸细分，
          // 使用MediaQuery，拿到当前设备信息，进一步适配
          return appBuild(context);
        }
      }
      case ApplicationPlatform.web: {
          return webBuild(context);
      }
      case ApplicationPlatform.pc: {
        if(Platform.isWindows || Platform.isMacOS) {
          return pcBuild(context);
        }
      }
    }
    return Center(
      child: Text('当前平台未适配'),
    );
  }

}
