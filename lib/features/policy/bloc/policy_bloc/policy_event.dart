import '../../../../imports.dart';

abstract class PolicyEvent extends Equatable {
  const PolicyEvent();
  @override
  List<Object> get props => [];
}

class GetPolicyDataEvent extends PolicyEvent {
  final BuildContext mContext;
  const GetPolicyDataEvent({required this.mContext});
}

class GetPolicyDataByIdEvent extends PolicyEvent {
  final int? postId;
  final BuildContext mContext;
  const GetPolicyDataByIdEvent({
    required this.mContext,
    required this.postId,
  });
}
