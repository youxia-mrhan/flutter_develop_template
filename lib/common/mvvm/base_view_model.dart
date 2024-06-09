import '../widget/notifier_widget.dart';
import 'base_page.dart';

/// 基类
abstract class BaseViewModel {

}

/// 页面继承的ViewModel，不直接使用 BaseViewModel，
/// 是因为BaseViewModel基类里代码，还是不要太多为好，扩展创建新的子类就好
abstract class PageViewModel extends BaseViewModel {

  /// 定义对应的 view
  BaseStatefulPageState? viewState;

  PageDataModel? pageDataModel;

  /// 尽量在onCreate方法中编写初始化逻辑
  void onCreate();

  /// 对应的widget被销毁了，销毁相关引用对象，避免内存泄漏
  void onDispose() {
    viewState = null;
    pageDataModel = null;
  }

  /// 请求数据
  Future<PageViewModel?> requestData({Map<String, dynamic>? params});

}