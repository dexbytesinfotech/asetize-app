import 'package:asetize/imports.dart';

class GetAppNotificationList
    implements UseCase<NotificationDataModel, dynamic> {
  final Repository repository;

  GetAppNotificationList(this.repository);

  @override
  Future<Either<Failure, NotificationDataModel>> call(params) async {
    try {
      return repository.getNotification();
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
