import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_develop_template/common/mvvm/base_model.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/common/widget/notifier_widget.dart';

import '../common/net/dio_response.dart';

typedef JsonCoverEntity<T extends BaseModel> = T Function(Map<String, dynamic> json);

class BaseRepository {

  /// 统一处理 响应数据，可以避免写 重复代码，但如果业务复杂，可能还是需要在原始写法上，扩展

  /// 普通页面（非分页）数据请求 统一处理
  Future<PageViewModel> httpPageRequest({
    required PageViewModel pageViewModel,
    required Future<Response> future,
    required JsonCoverEntity jsonCoverEntity,
    CancelToken? cancelToken,
    int curPage = 0,
  }) async {
    try {
      Response response = await future;

      if (response.statusCode == REQUEST_SUCCESS) {
        /// 请求成功
        pageViewModel.pageDataModel?.type = NotifierResultType.success;

        /// ViewModel 和 Model 相互持有
        dynamic model = jsonCoverEntity(response.data);
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
      pageViewModel.pageDataModel?.errorMsg = e.toString();
    }

    return pageViewModel;
  }

  /// 分页数据请求 统一处理
  Future<PageViewModel> httpPagingRequest({
    required PageViewModel pageViewModel,
    required Future<Response> future,
    required JsonCoverEntity jsonCoverEntity,
    CancelToken? cancelToken,
    int curPage = 0,
  }) async {
    try {
      Response response = await future;

      if (response.statusCode == REQUEST_SUCCESS) {
        /// 请求成功
        pageViewModel.pageDataModel?.type = NotifierResultType.success;

        /// 有分页
        pageViewModel.pageDataModel?.isPaging = true;

        /// 分页代码
        /// ViewModel 和 Model 相互持有代码，写着 correlationPaging() 里面
        pageViewModel.pageDataModel?.correlationPaging(
            pageViewModel, jsonCoverEntity(response.data) as dynamic);
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
      pageViewModel.pageDataModel?.errorMsg = e.toString();
    }

    return pageViewModel;
  }

}
