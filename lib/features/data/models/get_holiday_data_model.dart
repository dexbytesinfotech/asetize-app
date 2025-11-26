class HolidayDataModel {
  List<HolidayData>? data;
  String? message;

  HolidayDataModel({this.data, this.message});

  HolidayDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HolidayData>[];
      json['data'].forEach((v) {
        data!.add(HolidayData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class HolidayData {
  String? title;
  String? description;
  String? startDate;
  String? endDate;

  HolidayData({this.title, this.description, this.startDate, this.endDate});

  HolidayData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    return data;
  }
}
