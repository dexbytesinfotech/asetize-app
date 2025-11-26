
import 'package:asetize/features/policy/bloc/policy_bloc/policy_event.dart';
import 'package:asetize/features/policy/bloc/policy_bloc/policy_state.dart';
import 'package:asetize/imports.dart';
import '../../../../core/util/app_navigator/app_navigator.dart';
import '../../../data/models/get_policy_data_by_id_model.dart';
import '../../../data/models/get_policy_data_model.dart';
import '../../../domain/usecases/get_policy_data.dart';
import '../../../domain/usecases/get_policy_data_by_id.dart';

class PolicyBloc extends Bloc<PolicyEvent, PolicyState> {
  GetPolicyData getPolicyData =
      GetPolicyData(RepositoryImpl(WorkplaceDataSourcesImpl()));
  GetPolicyDataById getPolicyDataById =
      GetPolicyDataById(RepositoryImpl(WorkplaceDataSourcesImpl()));
  List<PolicyData> policyData = [];
  PolicyData? policyDataById;

  PolicyBloc() : super(PolicyInitialState()) {
    on<GetPolicyDataEvent>((event, emit) async {
      emit(PolicyLoadingState());
      Either<Failure, PolicyModel> response = await getPolicyData.call('');
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext);
        } else {
          emit(PolicyErrorState());
        }
      }, (right) {
        policyData = right.data ?? [];
        emit(GetPolicyDoneState());
      });
    });

    on<GetPolicyDataByIdEvent>((event, emit) async {
      emit(PolicyLoadingState());

      Either<Failure, GetPolicyDataByIdModel> response = await getPolicyDataById
          .call(PolicyDetailParams(postId: event.postId));
      response.fold((left) {
        if (left is UnauthorizedFailure) {
          appNavigator.tokenExpireUserLogout(event.mContext);
        } else {
          emit(PolicyErrorState());
        }
      }, (right) {
        policyDataById = right.data;
        emit(GetPolicyByIdDoneState());
      });
    });
  }
}
