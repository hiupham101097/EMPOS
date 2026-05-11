// ignore_for_file: constant_identifier_names, prefer_if_null_operators

import 'dart:convert';

enum AppHttpModelStatus {
  Success,
  Error,
}

class AppHttpModel<T> {
  T? value;
  AppHttpModelStatus status;
  String? message;
  String? details;

  AppHttpModel(
    this.value, {
    this.status = AppHttpModelStatus.Success,
    this.message,
    this.details,
  });

  static AppHttpModel<T> getError<T>(String input) {
    try {
      var value = json.decode(input);
      var error = value["error"] != null ? value["error"] : value;

      return AppHttpModel<T>(
        null,
        status: AppHttpModelStatus.Error,
        message: error["message"] != null ? error["message"] : "",
        details: error["details"] != null ? error["details"] : "",
      );
    } catch (ex) {
      return AppHttpModel<T>(
        null,
        status: AppHttpModelStatus.Error,
        message: ex.hashCode.toString(),
        details: ex.toString(),
      );
    }
  }
}
