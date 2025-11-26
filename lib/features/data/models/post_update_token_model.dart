class UpdateTokenModel {
  Data? data;
  String? message;

  UpdateTokenModel({this.data, this.message});

  UpdateTokenModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? deviceType;
  String? appVersion;
  String? appName;
  String? deviceUid;
  Null? lastKnownLatitude;
  Null? lastKnownLongitude;
  String? deviceTokenId;
  String? deviceName;
  Null? deviceModel;
  String? deviceVersion;
  String? pushBadge;
  String? pushAlert;
  String? pushSound;
  String? status;
  Null? errorCount;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.userId,
        this.deviceType,
        this.appVersion,
        this.appName,
        this.deviceUid,
        this.lastKnownLatitude,
        this.lastKnownLongitude,
        this.deviceTokenId,
        this.deviceName,
        this.deviceModel,
        this.deviceVersion,
        this.pushBadge,
        this.pushAlert,
        this.pushSound,
        this.status,
        this.errorCount,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    deviceType = json['device_type'];
    appVersion = json['app_version'];
    appName = json['app_name'];
    deviceUid = json['device_uid'];
    lastKnownLatitude = json['last_known_latitude'];
    lastKnownLongitude = json['last_known_longitude'];
    deviceTokenId = json['device_token_id'];
    deviceName = json['device_name'];
    deviceModel = json['device_model'];
    deviceVersion = json['device_version'];
    pushBadge = json['push_badge'];
    pushAlert = json['push_alert'];
    pushSound = json['push_sound'];
    status = json['status'];
    errorCount = json['error_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['device_type'] = this.deviceType;
    data['app_version'] = this.appVersion;
    data['app_name'] = this.appName;
    data['device_uid'] = this.deviceUid;
    data['last_known_latitude'] = this.lastKnownLatitude;
    data['last_known_longitude'] = this.lastKnownLongitude;
    data['device_token_id'] = this.deviceTokenId;
    data['device_name'] = this.deviceName;
    data['device_model'] = this.deviceModel;
    data['device_version'] = this.deviceVersion;
    data['push_badge'] = this.pushBadge;
    data['push_alert'] = this.pushAlert;
    data['push_sound'] = this.pushSound;
    data['status'] = this.status;
    data['error_count'] = this.errorCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
