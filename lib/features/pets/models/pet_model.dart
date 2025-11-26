import 'package:asetize/features/pets/models/pet_data_model.dart';

class PetModel {
  List<PetData>? data;
  String? message;

  PetModel({this.data, this.message});

  PetModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PetData>[];
      json['data'].forEach((v) {
        data!.add(new PetData.fromJson(v));
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


