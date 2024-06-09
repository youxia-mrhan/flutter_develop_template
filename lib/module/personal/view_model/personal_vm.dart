import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_develop_template/api/personal_repository.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';

import '../../../common/widget/notifier_widget.dart';
import '../view/personal_v.dart';

class PersonalViewModel extends PageViewModel{
  CancelToken? cancelToken;
  PersonalViewState? state;

  @override
  onCreate() {
    state = viewState as PersonalViewState;
    cancelToken = CancelToken();
    pageDataModel = PageDataModel();
  }

  @override
  onDispose() {
    if (!(cancelToken?.isCancelled ?? true)) {
      cancelToken?.cancel();
    }
    assert((){
      debugPrint('PersonalViewModel.onDispose()');
      return true;
    }());

    /// 别忘了执行父类的 onDispose
    super.onDispose();
  }

  /// 注册
  Future<PageViewModel?> registerUser({Map<String, dynamic>? params}) async {
    PageViewModel viewModel = await PersonalRepository().registerUser(
        pageViewModel: this,
        cancelToken: cancelToken,
        params: params
    );

    pageDataModel = viewModel.pageDataModel;
    pageDataModel?.refreshState();
    return Future<PageViewModel>.value(viewModel);
  }

  /// 登陆
  Future<PageViewModel?> loginUser({Map<String, dynamic>? params}) async {
    PageViewModel viewModel = await PersonalRepository().loginUser(
        pageViewModel: this,
        cancelToken: cancelToken,
        params: params
    );
    pageDataModel = viewModel.pageDataModel;
    pageDataModel?.refreshState();
    return Future<PageViewModel>.value(viewModel);
  }

  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) {
    return Future.value(null);
  }

}