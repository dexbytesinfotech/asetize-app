import 'package:either_dart/src/either.dart';
import 'package:equatable/equatable.dart';
import 'package:asetize/core/error/failures.dart';
import 'package:asetize/features/domain/domain.dart';
import '../../my_post/models/get_feed_data_model.dart';

class GetUserPostData implements UseCase<FeedDataModel, UserPostParams> {
  final Repository repository;

  GetUserPostData(this.repository);

  @override
  Future<Either<Failure, FeedDataModel>> call(UserPostParams params) async {
    try {
      return repository.getUserPostData(userPostParams: params);
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

class UserPostParams extends Equatable {
  final String? url;
  const UserPostParams({this.url});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
