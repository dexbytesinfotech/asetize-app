abstract class PolicyState {
  PolicyState();
}

class PolicyInitialState extends PolicyState {}

class PolicyLoadingState extends PolicyState {}

class GetPolicyDoneState extends PolicyState {}

class GetPolicyByIdDoneState extends PolicyState {}

class PolicyErrorState extends PolicyState {}
