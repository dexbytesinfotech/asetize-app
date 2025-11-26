import 'family_model.dart';

class SingleFamilyMemberModel {
  FamilyData? data;
  String? message;

  SingleFamilyMemberModel({this.data, this.message});

  SingleFamilyMemberModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? FamilyData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}
