import 'package:asetize/imports.dart';

class NewProfileUpdate
    implements UseCase<UserResponseModel, NewProfileUpdateParams> {
  final Repository repository;

  NewProfileUpdate(this.repository);

  @override
  Future<Either<Failure, UserResponseModel>> call(
      NewProfileUpdateParams params) async {
    try {
      return repository.newProfileUpdate(newProfileUpdateParams: params);
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

class NewProfileUpdateParams  {
  final String? profilePhoto;
  final String? firstName;
  final String? lateName;
  final String? email;
  const NewProfileUpdateParams(
     {
    this.profilePhoto,  this.firstName, this.lateName, this.email,
  });
}
