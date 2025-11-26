import 'package:asetize/imports.dart';

class PostProfileUpdate
    implements UseCase<UserResponseModel, ProfileUpdateParams> {
  final Repository repository;

  PostProfileUpdate(this.repository);

  @override
  Future<Either<Failure, UserResponseModel>> call(
      ProfileUpdateParams params) async {
    try {
      return repository.profileUpdate(profileUpdateParams: params);
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

class ProfileUpdateParams extends Equatable {
  final int? globalNotifications;
  final String? name;
  final String? defaultLang;
  final String? profilePhoto;
  const ProfileUpdateParams({
    this.globalNotifications,
    this.name,
    this.defaultLang,
    this.profilePhoto,
  });

  @override
  List<Object> get props => [
        globalNotifications!,
        name!,
        defaultLang!,
        profilePhoto!,
      ];
}
