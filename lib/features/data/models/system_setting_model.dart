class SystemSettingModel {
  SystemSettingData? systemSettingData;
  String? message;

  SystemSettingModel({this.systemSettingData, this.message});

  SystemSettingModel.fromJson(Map<String, dynamic> json) {
    systemSettingData = json['SystemSettingData'] != null ? new SystemSettingData.fromJson(json['SystemSettingData']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> SystemSettingData = new Map<String, dynamic>();
    if (this.systemSettingData != null) {
      SystemSettingData['SystemSettingData'] = this.systemSettingData!.toJson();
    }
    SystemSettingData['message'] = this.message;
    return SystemSettingData;
  }
}

class SystemSettingData {
  String? appName;
  String? appLogo;
  String? currencyPosition;
  String? thousandSeparator;
  String? decimalSeparator;
  int? numberOfDecimals;
  String? timeFormat;
  String? dateFormat;
  String? currency;
  int? supportNumber;
  String? currencySymbol;
  FamilyRelationships? familyRelationships;
  List<PetTypes>? petTypes;
   List<String>? nocTypes;


  SystemSettingData(
      {this.appName,
        this.appLogo,
        this.currencyPosition,
        this.thousandSeparator,
        this.decimalSeparator,
        this.numberOfDecimals,
        this.timeFormat,
        this.dateFormat,
        this.currency,
        this.supportNumber,
        this.currencySymbol,
        this.familyRelationships,
        this.petTypes,
        this.nocTypes

      });

  SystemSettingData.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    appLogo = json['app_logo'];
    currencyPosition = json['currency_position'];
    thousandSeparator = json['thousand_separator'];
    decimalSeparator = json['decimal_separator'];
    numberOfDecimals = json['number_of_decimals'];
    timeFormat = json['time_format'];
    dateFormat = json['date_format'];
    currency = json['currency'];
    supportNumber = json['support_number'];
    currencySymbol = json['currency_symbol'];
    nocTypes = json['noc_types'] != null
        ? List<String>.from(json['noc_types'])
        : null;

    familyRelationships = json['family_relationships'] != null
        ? new FamilyRelationships.fromJson(json['family_relationships'])
        : null;
    if (json['pet_types'] != null) {
      petTypes = <PetTypes>[];
      json['pet_types'].forEach((v) {
        petTypes!.add(new PetTypes.fromJson(v));
      });
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> SystemSettingData = new Map<String, dynamic>();
    SystemSettingData['app_name'] = this.appName;
    SystemSettingData['app_logo'] = this.appLogo;
    SystemSettingData['currency_position'] = this.currencyPosition;
    SystemSettingData['thousand_separator'] = this.thousandSeparator;
    SystemSettingData['decimal_separator'] = this.decimalSeparator;
    SystemSettingData['number_of_decimals'] = this.numberOfDecimals;
    SystemSettingData['time_format'] = this.timeFormat;
    SystemSettingData['date_format'] = this.dateFormat;
    SystemSettingData['currency'] = this.currency;
    SystemSettingData['support_number'] = this.supportNumber;
    SystemSettingData['currency_symbol'] = this.currencySymbol;
    if (this.familyRelationships != null) {
      SystemSettingData['family_relationships'] = this.familyRelationships!.toJson();
    }

    if (this.petTypes != null) {
      SystemSettingData['pet_types'] = this.petTypes!.map((v) => v.toJson()).toList();
    }


    if (nocTypes != null) {
      SystemSettingData['noc_types'] = nocTypes;
    }
    return SystemSettingData;
  }
}

class FamilyRelationships {
  String? owner;
  String? father;
  String? son;
  String? daughter;
  String? husband;
  String? wife;
  String? brother;
  String? sister;
  String? grandfather;
  String? grandmother;
  String? uncle;
  String? aunt;
  String? nephew;
  String? niece;
  String? cousin;
  String? guardian;
  String? other;

  FamilyRelationships(
      {this.owner,
        this.father,
        this.son,
        this.daughter,
        this.husband,
        this.wife,
        this.brother,
        this.sister,
        this.grandfather,
        this.grandmother,
        this.uncle,
        this.aunt,
        this.nephew,
        this.niece,
        this.cousin,
        this.guardian,
        this.other});

  FamilyRelationships.fromJson(Map<String, dynamic> json) {
    owner = json['owner'];
    father = json['father'];
    son = json['son'];
    daughter = json['daughter'];
    husband = json['husband'];
    wife = json['wife'];
    brother = json['brother'];
    sister = json['sister'];
    grandfather = json['grandfather'];
    grandmother = json['grandmother'];
    uncle = json['uncle'];
    aunt = json['aunt'];
    nephew = json['nephew'];
    niece = json['niece'];
    cousin = json['cousin'];
    guardian = json['guardian'];
    other = json['other'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> SystemSettingData = new Map<String, dynamic>();
    SystemSettingData['owner'] = this.owner;
    SystemSettingData['father'] = this.father;
    SystemSettingData['son'] = this.son;
    SystemSettingData['daughter'] = this.daughter;
    SystemSettingData['husband'] = this.husband;
    SystemSettingData['wife'] = this.wife;
    SystemSettingData['brother'] = this.brother;
    SystemSettingData['sister'] = this.sister;
    SystemSettingData['grandfather'] = this.grandfather;
    SystemSettingData['grandmother'] = this.grandmother;
    SystemSettingData['uncle'] = this.uncle;
    SystemSettingData['aunt'] = this.aunt;
    SystemSettingData['nephew'] = this.nephew;
    SystemSettingData['niece'] = this.niece;
    SystemSettingData['cousin'] = this.cousin;
    SystemSettingData['guardian'] = this.guardian;
    SystemSettingData['other'] = this.other;
    return SystemSettingData;
  }
}

class PetTypes {
  String? name;
  List<String>? data;

  PetTypes({this.name, this.data});

  PetTypes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['data'] = this.data;
    return data;
  }
}