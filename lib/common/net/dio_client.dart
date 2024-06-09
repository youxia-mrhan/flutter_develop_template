import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../../main/application.dart';
import 'dio_interceptor.dart';

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

/// 默认超时时间
const defaultTimeout = 60 * 1000;

class DioClient extends DioForNative {
  /// 单例
  static DioClient? _instance;

  factory DioClient() => _instance ??= DioClient._init();

  /// 初始化方法
  DioClient._init() {
    (transformer as BackgroundTransformer).jsonDecodeCallback = parseJson;
    options = BaseOptions(
        // 设置基础配置
        connectTimeout: Duration(milliseconds: defaultTimeout), // 连接超时时间
        receiveTimeout: Duration(milliseconds: defaultTimeout), // 接收超时时间
        sendTimeout: Duration(milliseconds: defaultTimeout), // 发送超时时间
        baseUrl: EnvConfig.baseUrl
        // ... ...
        );
    // 拦截器
    interceptors.add(DioInterceptor()); // 拦截器

    // 代理抓包（
    // 注意：
    // 1、我使用的是Mac电脑，抓包工具是 Charles，建议正式上线时，关闭此功能
    // 2、如果开启了抓包，但没有启动 抓包工具，Dio 会报 连接异常 DioException [connection error]
    // https://juejin.cn/post/7131928652568231966
    // https://juejin.cn/post/7035652365826916366
    proxy();
  }

  /// ResultFul API 风格
  // GET：从服务器获取一项或者多项数据
  // POST：在服务器新建一个资源
  // PUT：在服务器更新所有资源
  // PATCH：更新部分属性
  // DELETE：从服务器删除资源

  /// Get请求
  Future<Response> doGet(
    path, {
    String? baseUrl,
    Map<String, dynamic>? headers,
    ResponseType responseType = ResponseType.json,
    Object? data,
    Map<String, dynamic>? params,
    Options? cOptions,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    updateBaseOptions(baseUrl, headers, responseType); // 动态修改默认BaseOptions
    return get(
      path,
      data: data,
      queryParameters: params,
      options: cOptions,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }

  /// Post 请求
  Future<Response> doPost(
    path, {
    String? baseUrl,
    Map<String, dynamic>? headers,
    ResponseType responseType = ResponseType.json,
    Object? data,
    Map<String, dynamic>? params,
    Options? cOptions,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    updateBaseOptions(baseUrl, headers, responseType); // 动态修改默认BaseOptions
    return post(path,
        data: data,
        queryParameters: params,
        options: cOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  /// Put 请求
  Future<Response> doPut(path,
      {String? baseUrl,
      Map<String, dynamic>? headers,
      ResponseType responseType = ResponseType.json,
      Object? data,
      Map<String, dynamic>? params,
      Options? cOptions,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) {
    updateBaseOptions(baseUrl, headers, responseType); // 动态修改默认BaseOptions
    return put(path,
        data: data,
        queryParameters: params,
        options: cOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  /// Patch 请求
  Future<Response> doPatch(path,
      {String? baseUrl,
      Map<String, dynamic>? headers,
      ResponseType responseType = ResponseType.json,
      Object? data,
      Map<String, dynamic>? params,
      Options? cOptions,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) {
    updateBaseOptions(baseUrl, headers, responseType); // 动态修改默认BaseOptions
    return path(path,
        listData: data,
        queryParameters: params,
        options: cOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  /// Delete 请求
  Future<Response> doDelete(path,
      {String? baseUrl,
      Map<String, dynamic>? headers,
      ResponseType responseType = ResponseType.json,
      Object? data,
      Map<String, dynamic>? params,
      Options? cOptions,
      CancelToken? cancelToken}) {
    updateBaseOptions(baseUrl, headers, responseType); // 动态修改默认BaseOptions
    return delete(
      path,
      data: data,
      queryParameters: params,
      options: cOptions,
      cancelToken: cancelToken,
    );
  }

  /// 上传文件
  Future<Response> uploadFile(
    path, {
    String? baseUrl,
    Map<String, dynamic>? headers,
    ResponseType responseType = ResponseType.json,
    Object? data,
    Map<String, dynamic>? params,
    Options? cOptions,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    updateBaseOptions(baseUrl, headers, responseType); // 动态修改默认BaseOptions
    options.contentType = Headers.multipartFormDataContentType;
    return post(path,
        data: data,
        queryParameters: params,
        options: cOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  /// 动态修改 BaseOptions
  void updateBaseOptions(
    String? baseUrl,
    Map<String, dynamic>? headers,
    ResponseType responseType,
  ) {
    if (baseUrl != null) {
      options.baseUrl = baseUrl;
    }
    if (headers != null) {
      options.headers = headers;
    }
    if (responseType != ResponseType.json) {
      options.responseType = responseType;
    }
  }

  /// 代理抓包，测试阶段可能需要
  void proxy() {
    if (EnvConfig.proxyEnable) {
      if (EnvConfig.caughtAddress?.isNotEmpty ?? false) {
        (httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
          final client = HttpClient();
          client.findProxy = (uri) => 'PROXY ' + EnvConfig.caughtAddress!;

          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        };
      }
    }
  }

}
