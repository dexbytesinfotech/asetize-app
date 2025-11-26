import '../../../imports.dart';
import '../../otp/models/verify_otp_model.dart';

class PostVerifyOtp implements UseCase<VerifyOtpModel, VerifyOtpParams> {
  final Repository repository;
  PostVerifyOtp(this.repository);

  @override
  Future<Either<Failure, VerifyOtpModel>> call(VerifyOtpParams params) async {
    try {
      return repository.postVerifyOtp(params: params);
    } catch (e) {
      if (e is UnauthorizedFailure) {
        return Left(UnauthorizedFailure());
      }
      if (e is ServerFailure) {
        return Left(ServerFailure());
      }
      if (e is NetworkFailure) {
        return Left(NetworkFailure());
      }
      return Left(ServerFailure());
    }
  }
}

class VerifyOtpParams {
  String otp;
  final String deviceId;
  final String deviceName;
  final String fcmToken;
  final String deviceVersion;
  final String deviceType;
  VerifyOtpParams({
    required this.otp,
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.deviceVersion,
    required this.fcmToken,
  });
}
