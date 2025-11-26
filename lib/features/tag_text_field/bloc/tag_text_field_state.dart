part of 'tag_text_field_bloc.dart';

abstract class TagTextFieldState {
  TagTextFieldState();
  List<Object> get props => [];
}

class TagTextFieldInitialState extends TagTextFieldState {}

class TagTextFieldLoadingState extends TagTextFieldState {
  final TagTextFieldEvent? loadingForEvent;
  TagTextFieldLoadingState({this.loadingForEvent});
}

class TagTextFieldErrorState extends TagTextFieldState {
  String? errorMessage;
  final TagTextFieldEvent? loadingForEvent;
  TagTextFieldErrorState({this.errorMessage, this.loadingForEvent});
}

class TagTextFieldEditingState extends TagTextFieldState {
  final String? content;
  TagTextFieldEditingState({this.content});
}

class TagTextFieldEditDoneState extends TagTextFieldState {
  final String? content;
  TagTextFieldEditDoneState({this.content});
}

class TagSelectedDoneState extends TagTextFieldState {
  final Map<String, dynamic>? tag;
  TagSelectedDoneState({this.tag});
}

class MentionFilterDone extends TagTextFieldState {
  final List<User> filteredTag;
  MentionFilterDone({required this.filteredTag});
}
