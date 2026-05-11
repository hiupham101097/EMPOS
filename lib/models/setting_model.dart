class SettingModel {
  final String? app;
  final String? key;
  final String? url; // Nếu url bắt buộc phải có
  final String? id;

  SettingModel({this.url, this.app, this.key, this.id});

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      url: json['url'] ?? "",
      app: json['app'] ?? "",
      key: json['key'] ?? "",
      id: json['id'] ?? "",
    );
  }
}
