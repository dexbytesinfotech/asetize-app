import '../../../imports.dart';

class DeleteSpotlightComment
    extends UseCase<bool, DeleteSpotlightCommentParams> {
  final Repository repository;
  DeleteSpotlightComment(this.repository);

  @override
  Future<Either<Failure, bool>> call(
      DeleteSpotlightCommentParams params) async {
    try {
      return repository.deleteSpotlightComment(params: params);
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

class DeleteSpotlightCommentParams extends Equatable {
  final int? commentId;
  const DeleteSpotlightCommentParams({
    this.commentId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
