import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_develop_template/api/message_repository.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/common/paging/paging_data_model.dart';

import '../../../common/widget/notifier_widget.dart';
import '../view/message_v.dart';

class MessageViewModel extends PageViewModel<MessageViewState> {

  CancelToken? cancelToken;
  PagingDataModel? pagingDataModel;

  @override
  onCreate() {

    assert((){
      /// 拿到 页面状态里的 对象、属性 等等
      debugPrint('---runSwitchLogin：${state.runSwitchLogin}');
      return true;
    }());

    cancelToken = CancelToken();
    pageDataModel = PageDataModel();
    pagingDataModel = PagingDataModel();
    requestData();
  }

  @override
  onDispose() {
    if(!(cancelToken?.isCancelled ?? true)) {
      cancelToken?.cancel();
    }

    assert((){
      debugPrint('MessageViewModel.onDispose()');
      return true;
    }());

    /// 别忘了执行父类的 onDispose
    super.onDispose();
  }

  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) async {
    PageViewModel viewModel = await MessageRepository().getMessageData(
        pageViewModel: this,
        cancelToken: cancelToken,
        curPage: params?['curPage'] ?? 0
    );
    pageDataModel = viewModel.pageDataModel;

    /// 分页代码
    pageDataModel?.bindingPaging(
        viewModel,
        pageDataModel!,
        pagingDataModel!,
        this);

    pageDataModel?.refreshState();

    /// 注意：使用需要返回 PageDataModel对象，它和
    return Future<PageViewModel>.value(viewModel);
  }

}

