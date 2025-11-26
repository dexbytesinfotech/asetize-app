import '../../../imports.dart';
import '../../otp/models/resend_otp_model.dart';

class GetResendOtp implements UseCase<ResendOtpModel, dynamic> {
  final Repository repository;

  GetResendOtp(this.repository);

  @override
  Future<Either<Failure, ResendOtpModel>> call(params) async {
    try {
      return repository.getResendOtp();
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