import 'package:asetize/imports.dart';

class GetUserLogout implements UseCase<bool, UserLogoutParams> {
  final Repository repository;

  GetUserLogout(this.repository);

  @override
  Future<Either<Failure, bool>> call(UserLogoutParams params) async {
    try {
      return repository.getUserLogout(userLogoutParams: params);
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

class UserLogoutParams {
  final String deviceId;
  UserLogoutParams({required this.deviceId});
}
