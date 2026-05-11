class DeviceModel {
  DeviceModel({
    this.id,
    this.tenantId,
    this.userId,
    this.groupId,
    this.connectionId,
    this.name,
    this.userName,
    this.emailAddress,
    this.clientId,
    this.clientType,
    this.clientAccessToken,
    this.syncTime,
  });

  String? id;
  String? tenantId;
  String? userId;
  String? groupId;
  String? connectionId;
  String? name;
  String? userName;
  String? emailAddress;
  String? clientId;
  String? clientType;
  String? clientAccessToken;
  int? syncTime;

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] ?? "",
      tenantId: json['tenantId'] ?? "",
      userId: json['userId'] ?? "",
      groupId: json['groupId'] ?? "",
      connectionId: json['connectionId'] ?? "",
      name: json['name'] ?? "",
      userName: json['userName'] ?? "",
      emailAddress: json['emailAddress'] ?? "",
      clientId: json['clientId'] ?? "",
      clientType: json['clientType'] ?? "",
      clientAccessToken: json['clientAccessToken'] ?? "",
      syncTime: json['syncTime'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tenantId': tenantId,
    'userId': userId,
    'groupId': groupId,
    'connectionId': connectionId,
    'name': name,
    'userName': userName,
    'emailAddress': emailAddress,
    'clientId': clientId,
    'clientType': clientType,
    'clientAccessToken': clientAccessToken,
    'syncTime': syncTime,
  };
}
