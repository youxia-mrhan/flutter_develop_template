import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_develop_template/api/message_repository.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/common/paging/paging_data_model.dart';

import '../../../common/widget/notifier_widget.dart';
import '../view/message_v.dart';

class MessageViewModel extends PageViewModel {

  CancelToken? cancelToken;
  PagingDataModel? pagingDataModel;
  MessageViewState? state;

  @override
  onCreate() {
    state = viewState as MessageViewState;
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

