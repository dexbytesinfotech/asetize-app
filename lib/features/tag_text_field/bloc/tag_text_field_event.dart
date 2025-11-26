part of 'tag_text_field_bloc.dart';

abstract class TagTextFieldEvent extends Equatable {
  const TagTextFieldEvent();
  @override
  List<Object> get props => [];
}

class OnEditTagTextFieldEvent extends TagTextFieldEvent {
  final BuildContext context;
  final String? content;
  final bool onSelectMention;
  const OnEditTagTextFieldEvent(
      {required this.context,
      required this.content,
      this.onSelectMention = false});
}

class OnSelectTagEvent extends TagTextFieldEvent {
  final BuildContext context;
  final List<String> tag;
  final bool? onSelect;
  const OnSelectTagEvent(
      {required this.context, required this.tag, this.onSelect = false});
}

class OnMentionFilterEvent extends TagTextFieldEvent {
  final BuildContext context;
  final String? filteredTag;
  const OnMentionFilterEvent(
      {required this.context, required this.filteredTag});
}

class OnClearTagTextFieldEvent extends TagTextFieldEvent {
  final BuildContext context;
  const OnClearTagTextFieldEvent({required this.context});
}
