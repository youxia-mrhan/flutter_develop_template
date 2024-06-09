import 'package:dio/dio.dart';

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
      str = '[DioExceptionType.connectionTimeout] 连接超时';
      break;
    case DioExceptionType.sendTimeout:
      str = '[DioExceptionType.sendTimeout] 发送超时';
      break;
    case DioExceptionType.receiveTimeout:
      str = '[DioExceptionType.receiveTimeout] 接收超时';
      break;
    case DioExceptionType.badCertificate:
      str = '[DioExceptionType.badCertificate] 访问证书错误';
      break;
    case DioExceptionType.badResponse:
      str = '[DioExceptionType.badResponse] 验证失败';
      break;
    case DioExceptionType.connectionError:
      str = '[DioExceptionType.connectionError] 连接异常';
      break;
    case DioExceptionType.unknown:
    default:
      str = '[DioExceptionType.unknown] 未知错误';
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
        str = '[$statusCode] 参数有误';
        break;
      case 402:
        str = '[$statusCode] 啊 这是一个非法请求呢';
        break;
      case 403:
        str = '[$statusCode] 服务器拒绝请求';
        break;
      case 404:
        str = '[$statusCode] 访问地址不存在';
        break;
      case 405:
        str = '[$statusCode] 请求方式错误';
        break;
      case 500:
        str = '[$statusCode] 服务器内部出错了';
        break;
      case 502:
        str = '[$statusCode] 无效的请求哦';
        break;
      case 503:
        str = '[$statusCode] 服务器说他在忙';
        break;
      case 505:
        str = '[$statusCode] 不支持的HTTP协议';
        break;
      default:
        str = '[$statusCode] 未知错误';
        break;
    }
  } else {
    str = '[$statusCode] 未知错误';
  }
  return str;
}


