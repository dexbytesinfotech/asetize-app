class TaskFiltersModel {
  List<String>? types;
  List<String>? statuses;
  List<Assignees>? assignees;
  List<String>? datePresets;
  List<String>? priorities;

  TaskFiltersModel(
      {this.types,
        this.statuses,
        this.assignees,
        this.datePresets,
        this.priorities});

  TaskFiltersModel.fromJson(Map<String, dynamic> json) {
    types = json['types'].cast<String>();
    statuses = json['statuses'].cast<String>();
    if (json['assignees'] != null) {
      assignees = <Assignees>[];
      json['assignees'].forEach((v) {
        assignees!.add(new Assignees.fromJson(v));
      });
    }
    datePresets = json['date_presets'].cast<String>();
    priorities = json['priorities'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['types'] = this.types;
    data['statuses'] = this.statuses;
    if (this.assignees != null) {
      data['assignees'] = this.assignees!.map((v) => v.toJson()).toList();
    }
    data['date_presets'] = this.datePresets;
    data['priorities'] = this.priorities;
    return data;
  }
}

class Assignees {
  int? id;
  String? name;
  String? firstName;
  String? lastName;

  Assignees({this.id, this.name, this.firstName, this.lastName});

  Assignees.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}
