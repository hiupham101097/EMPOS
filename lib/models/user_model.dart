class UserModel {
  UserModel({
    this.id,
    this.userName,
    this.name,
    this.surname,
    this.emailAddress,
    this.fullName,
    this.isActive,
    this.isEmailConfirmed,
    this.phoneNumber,
    this.gender,
    this.dob, 
    this.attributes,
    this.creatorUserId,
    this.creationTime,
    this.creationDateTime,
    this.lastModifierUserId,
    this.lastModificationTime,
  });

  String? id;
  String? userName;
  String? name;
  String? surname;  
  String? emailAddress;
  String? fullName;
  bool? isActive;
  bool? isEmailConfirmed;
  String? phoneNumber;
  String? gender;
  String? dob;    
  String? attributes;
  String? creatorUserId;
  String? creationTime; 
  int? creationDateTime;
  String? lastModifierUserId;
  String? lastModificationTime; 
  int? lastModificationDateTime;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? "",
      userName: json['userName'] ?? "",
      name: json['name'] ?? "",
      surname: json['surname'] ?? "",
      emailAddress: json['emailAddress'] ?? "",
      fullName: json['fullName'] ?? "",
      isActive: json['isActive'] ?? false,
      isEmailConfirmed: json['isEmailConfirmed'] ?? false,
      phoneNumber: json['phoneNumber'] ?? "",
      gender: json['gender'] ?? "",
      dob: json['dob'] ?? "",
      attributes: json['attributes'] ?? "",
      creatorUserId: json['creatorUserId'] ?? "",
      creationTime: json['creationTime'] ?? "",
      creationDateTime: json['creationDateTime'] ?? 0,
      lastModifierUserId: json['lastModifierUserId'] ?? "",
      lastModificationTime: json['lastModificationTime'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'name': name,
    'surname': surname,
    'emailAddress': emailAddress,
    'fullName': fullName,
    'isActive': isActive,
    'isEmailConfirmed': isEmailConfirmed,
    'phoneNumber': phoneNumber,
    'gender': gender,
    'dob': dob,
    'attributes': attributes,
    'creatorUserId': creatorUserId,
    'creationTime': creationTime,
    'creationDateTime': creationDateTime,
    'lastModifierUserId': lastModifierUserId,
    'lastModificationTime': lastModificationTime,
    'lastModificationDateTime': lastModificationDateTime,
  };
}
