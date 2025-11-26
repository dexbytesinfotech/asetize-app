part of 'otp_bloc.dart';

abstract class OtpEvent{}

class SendOtpEvent extends OtpEvent{
  BuildContext context;
  String otp;
  String? deviceName;
  String? deviceType;
  int? deviceId;
  int? fcmToken;
  int? deviceVersion;
  SendOtpEvent({required this.context, required this.otp ,this.deviceName ,this.deviceType ,this.deviceId ,this.fcmToken ,this.deviceVersion ,});
}

class GetOtpEvent extends OtpEvent{
  BuildContext context;
  GetOtpEvent({required this.context});
}