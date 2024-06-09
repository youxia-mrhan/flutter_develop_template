import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_develop_template/main/app.dart';
import 'package:flutter_develop_template/main/application.dart';

import '../widget/global_notification_widget.dart';
import 'dio_response.dart';

final DateTime dateTime = DateTime.now();

/// Dio拦截器
class DioInterceptor extends InterceptorsWrapper {
  /// 请求发起前，调用的方法
  /// 可以在这里动态修改Header里信息，从options里获取原来的Header信息，进行修改
  /// 常见的场景有：弹出加载loading、添加Token
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // options.headers['token'] = 'xxx'; // 设置 token

    // 打印请求日志信息
    assert(() {
      debugPrint(
          '${dateTime}：${options.method} request：${options.baseUrl + options.path}');
      debugPrint('params：${options.queryParameters}');
      return true;
    }());

    // 或者刷新token时效

    /// 重置 全局操作状态
    if (EnvConfig.isGlobalNotification) {
      GlobalOperateProvider.runGlobalOperate(
          context: navigatorKey.currentContext, operate: GlobalOperate.idle);
    }

    /// 必须要写的代码，表示进入下一步
    handler.next(options);
  }

  /// 请求成功后，执行的响应方法
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 打印响应日志信息

    // 打印请求日志信息
    assert(() {
      debugPrint('${dateTime}：response：${response.statusCode}');
      // debugPrint('data：${response.data.toString()}');
      return true;
    }());

    if (response.statusCode == 200) {
      /// 访问成功

      /// 有返回值的情况，转实体
      if (response.data is Map) {
        ResponseData responseData = ResponseData.fromJson(response.data);

        /// 成功
        if (responseData.success) {
          response.statusCode = responseData.statusCode;
          response.data = responseData.data;
        } else {
          /// 走到这，说明访问成功，但业务不允许，比如没有权限
          response.statusCode = responseData.statusCode;
          response.statusMessage = responseData.statusMsgConversion;
        }

      }

    }

    /// 必须要写的代码，表示进入下一步
    return handler.resolve(response);
  }

  /// 这里的异常，属于Dio自身的异常
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    throw DioException(
        requestOptions: err.requestOptions,
        type: err.type,
        error: err,
        response: err.response);
  }

}
