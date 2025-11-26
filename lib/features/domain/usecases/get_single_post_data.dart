import '../../../imports.dart';

class GetSinglePost implements UseCase<SinglePostModel, SinglePostParams> {
  final Repository repository;

  GetSinglePost(this.repository);

  @override
  Future<Either<Failure, SinglePostModel>> call(SinglePostParams params) async {
    try {
      return repository.getSinglePost(singlePostParams: params);
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

class SinglePostParams {
  int? postId;
  SinglePostParams({
    this.postId,
  });
}
