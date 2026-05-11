import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/config_model.dart';
import 'app_http_model.dart';

class PostDefaultUrlApi {
  PostDefaultUrlApi();

  Future<AppHttpModel<dynamic>> signOut() async {
    var config = getIt.get<ConfigModel>();
    final baseUri = Uri.parse(config.baseUrl);
    final myToken = config.token;
    var connectionId = await FirebaseMessaging.instance.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $myToken',
    };
    // 1. URL endpoint
    final url = Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      path: '/app/api/services/sys/Device/SignOut',
    );
    // 2. Data gửi trong Body
    final bodyData = {
      "connectionId": connectionId,
      "clientAccessToken": myToken,
    };

    // 3. Sử dụng http.post và mã hóa json cho body
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(bodyData),
    );

    if (response.statusCode == 200) {
      return AppHttpModel(json.decode(response.body)['result']);
    } else {
      return AppHttpModel.getError(response.body);
    }
  }
}
