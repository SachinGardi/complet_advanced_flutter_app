import 'package:complete_advanced_flutter_app/data/network/failure.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTHORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT
}

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      // dio error so its error from response of the api
      failure = _handleError(error);
    } else {
      ///Default error
      failure = DataSource.DEFAULT.getFailure();
    }
  }

  Failure _handleError(DioException error) {
    switch(error.type){
      case DioExceptionType.connectionTimeout:
        return DataSource.CONNECT_TIMEOUT.getFailure();

      case DioExceptionType.sendTimeout:
        return DataSource.SEND_TIMEOUT.getFailure();

      case DioExceptionType.receiveTimeout:
        return DataSource.RECIEVE_TIMEOUT.getFailure();

      case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();

      case DioExceptionType.badResponse:
        switch(error.response?.statusCode){
          case ResponseCode.BAD_REQUEST:
            return DataSource.BAD_REQUEST.getFailure();
          case ResponseCode.FORBIDDEN:
            return DataSource.FORBIDDEN.getFailure();
          case ResponseCode.UNAUTHORISED:
            return DataSource.UNAUTHORISED.getFailure();
          case ResponseCode.NOT_FOUND:
            return DataSource.NOT_FOUND.getFailure();
          case ResponseCode.INTERNAL_SERVER_ERROR:
            return DataSource.INTERNAL_SERVER_ERROR.getFailure();
            default:
              return DataSource.DEFAULT.getFailure();
        }

      case DioExceptionType.badCertificate:
        return DataSource.DEFAULT.getFailure();

      case DioExceptionType.connectionError:
        return DataSource.CONNECT_TIMEOUT.getFailure();

      case DioExceptionType.unknown:
        return DataSource.DEFAULT.getFailure();

    }
  }
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS.tr());
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST.tr());

      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, ResponseMessage.FORBIDDEN.tr());

      case DataSource.UNAUTHORISED:
        return Failure(ResponseCode.UNAUTHORISED, ResponseMessage.UNAUTHORISED.tr());

      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND.tr());

      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR,
            ResponseMessage.INTERNAL_SERVER_ERROR.tr());

      case DataSource.CONNECT_TIMEOUT:
        return Failure(
            ResponseCode.CONNECT_TIMEOUT, ResponseMessage.CONNECT_TIMEOUT.tr());

      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL.tr());

      case DataSource.RECIEVE_TIMEOUT:
        return Failure(
            ResponseCode.RECIEVE_TIMEOUT, ResponseMessage.RECIEVE_TIMEOUT.tr());

      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT.tr());

      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR.tr());

      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION,
            ResponseMessage.NO_INTERNET_CONNECTION.tr());

      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT.tr());

        default:
          return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT.tr());

    }
  }
}

class ResponseCode {
  ///Api status codes
  static const int SUCCESS = 200; //success with data
  static const int NO_CONTENT = 201; // success with no content;
  static const int BAD_REQUEST = 400; // failure, api rejected the request
  static const int FORBIDDEN = 403; //failure, api rejected the request
  static const int UNAUTHORISED = 401; //failure, user is not authorised
  static const int NOT_FOUND =
      404; // failure, api url is not correct and not found
  static const int INTERNAL_SERVER_ERROR =
      500; // failure, crash happened in server side

  //local status code
  static const int DEFAULT = -1;
  static const int CONNECT_TIMEOUT = -2;
  static const int CANCEL = -3;
  static const int RECIEVE_TIMEOUT = -4;
  static const int SEND_TIMEOUT = -5;
  static const int CACHE_ERROR = -6;
  static const int NO_INTERNET_CONNECTION = -7;
}

class ResponseMessage {
  ///Api status codes
  static const String SUCCESS = "success"; //success with data
  static const String NO_CONTENT =
      "no_content"; // success with no content;
  static const String BAD_REQUEST =
      "bad_request_error"; // failure, api rejected the request
  static const String FORBIDDEN =
      "forbidden_error"; //failure, api rejected the request
  static const String UNAUTHORISED =
      "unauthorized_error"; //failure, user is not authorised
  static const String NOT_FOUND =
      "not_found_error"; // failure, api url is not correct and not found
  static const String INTERNAL_SERVER_ERROR =
      "internal_server_error"; // failure, crash happened in server side

  //local status code
  static const String DEFAULT = "default_error";
  static const String CONNECT_TIMEOUT = "timeout_error";
  static const String CANCEL = "default_error";
  static const String RECIEVE_TIMEOUT = "timeout_error";
  static const String SEND_TIMEOUT = "timeout_error";
  static const String CACHE_ERROR = "cache_error";
  static const String NO_INTERNET_CONNECTION = "no_internet_error";
}

class ApiInternalStatus{
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}
