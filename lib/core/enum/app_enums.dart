enum VisitorStatus {
  checkedIn,
  checkedOut,
}

extension VisitorStatusExtension on VisitorStatus {
  String get value {
    switch (this) {
      case VisitorStatus.checkedIn:
        return "checked-in";
      case VisitorStatus.checkedOut:
        return "checked-out";
    }
  }
}

enum DetailType {
  name,
  title,
  description,
  date,
  status,
}