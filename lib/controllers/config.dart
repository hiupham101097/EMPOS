import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/config_model.dart';
import '../models/key_value.dart';

class Config {
  static KeyValue getDeviceConnect() {
    GetIt getIt = GetIt.instance;

    var config = getIt.get<ConfigModel>();
    return KeyValue(
      key: "MOBILE:TOKEN",
      value: config.deviceId!,
      value1: config.token,
      value2: "PUSH",
    );
  }

  static Future<void> setDeviceId() async {
    GetIt getIt = GetIt.instance;
    var config = getIt.get<ConfigModel>();

    var prefs = await SharedPreferences.getInstance();

    var deviceId = prefs.getString('DeviceId') ?? "";

    if (deviceId == "") {
      deviceId = const Uuid().v4();
      await prefs.setString('DeviceId', deviceId);
    }

    config.deviceId = deviceId;
  }
}
