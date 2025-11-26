import '../../../imports.dart';

class DeleteComment extends UseCase<bool, DeleteCommentParams> {
  final Repository repository;
  DeleteComment(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteCommentParams params) async {
    try {
      return repository.deleteComment(deleteCommentParams: params);
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

class DeleteCommentParams extends Equatable {
  final int? commentId;
  const DeleteCommentParams({
    this.commentId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
