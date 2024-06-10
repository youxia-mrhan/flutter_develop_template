import 'package:dio/dio.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/common/net/dio_client.dart';
import 'package:flutter_develop_template/common/widget/notifier_widget.dart';

import '../common/net/dio_response.dart';
import '../module/home/model/home_list_m.dart';

class HomeRepository {

  /// 获取首页数据
  Future<PageViewModel> getHomeData({
    required PageViewModel pageViewModel,
    CancelToken? cancelToken,
    int curPage = 0,
  }) async {
    try {
      Response response = await DioClient().doGet('project/list/$curPage/json?cid=294', cancelToken: cancelToken);

      if(response.statusCode == REQUEST_SUCCESS) {
        /// 请求成功
        pageViewModel.pageDataModel?.type = NotifierResultType.success;

        /// ViewModel 和 Model 相互持有
        HomeListModel model = HomeListModel.fromJson(response.data);
        model.vm = pageViewModel;
        pageViewModel.pageDataModel?.data = model;
      } else {

        /// 请求成功，但业务不通过，比如没有权限
        pageViewModel.pageDataModel?.type = NotifierResultType.unauthorized;
        pageViewModel.pageDataModel?.errorMsg = response.statusMessage;
      }

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
