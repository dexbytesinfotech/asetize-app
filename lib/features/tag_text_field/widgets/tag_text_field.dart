import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:mention_tag_text_field/mention_tag_text_field.dart';
import '../../../imports.dart';
import '../../feed/widgets/post_profile.dart';
import '../bloc/tag_text_field_bloc.dart';

class TagTextField extends StatefulWidget {
  final InputDecoration? inputFieldDecoration;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool? focusOnTextField;
  final String? initContentValue;
  final String? btName;
  final bool isSendButtonTrue; // You can set this based on your logic
  final List<Widget>? leadingWidget;
  final List<Widget>? actionWidget;
  final bool? tagSuggestionsOnTop;
  final Function(String)? onPostClick;
  final Function(String?)? onChange;
  final Function(List<User>) searchResults; // data add when API call
  const TagTextField(
      {super.key,
        this.minLines,
        this.maxLines,
        this.maxLength,
        this.inputFieldDecoration,
        this.focusOnTextField,
        required this.searchResults,
        this.leadingWidget,
        this.isSendButtonTrue = false,
        this.actionWidget,
        this.onPostClick,
        this.onChange,
        this.btName,
        this.initContentValue,
        this.tagSuggestionsOnTop = true});

  @override
  State<TagTextField> createState() => _TagTextFieldState();
}

class _TagTextFieldState extends State<TagTextField> {
  FocusNode fComment = FocusNode();
  final MentionTagTextEditingController _controller =
  MentionTagTextEditingController();

  late TagTextFieldBloc tagTextFieldBloc;
  Decoration? decoration;
  OverlayEntry? overlayEntry;
  int cursorPosition = 0 ;
  int numberOfLines = 0 ;
  @override
  void initState() {
    tagTextFieldBloc = BlocProvider.of<TagTextFieldBloc>(context);

    try {
      if (widget.initContentValue != null) {
        _controller.text = widget.initContentValue!;
      }
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tagTextFieldBloc.add(OnClearTagTextFieldEvent(context: context));
    super.dispose();
  }

  int getCurrentLineNumber() {
    // Check if the cursor position is valid
    if (_controller.selection.base.offset < 0) {
      return 1; // Return 1 if there's no valid cursor position, assuming the first line
    }
    String textUpToCursor = _controller.text.substring(0, _controller.selection.base.offset);
    return '\n'.allMatches(textUpToCursor).length + 1;
  }

  @override
  Widget build(BuildContext context)
  {
    numberOfLines = getCurrentLineNumber();

    if (decoration == null) {
      double borderRadius = 8.0;
      double borderSideWidth = 0.5;
      decoration = BoxDecoration(
        color: AppColors.white,
        border: widget.tagSuggestionsOnTop!
            ? Border(
          top: BorderSide(
            color: Colors.grey,
            width: borderSideWidth, // Top border
          ),
          right: BorderSide(
            color: Colors.grey,
            width: borderSideWidth, // Top border
          ),
          left: BorderSide(
            color: Colors.grey,
            width: borderSideWidth, // Top border
          ),
        )
            : Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: borderSideWidth, // Top border
          ),
          right: BorderSide(
            color: Colors.grey,
            width: borderSideWidth, // Top border
          ),
          left: BorderSide(
            color: Colors.grey,
            width: borderSideWidth, // Top border
          ),
        ),
        borderRadius: widget.tagSuggestionsOnTop!
            ? BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        )
            : BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );
    }

    return BlocConsumer<TagTextFieldBloc, TagTextFieldState>(
      bloc: tagTextFieldBloc,
      listener: (context, state) {
        if (state is TagTextFieldEditingState) {
          widget.onChange
              ?.call(tagTextFieldBloc.tagTextFieldDataProvider.content);
        }
      },
      builder: (context, state) {
        if (widget.tagSuggestionsOnTop!) {
          return Column(
            children: [suggestions(), otherView()],
          );
        } else {
          return Stack(
            children: [otherView(), Padding(
              padding:EdgeInsets.only(top: numberOfLines*30),
              child: suggestions(),
            )],
          );
        }
      },
    );
  }

  Widget otherView() {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.leadingWidget != null && widget.leadingWidget!.isNotEmpty)
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: widget.leadingWidget!),
          Flexible(child: mentionTagTextField()),
          if (widget.onPostClick != null)
            Padding(
              padding: const EdgeInsets.only(top: 11, right: 20),
              child: Material(
                color: Colors.transparent, // To prevent default Material color
                borderRadius: BorderRadius.circular(5), // Square border with rounded corners
                child: InkWell(
                  onTap: () {
                    if (_controller.text.trim().isNotEmpty) {
                      FocusScope.of(context).unfocus();
                      widget.onPostClick?.call(
                          tagTextFieldBloc.tagTextFieldDataProvider.content!);
                      _controller.clear();
                      tagTextFieldBloc
                          .add(OnClearTagTextFieldEvent(context: context));
                    }
                  },
                  borderRadius: BorderRadius.circular(5), // Apply to InkWell as well
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _controller.text.trim().isNotEmpty
                          ? AppColors.textBlueColor // Blue color when text is not empty
                          : Colors.grey, // Grey when text is empty
                      borderRadius: BorderRadius.circular(5), // Square border with rounded corners
                    ),
                    child: (widget.isSendButtonTrue)
                        ? Icon(
                      Icons.send,
                      color: Colors.white, // White icon color to match text
                      size: 22, // Adjust icon size as needed
                    )
                        : Text(
                      widget.btName ?? "Post", // Fallback to "Post" if btName is null
                      style: appStyles.userNameTextStyle(
                        fontSize: 14,
                        texColor: Colors.white,// Corrected potential typo from 'texColor'
                      ),
                    ),



                    // Text(
                    //   widget.btName ?? "Post",
                    //   style: appStyles.userNameTextStyle(
                    //     fontSize: 14,
                    //     texColor: Colors.white, // White text color
                    //   ),
                    // ),
                  ),
                ),
              ),
            )

        ],
      ),
    );
  }

  Widget mentionTagTextField() {
    return Column(
      children: [
        MentionTagTextField(
          maxLength: widget.maxLength,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          minLines: widget.minLines, //Normal textInputField will be displayed
          maxLines:
          widget.maxLines, // when user presses enter it will adapt to it
          controller: _controller,
          onMention: onMention,
          autofocus: widget.focusOnTextField ?? false,
          focusNode: fComment,
          textAlign: TextAlign.start,
          onChanged: (String value) {
            // Store the current cursor position
            cursorPosition = _controller.selection.base.offset;

            _controller.text = value;

            List<String>? mentionsUserList = _controller.mentions.isNotEmpty
                ? _controller.mentions
                .map((element) => element.toString())
                .toList()
                : [];
            tagTextFieldBloc
                .add(OnSelectTagEvent(context: context, tag: mentionsUserList));

            tagTextFieldBloc.add(OnEditTagTextFieldEvent(
                context: context,
                content: _controller.text,
                onSelectMention: mentionsUserList.isNotEmpty ? true : false));
            // Restore the cursor position
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: cursorPosition),
            );
            numberOfLines = getCurrentLineNumber();

          },
          onEditingComplete: () {},
          cursorColor: Colors.black,
          style: const TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
          mentionTagDecoration: MentionTagDecoration(
              mentionStart: ['@'],
              mentionBreak: ' ',
              allowDecrement: false,
              allowEmbedding: false,
              showMentionStartSymbol: true,
              maxWords: null,
              mentionTextStyle: TextStyle(
                  color: Colors.blue, backgroundColor: Colors.blue.shade50)),
          decoration: widget.inputFieldDecoration ??
              InputDecoration(
                hintText: 'Write your comment',
                hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,

                contentPadding:
                const EdgeInsets.symmetric(horizontal: 2.0, vertical: 16.0),
              ),
        )
      ],
    );
  }

  Widget suggestions() {
    if (tagTextFieldBloc.tagTextFieldDataProvider.mentionValue == null) {
      return const SizedBox();
    }

    return SizedBox(
        height: MediaQuery.of(context).size.height / 3.5,
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: 0, right: 2, left: 2), // Add margin to top and bottom
          child: Container(
            padding: const EdgeInsets.all(3),
            margin: const EdgeInsets.all(2),
            decoration: decoration,
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 18, right: 20),
                    child: Divider(
                      thickness: 0.5,
                      height: 0,
                    ),
                  );
                },
                //List of all user with their profile photo
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: tagTextFieldBloc.tagTextFieldDataProvider
                    .getSearchResults()
                    .length,
                padding: const EdgeInsets.only(top: 0, bottom: 10),
                itemBuilder: (context, index) {
                  return Container(
                      color: AppColors.white,
                      child: GestureDetector(
                          onTap: () {
                            addMention(index);
                          },
                          child: Container(
                            color:Colors.transparent,
                            padding: const EdgeInsets.only(left: 15,right: 15,top:8,bottom:8),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const ImageLoader(),
                                    errorWidget: (context, url, error) => Container(
                                      height: 30,
                                      width: 30,
                                      color: Colors.grey,
                                    ),
                                    imageUrl: tagTextFieldBloc.tagTextFieldDataProvider .searchResults[index].profilePhoto!,
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Text("${tagTextFieldBloc.tagTextFieldDataProvider.searchResults[index].name}",style: const TextStyle(
                                    fontSize: 14,color: AppColors.black
                                )),
                              ],
                            ),
                          )
                        /*ListTile(
                          leading:  ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => const ImageLoader(),
                              errorWidget: (context, url, error) => Container(
                                height: 30,
                                width: 30,
                               color: Colors.grey,
                              ),
                              imageUrl: tagTextFieldBloc.tagTextFieldDataProvider .searchResults[index].profilePhoto!,
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // CircleAvatar(
                          //   backgroundImage: NetworkImage(tagTextFieldBloc.tagTextFieldDataProvider .searchResults[index].profilePhoto!),
                          // ),
                          title: Text("${tagTextFieldBloc.tagTextFieldDataProvider.searchResults[index].name}",style: const TextStyle(
                              fontSize: 14,color: AppColors.black
                          )),
                          // subtitle: Text(
                          //   "@${tagTextFieldBloc.tagTextFieldDataProvider.searchResults[index].name}",
                          //   style: TextStyle(
                          //       color: Colors.grey.shade400, fontSize: 12),
                          // ),
                        ),*/
                      ));
                }),
          ),
        ));
  }

  Future<void> onMention(String? value) async {
    tagTextFieldBloc
        .add(OnMentionFilterEvent(context: context, filteredTag: value));
  }

  void addMention(index) {
    Set<Set<int?>> selectedTag = {
      {tagTextFieldBloc.tagTextFieldDataProvider.getSearchResults()[index].id}
    };
    tagTextFieldBloc.add(OnSelectTagEvent(
        context: context, tag: [selectedTag.toString()], onSelect: true));

    _controller.addMention(
      label:
      "${tagTextFieldBloc.tagTextFieldDataProvider.getSearchResults()[index].name}",
      data: selectedTag,
    );

    //This line always must be after addMention
    tagTextFieldBloc.add(OnEditTagTextFieldEvent(
        context: context, content: _controller.text, onSelectMention: true));
  }



}