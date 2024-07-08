import 'package:dio/dio.dart';
import 'package:flutter_develop_template/common/repository/base_repository.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/common/net/dio_client.dart';
import 'package:flutter_develop_template/module/personal/model/user_info_m.dart';

class PersonalRepository extends BaseRepository {

  /// 注册
  Future<PageViewModel> registerUser({
    required PageViewModel pageViewModel,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async =>
      httpPageRequest(
          pageViewModel: pageViewModel,
          cancelToken: cancelToken,
          jsonCoverEntity: UserInfoModel.fromJson,
          future: DioClient().doPost(
            'user/register',
            params: params,
            cancelToken: cancelToken,
          ));

  /// 登陆
  Future<PageViewModel> loginUser({
    required PageViewModel pageViewModel,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async =>
      httpPageRequest(
          pageViewModel: pageViewModel,
          cancelToken: cancelToken,
          jsonCoverEntity: UserInfoModel.fromJson,
          future: DioClient().doPost(
            'user/login',
            params: params,
            cancelToken: cancelToken,
          ));


/// 这是不使用 httpPageRequest 的原始写法，如果业务复杂，可能还是需要在原始写法上，扩展
// /// 注册
// Future<PageViewModel> registerUser({
//   required PageViewModel pageViewModel,
//   Map<String, dynamic>? params,
//   CancelToken? cancelToken,
// }) async {
//
//   try {
//     Response response = await DioClient().doPost(
//       'user/register',
//       params: params,
//       cancelToken: cancelToken,
//     );
//
//     if(response.statusCode == REQUEST_SUCCESS) {
//       /// 请求成功
//       pageViewModel.pageDataModel?.type = NotifierResultType.success; // 请求成功
//
//       /// ViewModel 和 Model 相互持有
//       UserInfoModel model = UserInfoModel.fromJson(response.data);
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
//
// /// 登陆
// Future<PageViewModel> loginUser({
//   required PageViewModel pageViewModel,
//   Map<String, dynamic>? params,
//   CancelToken? cancelToken,
// }) async {
//
//   try {
//     Response response = await DioClient().doPost(
//       'user/login',
//       params: params,
//       cancelToken: cancelToken,
//     );
//
//     if(response.statusCode == REQUEST_SUCCESS) {
//       /// 请求成功
//       pageViewModel.pageDataModel?.type = NotifierResultType.success;
//
//       /// ViewModel 和 Model 相互持有
//       UserInfoModel model = UserInfoModel.fromJson(response.data);
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
