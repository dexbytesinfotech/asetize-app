import '../../../imports.dart';

class PostLike implements UseCase<bool, PostLikeParams> {
  final Repository repository;
  PostLike(this.repository);

  @override
  Future<Either<Failure, bool>> call(PostLikeParams postLikeParams) async {
    try {
      return repository.postLikeUpdate(postLikeParams: postLikeParams);
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

class PostLikeParams extends Equatable {
  final int? postId;
  const PostLikeParams({
    this.postId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
