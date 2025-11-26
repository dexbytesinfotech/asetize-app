import 'package:asetize/imports.dart';

class LoginUser implements UseCase<SignInModel, UserLoginParams> {
  final Repository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, SignInModel>> call(UserLoginParams params) async {
    try {
      return repository.loinUser(userLoginParams: params);
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

class UserLoginParams extends Equatable {
  final String email;
  final String password;
  final String deviceId;
  final String deviceName;
  final String fcmToken;
  final String deviceVersion;
  final String deviceType;

  const UserLoginParams({
    required this.email,
    required this.password,
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.deviceVersion,
    required this.fcmToken,
  });

  @override
  List<Object> get props => [
        email,
        password,
        deviceId,
        deviceName,
        deviceType,
        fcmToken,
        deviceVersion,
      ];
}
