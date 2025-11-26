import 'package:either_dart/src/either.dart';
import 'package:equatable/equatable.dart';
import 'package:asetize/core/error/failures.dart';
import 'package:asetize/features/domain/domain.dart';
import '../../my_post/models/get_feed_data_model.dart';

class GetFeedData implements UseCase<FeedDataModel, FeedParams> {
  final Repository repository;

  GetFeedData(this.repository);

  @override
  Future<Either<Failure, FeedDataModel>> call(FeedParams params) async {
    try {
      return repository.getFeedData(feedParams: params);
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

class FeedParams extends Equatable {
  final String? url;
  const FeedParams({this.url});

  @override
  List<Object?> get props => throw UnimplementedError();
}
