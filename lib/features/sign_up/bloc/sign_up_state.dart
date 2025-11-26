part of 'sign_up_bloc.dart';

abstract class SignUpState{}

class SignUpLoadingState extends SignUpState {}

class SignUpErrorState extends SignUpState {
 String? error;
 SignUpErrorState({this.error});
}

class SignUpInitialState extends SignUpState {}

class SignUpDoneState extends SignUpState {}