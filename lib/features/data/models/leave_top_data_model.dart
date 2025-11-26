import 'package:flutter/material.dart';

class LeavesTopRawDataModel {
  final String leaveDays;
  final String leaveType;
  final Color color;

  LeavesTopRawDataModel({
    required this.leaveDays,
    required this.leaveType,
    required this.color,
  });
}

List<LeavesTopRawDataModel> leaveTopData = [
  LeavesTopRawDataModel(
    leaveDays: "20 days",
    leaveType: 'Casual leave',
    color: Colors.blue.shade700,
  ),
  LeavesTopRawDataModel(
    leaveDays: "12 days",
    leaveType: 'Sick leave',
    color: Colors.green.shade500,
  ),
  LeavesTopRawDataModel(
    leaveDays: "18 days",
    leaveType: 'Annual leave',
    color: Colors.yellow.shade700,
  ),
  LeavesTopRawDataModel(
    leaveDays: "10 days",
    leaveType: 'Bereavement leave',
    color: Colors.red.shade700,
  ),
];
