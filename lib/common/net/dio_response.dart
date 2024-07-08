import 'package:dio/dio.dart';

import '../../res/string/str_common.dart';

/// 响应的数据模型，根据你当前后台返回的数据来自定义，我这里只是做个例子
abstract class BaseResponseData {
  int? statusCode;
  String? statusMessage;
  dynamic data;
}

const int REQUEST_SUCCESS = 0;
class ResponseData extends BaseResponseData {

  bool get success => statusCode == REQUEST_SUCCESS;

  String? get statusMsgConversion => serviceFailureConversionText(statusCode);

  /// 这里是 业务逻辑不通过
  /// code 由后台人员自定义
  String? serviceFailureConversionText(int? errCode) {
    String str;
    switch (errCode) {
      case -1 : {
        str = statusMessage ?? '-1';
      } break;
      default: {
        str = '未知错误';
      }
    }
    return str;
  }

  ResponseData.fromJson(Map<String, dynamic> json) {
    statusCode = json['errorCode'] ?? json['code'];
    statusMessage = json['errorMsg'] ?? json['message'];
    data = json['data'] ?? json['data'];
  }

}

/// 根据Dio异常类型 转换为 文字
String? dioErrorConversionText(DioException e) {
  String str;
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      str = '[DioExceptionType.connectionTimeout] ${StrCommon.connectionTimeout}';
      break;
    case DioExceptionType.sendTimeout:
      str = '[DioExceptionType.sendTimeout] ${StrCommon.sendTimeout}';
      break;
    case DioExceptionType.receiveTimeout:
      str = '[DioExceptionType.receiveTimeout] ${StrCommon.receiveTimeout}';
      break;
    case DioExceptionType.badCertificate:
      str = '[DioExceptionType.badCertificate] ${StrCommon.accessCertificateError}';
      break;
    case DioExceptionType.badResponse:
      str = '[DioExceptionType.badResponse] ${StrCommon.validationFailed}';
      break;
    case DioExceptionType.connectionError:
      str = '[DioExceptionType.connectionError] ${StrCommon.connectionIsAbnormal}';
      break;
    case DioExceptionType.unknown:
    default:
      str = '[DioExceptionType.unknown] ${StrCommon.unknownError}';
      break;
  }
  return str;
}


/// 根据Dio异常code 转换为 文字
String? codeConversionText(int? statusCode) {
  String str;
  if (statusCode != null) {
    switch (statusCode) {
      case 400:
        str = '[$statusCode] ${StrCommon.parameterIsIncorrect}';
        break;
      case 402:
        str = '[$statusCode] ${StrCommon.illegalRequests}';
        break;
      case 403:
        str = '[$statusCode] ${StrCommon.serverRejectsRequest}';
        break;
      case 404:
        str = '[$statusCode] ${StrCommon.accessAddressDoesNotExist}';
        break;
      case 405:
        str = '[$statusCode] ${StrCommon.requestIsMadeWrongWay}';
        break;
      case 500:
        str = '[$statusCode] ${StrCommon.wasAnErrorInsideServer}';
        break;
      case 502:
        str = '[$statusCode] ${StrCommon.invalidRequest}';
        break;
      case 503:
        str = '[$statusCode] ${StrCommon.serverIsBusy}';
        break;
      case 505:
        str = '[$statusCode] ${StrCommon.unsupportedHttpProtocol}';
        break;
      default:
        str = '[$statusCode] ${StrCommon.unknownError}';
        break;
    }
  } else {
    str = '[$statusCode] ${StrCommon.unknownError}';
  }
  return str;
}


