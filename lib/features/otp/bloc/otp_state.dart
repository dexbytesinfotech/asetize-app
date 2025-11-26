part of 'otp_bloc.dart';

abstract class OtpState{}

class OtpLoadingState extends OtpState {}

class OtpErrorState extends OtpState {
 String? error;
 OtpErrorState({this.error});
}

class OtpInitialState extends OtpState {}

class SendOtpDoneState extends OtpState {}

class GetOtpDoneState extends OtpState {}