class PetData {
  int? id;
  String? name;
  String? dob;
  String? dobDisplay;
  String? type;
  String? breed;
  String? gender;
  String? photo;
  String? filename;
  bool? vaccinated;       // Changed to bool
  String? vaccinationDate;
  String? nextVaccinationDate;
  String? document;
  String? documentFilename;
  bool? remindMe;         // Changed to bool

  PetData({
    this.id,
    this.name,
    this.dob,
    this.dobDisplay,
    this.type,
    this.breed,
    this.gender,
    this.photo,
    this.filename,
    this.vaccinated,
    this.vaccinationDate,
    this.nextVaccinationDate,
    this.document,
    this.documentFilename,
    this.remindMe,
  });

  /// Factory Constructor for JSON Parsing
  PetData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dob = json['dob'];
    dobDisplay = json['dob_display'];
    type = json['type'];
    breed = json['breed'];
    gender = json['gender'];
    photo = json['photo'];
    filename = json['filename'];

    // Handle `vaccinated` as bool, int, or string
    vaccinated = _parseBool(json['vaccinated']);

    vaccinationDate = json['vaccination_date'];
    nextVaccinationDate = json['next_vaccination_date'];
    document = json['document'];
    documentFilename = json['document_filename'];

    // Handle `remind_me` as bool, int, or string
    remindMe = _parseBool(json['remind_me']);
  }

  /// Helper method to handle `0/1`, `true/false`, and string-based values
  bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }

  /// Convert object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dob': dob,
      'dob_display': dobDisplay,
      'type': type,
      'breed': breed,
      'gender': gender,
      'photo': photo,
      'filename': filename,
      'vaccinated': vaccinated ?? false,
      'vaccination_date': vaccinationDate,
      'next_vaccination_date': nextVaccinationDate,
      'document': document,
      'document_filename': documentFilename,
      'remind_me': remindMe ?? false,
    };
  }
}
