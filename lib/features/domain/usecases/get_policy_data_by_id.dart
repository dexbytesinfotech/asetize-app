import '../../../imports.dart';
import '../../data/models/get_policy_data_by_id_model.dart';

class GetPolicyDataById
    extends UseCase<GetPolicyDataByIdModel, PolicyDetailParams> {
  final Repository repository;
  GetPolicyDataById(this.repository);

  @override
  Future<Either<Failure, GetPolicyDataByIdModel>> call(params) async {
    try {
      return repository.getPolicyDataById(policyDetailParams: params);
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

class PolicyDetailParams {
  final int? postId;
  const PolicyDetailParams({
    this.postId,
  });
}
