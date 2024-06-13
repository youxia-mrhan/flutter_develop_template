import 'package:flutter_develop_template/common/mvvm/base_change_notifier.dart';

import '../mvvm/base_view_model.dart';
import '../widget/notifier_widget.dart';

/// 分页数据相关

/// 分页行为：下拉刷新/上拉加载更多
enum PagingBehavior {
  /// 空闲，默认状态
  idle,

  /// 加载
  load,

  /// 刷新
  refresh;
}

/// 分页状态：执行完 下拉刷新/上拉加载更多后，得到的状态
enum PagingState {
  /// 空闲，默认状态
  idle,

  /// 加载成功
  loadSuccess,

  /// 加载失败
  loadFail,

  /// 没有更多数据了
  loadNoData,

  /// 正在加载
  curLoading,

  /// 刷新成功
  refreshSuccess,

  /// 刷新失败
  refreshFail,

  /// 正在刷新
  curRefreshing,
}

/// 分页数据对象
class PagingDataModel<DM extends BaseChangeNotifier, VM extends PageViewModel> {
  // 当前页码
  int curPage;

  // 总共多少页
  int pageCount;

  // 总共 数据数量
  int total;

  // 当前页 数据数量
  int size;

  /// 响应的完整数据
  /// 你可能还需要，响应数据的 其他字段，
  ///
  /// assert((){
  ///    var mListModel = pageDataModel?.data as MessageListModel?; // 转化成对应的Model
  ///    debugPrint('---pageCount：${mListModel?.pageCount}'); // 获取字段
  ///    return true;
  /// }());
  dynamic data;

  // 分页参数 字段，一般情况都是固定的，以防万一
  String? curPageField;

  // 数据列表
  List<dynamic> listData = [];

  // 当前的PageDataModel
  DM? pageDataModel;

  // 当前的PageViewModel
  VM? pageViewModel;

  PagingBehavior pagingBehavior = PagingBehavior.idle;

  PagingState pagingState = PagingState.idle;

  PagingDataModel(
      {this.curPage = 0,
      this.pageCount = 0,
      this.total = 0,
      this.size = 0,
      this.data,
      this.curPageField = 'curPage',
      this.pageDataModel}) : listData = [];

  /// 这两个方法，由 RefreshLoadWidget 组件调用

  /// 加载更多，追加数据
  Future<PagingState> loadListData() async {
    PagingState pagingState = PagingState.curLoading;
    pagingBehavior = PagingBehavior.load;
    Map<String, dynamic>? param = {curPageField!: curPage++};
    PageViewModel? currentPageViewModel = await pageViewModel?.requestData(params: param);
    if(currentPageViewModel?.pageDataModel?.type == NotifierResultType.success) {
      // 没有更多数据了
      if(currentPageViewModel?.pageDataModel?.total == listData.length) {
        pagingState = PagingState.loadNoData;
      } else {
        pagingState = PagingState.loadSuccess;
      }
    } else {
      pagingState = PagingState.loadFail;
    }
    return pagingState;
  }

  /// 下拉刷新数据
  Future<PagingState> refreshListData() async {
    PagingState pagingState = PagingState.curRefreshing;
    pagingBehavior = PagingBehavior.refresh;
    curPage = 0;
    Map<String, dynamic>? param = {curPageField!: curPage};
    PageViewModel? currentPageViewModel = await pageViewModel?.requestData(params: param);
    if(currentPageViewModel?.pageDataModel?.type == NotifierResultType.success) {
      pagingState = PagingState.refreshSuccess;
    } else {
      pagingState = PagingState.refreshFail;
    }
    return pagingState;
  }

}
