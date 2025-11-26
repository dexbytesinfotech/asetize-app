import 'package:asetize/features/data/models/user_response_model.dart';

class WorkAnniversaryDataModel {
  List<WorkAnniversayData>? data;
  String? message;

  WorkAnniversaryDataModel({this.data, this.message});

  WorkAnniversaryDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <WorkAnniversayData>[];
      json['data'].forEach((v) {
        data!.add(new WorkAnniversayData.fromJson(v));
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

class WorkAnniversayData {
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  String? profilePhoto;
  String? jobTitle;
  String? doj;
  String? description;
  User? user;

  WorkAnniversayData(
      {this.id,
      this.name,
      this.firstName,
      this.lastName,
      this.profilePhoto,
      this.jobTitle,
      this.doj,
      this.description,
      this.user});

  WorkAnniversayData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePhoto = json['profile_photo'];
    jobTitle = json['job_title'];
    doj = json['doj'];
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
    data['doj'] = this.doj;
    data['description'] = this.description;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
