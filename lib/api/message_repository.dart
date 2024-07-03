import 'package:dio/dio.dart';
import 'package:flutter_develop_template/api/base_repository.dart';
import 'package:flutter_develop_template/common/net/dio_client.dart';

import '../common/mvvm/base_view_model.dart';
import '../module/message/model/message_list_m.dart';

class MessageRepository extends BaseRepository {

  /// 分页列表
  Future<PageViewModel> getMessageData({
    required PageViewModel pageViewModel,
    CancelToken? cancelToken,
    int curPage = 0,
  }) async => httpPagingRequest(
      pageViewModel: pageViewModel,
      cancelToken: cancelToken,
      jsonCoverEntity: MessageListModel.fromJson,
      curPage: curPage,
      future: DioClient().doGet('article/list/$curPage/json', cancelToken: cancelToken));


  /// 这是不使用 httpPagingRequest 的原始写法，如果业务复杂，可能还是需要在原始写法上，扩展
  // /// 分页列表
  // Future<PageViewModel> getMessageData({
  //   required PageViewModel pageViewModel,
  //   CancelToken? cancelToken,
  //   int curPage = 0,
  // }) async {
  //   try {
  //     Response response = await DioClient().doGet('article/list/$curPage/json', cancelToken: cancelToken);
  //
  //     if(response.statusCode == REQUEST_SUCCESS) {
  //       /// 请求成功
  //       pageViewModel.pageDataModel?.type = NotifierResultType.success;
  //
  //       /// 有分页
  //       pageViewModel.pageDataModel?.isPaging = true;
  //
  //       /// 分页代码
  //       /// ViewModel 和 Model 相互持有代码，写着 correlationPaging() 里面
  //       pageViewModel.pageDataModel?.correlationPaging(pageViewModel, MessageListModel.fromJson(response.data));
  //     } else {
  //
  //       /// 请求成功，但业务不通过，比如没有权限
  //       pageViewModel.pageDataModel?.type = NotifierResultType.unauthorized;
  //       pageViewModel.pageDataModel?.errorMsg = response.statusMessage;
  //     }
  //
  //   } on DioException catch (dioEx) {
  //     /// 请求异常
  //     pageViewModel.pageDataModel?.type = NotifierResultType.dioError;
  //     pageViewModel.pageDataModel?.errorMsg = dioErrorConversionText(dioEx);
  //   } catch (e) {
  //     /// 未知异常
  //     pageViewModel.pageDataModel?.type = NotifierResultType.fail;
  //     pageViewModel.pageDataModel?.errorMsg = e.toString();
  //   }
  //
  //   return pageViewModel;
  // }

}
