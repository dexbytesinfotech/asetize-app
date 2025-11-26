class LeaveDayTypeDataModel {
  final String typeName;

  LeaveDayTypeDataModel({
    required this.typeName,
  });
}

List<LeaveDayTypeDataModel> dayType = [
  LeaveDayTypeDataModel(
    typeName: "Day's",
  ),
  LeaveDayTypeDataModel(
    typeName: "Half-Day",
  ),
];