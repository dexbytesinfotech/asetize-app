import '../../../imports.dart';
import '../../data/models/get_policy_data_model.dart';

class GetPolicyData extends UseCase<PolicyModel, dynamic> {
  final Repository repository;
  GetPolicyData(this.repository);

  @override
  Future<Either<Failure, PolicyModel>> call(params) async {
    try {
      return repository.getPolicyData();
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
