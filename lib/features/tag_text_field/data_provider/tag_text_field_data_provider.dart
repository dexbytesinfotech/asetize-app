part of '../bloc/tag_text_field_bloc.dart';

class TagTextFieldDataProvider {
  List<User> searchResults = [];
  List<String> selectedMentionList = [];
  String? content;
  String? mentionValue;

  TagTextFieldDataProvider();

  String getContent() {
    content ??= "";
    return content!;
  }

  List<User> getSearchResults() {
    print("");
    return searchResults;
  }

  String clearTagTextField() {
    searchResults = [];
    selectedMentionList = [];
    mentionValue = null;
    content = "";
    return content!;
  }

  String? editTagTextField(String? enteredValue,
      {bool? onSelectMention = false}) {
    content = enteredValue;

    if (onSelectMention!) {
      String outputString = projectUtil.insertIdInMassageOfTaggedUser(
          inputString: content!.trim(), mentionsUserList: selectedMentionList);
      content = outputString;
    }
    print("edit data $content");

    content ??= "";

    return content;
  }

  List? selectMention(List enteredValue, {bool? onSelect = false}) {
    if (onSelect!) {
      mentionValue = null;
    }
    if (enteredValue.isNotEmpty) {
      if (enteredValue.length == 1) {
        String value = selectedMentionList.toString();
        if (!selectedMentionList.contains(value)) {
          selectedMentionList.add(enteredValue[0]);
        }
      } else {
        selectedMentionList = [];
        selectedMentionList
            .addAll(enteredValue.map((element) => element.toString()).toList());
      }
    } else {
      selectedMentionList = [];
    }
    return selectedMentionList;
  }

  List<User> filterTag(String? searchText, context) {
    mentionValue = searchText;
    searchResults.clear();
    searchResults.addAll(BlocProvider.of<MainAppBloc>(context)
        .mainAppDataProvider!
        .getTeamMemberList()
        .where((element) {
      String value = "{{${element.id}}}";
      if (selectedMentionList.contains(value)) {
        return false;
      } else {
        if (searchText != null && searchText.isNotEmpty && searchText != "@") {
          if ("@${element.name!.toLowerCase()}"
              .contains(searchText.toLowerCase())) {
            return true;
          } else {
            return false;
          }
        }
      }
      return true;
    }));
    return searchResults;
  }
}
