import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FaqEvent extends Equatable {
  const FaqEvent();
  @override
  List<Object> get props => [];
}

class GetFaqListEvent extends FaqEvent {
  final BuildContext? mContext;
  const GetFaqListEvent({this.mContext});
  @override
  String toString() => 'RemoveProduct { index:}';
}
