import 'package:dio/dio.dart';
import 'package:flutter_develop_template/common/net/dio_client.dart';
import 'package:flutter_develop_template/common/widget/notifier_widget.dart';
import 'package:flutter_develop_template/module/message/model/message_list_m.dart';

import '../common/mvvm/base_view_model.dart';
import '../common/net/dio_response.dart';

class MessageRepository {

  Future<PageViewModel> getMessageData({
    required PageViewModel pageViewModel,
    CancelToken? cancelToken,
    int curPage = 0,
  }) async {
    try {
      Response response = await DioClient().doGet('article/list/$curPage/json', cancelToken: cancelToken);

      if(response.statusCode == REQUEST_SUCCESS) {
        /// 请求成功
        pageViewModel.pageDataModel?.type = NotifierResultType.success;

        /// 有分页
        pageViewModel.pageDataModel?.isPaging = true;

        /// 分页代码
        pageViewModel.pageDataModel?.correlationPaging(pageViewModel, MessageListModel.fromJson(response.data));
      } else {

        /// 请求成功，但业务不通过，比如没有权限
        pageViewModel.pageDataModel?.type = NotifierResultType.unauthorized;
        pageViewModel.pageDataModel?.errorMsg = response.statusMessage;
      }

      return pageViewModel;
    } on DioException catch (dioEx) {
      /// 请求异常
      pageViewModel.pageDataModel?.type = NotifierResultType.dioError;
      pageViewModel.pageDataModel?.errorMsg = dioErrorConversionText(dioEx);
    } catch (e) {
      /// 未知异常
      pageViewModel.pageDataModel?.type = NotifierResultType.fail;
      pageViewModel.pageDataModel?.errorMsg = (e as Map).toString();
    }

    return pageViewModel;
  }

}
