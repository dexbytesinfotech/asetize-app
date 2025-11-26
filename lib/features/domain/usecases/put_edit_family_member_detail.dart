import '../../../imports.dart';
import '../../data/models/single_family_member_model.dart';

class PutEditFamilyMemberDetail
    extends UseCase<SingleFamilyMemberModel, EditFamilyMemberParams> {
  final Repository repository;
  PutEditFamilyMemberDetail(this.repository);

  @override
  Future<Either<Failure, SingleFamilyMemberModel>> call(
      EditFamilyMemberParams params) async {
    try {
      return repository.putFamilyMemberDetails(editFamilyMemberParams: params);
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

class EditFamilyMemberParams extends Equatable {
  final int? familyId;
  final String? name;
  final String? dob;
  final String? relation;
  final String? photo;
  const EditFamilyMemberParams({
    this.familyId,
    this.name,
    this.dob,
    this.relation,
    this.photo,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
