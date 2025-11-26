class LeaveHistoryRawDataModel {
  final String title;
  final String leaveType;
  final String leaveDays;
  final String status;

  LeaveHistoryRawDataModel({
    required this.title,
    required this.leaveType,
    required this.leaveDays,
    required this.status,
  });
}

List<LeaveHistoryRawDataModel> leaveHistory = [
  LeaveHistoryRawDataModel(
      title: "Feb 14, 2023 - Feb 16, 2023",
      leaveType: 'Annual Leave',
      leaveDays: '3 Days',
      status: "pending"),
  LeaveHistoryRawDataModel(
      title: "Jan 28, 2023 - Jan 30, 2023",
      leaveType: 'Annual Leave',
      leaveDays: '3 Days',
      status: "Approved"),
  LeaveHistoryRawDataModel(
      title: "Jan 14, 2023",
      leaveType: 'Casual Leave',
      leaveDays: '1 Days',
      status: "Approved"),
  LeaveHistoryRawDataModel(
      title: "Dec 22, 2022 - Feb 26, 2022",
      leaveType: 'Annual Leave',
      leaveDays: '5 Days',
      status: "Approved"),
  LeaveHistoryRawDataModel(
      title: "Dec 5, 2023 - Dec 7, 2023",
      leaveType: 'Annual Leave',
      leaveDays: '3 Days',
      status: "Rejected"),
  LeaveHistoryRawDataModel(
      title: "November 29, 2022",
      leaveType: 'Casual Leave',
      leaveDays: '1 Days',
      status: "Approved"),
  LeaveHistoryRawDataModel(
      title: "Nov 10, 2022 - Feb 16, 2022",
      leaveType: 'Sick Leave',
      leaveDays: '1 Days',
      status: "Approved"),
  LeaveHistoryRawDataModel(
      title: "Oct 20, 2023 - Feb 22, 2023",
      leaveType: 'Annual Leave',
      leaveDays: '3 Days',
      status: "Rejected"),
  LeaveHistoryRawDataModel(
      title: "Oct 14, 2023 - Oct 16, 2022",
      leaveType: 'Annual Leave',
      leaveDays: '3 Days',
      status: "Rejected"),
];
