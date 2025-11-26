import '../../../imports.dart';
import '../../data/models/single_family_member_model.dart';

class PostFamilyMemberDetail
    extends UseCase<SingleFamilyMemberModel, AddFamilyMemberParams> {
  final Repository repository;
  PostFamilyMemberDetail(this.repository);

  @override
  Future<Either<Failure, SingleFamilyMemberModel>> call(
      AddFamilyMemberParams params) async {
    try {
      return repository.postFamilyMemberDetails(addFamilyMemberParams: params);
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

class AddFamilyMemberParams extends Equatable {
  final String? name;
  final String? dob;
  final String? relation;
  final String? photo;
  const AddFamilyMemberParams({
    this.name,
    this.dob,
    this.relation,
    this.photo,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
