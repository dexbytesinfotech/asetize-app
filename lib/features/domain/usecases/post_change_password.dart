import 'package:asetize/imports.dart';

class PostChangePassword implements UseCase<bool, ChangePasswordParams> {
  final Repository repository;

  PostChangePassword(this.repository);

  @override
  Future<Either<Failure, bool>> call(
      //..
      ChangePasswordParams params) async {
    try {
      return repository.postChangePassword(changePasswordParams: params);
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

// ignore: must_be_immutable
class ChangePasswordParams extends Equatable {
  final String? oldPassword;
  final String? newPassword;
  final String? confirmPassword;

  const ChangePasswordParams({
    this.oldPassword,
    this.newPassword,
    this.confirmPassword,
  });

  @override
  List<Object> get props => [oldPassword!, newPassword!, confirmPassword!];
}
