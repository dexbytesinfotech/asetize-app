import '../../../imports.dart';
import '../../data/models/post_update_token_model.dart';

class PostUpdateToken extends UseCase<UpdateTokenModel, UpdateTokeParams> {
  final Repository repository;
  PostUpdateToken(this.repository);
  @override
  Future<Either<Failure, UpdateTokenModel>> call(
      UpdateTokeParams params) async {
    try {
      return repository.updateToken(params: params);
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

class UpdateTokeParams {
  final String deviceId;
  final String deviceName;
  final String fcmToken;
  final String deviceVersion;
  final String deviceType;
  final String appVersion;

  const UpdateTokeParams({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.deviceVersion,
    required this.fcmToken,
    required this.appVersion,
  });

}
