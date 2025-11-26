import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SubmitSignInEvent extends SignInEvent {
  final Map? requestData;
  final BuildContext? mContext;

  const SubmitSignInEvent({this.requestData, this.mContext});

  @override
  String toString() => 'RemoveProduct { index: $requestData }';
}
