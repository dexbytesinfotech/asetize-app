import 'package:asetize/features/data/models/user_response_model.dart';

class MarriageAnniversaryDataModel {
  List<MarriageAnniversaryData>? data;
  String? message;

  MarriageAnniversaryDataModel({this.data, this.message});

  MarriageAnniversaryDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MarriageAnniversaryData>[];
      json['data'].forEach((v) {
        data!.add(new MarriageAnniversaryData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class MarriageAnniversaryData {
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  String? profilePhoto;
  String? jobTitle;
  String? marriageAnniversaryDate;
  String? description;
  User? user;

  MarriageAnniversaryData(
      {this.id,
      this.name,
      this.firstName,
      this.lastName,
      this.profilePhoto,
      this.jobTitle,
      this.marriageAnniversaryDate,
      this.description,
      this.user});

  MarriageAnniversaryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePhoto = json['profile_photo'];
    jobTitle = json['job_title'];
    marriageAnniversaryDate = json['marriage_anniversary_date'];
    description = json['description'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_photo'] = this.profilePhoto;
    data['job_title'] = this.jobTitle;
    data['marriage_anniversary_date'] = this.marriageAnniversaryDate;
    data['description'] = this.description;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
