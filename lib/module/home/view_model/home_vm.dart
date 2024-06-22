import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/common/widget/notifier_widget.dart';
import 'package:flutter_develop_template/module/home/view/home_v.dart';

import '../../../api/home_repository.dart';

class HomeViewModel extends PageViewModel<HomeViewState> {
  CancelToken? cancelToken;

  @override
  onCreate() {

    assert((){
      /// 拿到 页面状态里的 对象、属性 等等
      debugPrint('---executeSwitchLogin：${state.executeSwitchLogin}');
      return true;
    }());

    cancelToken = CancelToken();
    pageDataModel = PageDataModel();
    requestData();
  }

  @override
  onDispose() {
    if (!(cancelToken?.isCancelled ?? true)) {
      cancelToken?.cancel();
    }
    assert((){
      debugPrint('HomeViewModel.onDispose()');
      return true;
    }());

    /// 别忘了执行父类的 onDispose
    super.onDispose();
  }

  /// 请求数据
  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) async {
    PageViewModel viewModel = await HomeRepository().getHomeData(
        pageViewModel: this,
        cancelToken: cancelToken,
        curPage: params?['curPage'] ?? 0
    );
    pageDataModel = viewModel.pageDataModel;
    pageDataModel?.refreshState();
    return Future<PageViewModel>.value(viewModel);
  }
}
