import '../../../imports.dart';
part 'tag_text_field_event.dart';
part 'tag_text_field_state.dart';
part '../data_provider/tag_text_field_data_provider.dart';

class TagTextFieldBloc extends Bloc<TagTextFieldEvent, TagTextFieldState> {
  final TagTextFieldDataProvider tagTextFieldDataProvider;
  TagTextFieldBloc(this.tagTextFieldDataProvider)
      : super(TagTextFieldInitialState()) {
    on<OnEditTagTextFieldEvent>((event, emit) async {
      emit(TagTextFieldEditingState(
          content: tagTextFieldDataProvider.editTagTextField(event.content,
              onSelectMention: event.onSelectMention)));
      emit(
          TagTextFieldEditDoneState(content: tagTextFieldDataProvider.content));
    });

    on<OnSelectTagEvent>((event, emit) async {
      tagTextFieldDataProvider.selectMention(event.tag,
          onSelect: event.onSelect);
    });

    on<OnMentionFilterEvent>((event, emit) async {
      emit(MentionFilterDone(
          filteredTag: tagTextFieldDataProvider.filterTag(
              event.filteredTag, event.context)));
    });

    on<OnClearTagTextFieldEvent>((event, emit) async {
      tagTextFieldDataProvider.clearTagTextField();
      emit(TagTextFieldInitialState());
    });
  }
}
