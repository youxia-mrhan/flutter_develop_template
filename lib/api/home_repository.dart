import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/common/net/dio_client.dart';

import '../module/home/model/home_list_m.dart';
import 'base_repository.dart';

class HomeRepository extends BaseRepository {

  /// 获取首页数据
  Future<PageViewModel> getHomeData({
    required PageViewModel pageViewModel,
    CancelToken? cancelToken,
    int curPage = 0,
  }) async =>
      httpPageRequest(
          pageViewModel: pageViewModel,
          jsonCoverEntity: HomeListModel.fromJson,
          future: DioClient().doGet('project/list/$curPage/json?cid=294', cancelToken: cancelToken),
          cancelToken: cancelToken,
          curPage: curPage);


/// 这是不使用 httpPageRequest 的原始写法，如果业务复杂，可能还是需要在原始写法上，扩展
// /// 获取首页数据
// Future<PageViewModel> getHomeData({
//   required PageViewModel pageViewModel,
//   CancelToken? cancelToken,
//   int curPage = 0,
// }) async {
//   try {
//     Response response = await DioClient().doGet('project/list/$curPage/json?cid=294', cancelToken: cancelToken);
//
//     if(response.statusCode == REQUEST_SUCCESS) {
//       /// 请求成功
//       pageViewModel.pageDataModel?.type = NotifierResultType.success;
//
//       /// ViewModel 和 Model 相互持有
//       HomeListModel model = HomeListModel.fromJson(response.data);
//       model.vm = pageViewModel;
//       pageViewModel.pageDataModel?.data = model;
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
//
//   } catch (e) {
//     /// 未知异常
//     pageViewModel.pageDataModel?.type = NotifierResultType.fail;
//     pageViewModel.pageDataModel?.errorMsg = e.toString();
//   }
//
//   return pageViewModel;
// }
}
