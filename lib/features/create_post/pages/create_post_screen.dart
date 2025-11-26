import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../widgets/create_post_bottom_view.dart';
import '../../tag_text_field/bloc/tag_text_field_bloc.dart';
import '../../tag_text_field/widgets/tag_text_field.dart';
import '../bloc/create_post_bloc.dart';
import '../widgets/choice_chip_wigdet.dart';
import '../../feed/widgets/post_profile.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // ScrollController scrollController = ScrollController();
  bool? isEnable = false;
  late UserProfileBloc userProfileBloc;
  late CreatePostBloc createPostBloc;
  late TagTextFieldBloc tagTextFieldBloc;
  String? oldTextContent = "";

  Map<String, File>? imageFile;
  Map<String, String>? imagePath;
  File? selectProfilePhoto;
  String? selectProfilePhotoPath;
  File? selectThumbPathFile;
  String? selectThumbPath;
  bool isMediaAdded = false;
  @override
  void initState() {
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    createPostBloc = BlocProvider.of<CreatePostBloc>(context);
    tagTextFieldBloc = BlocProvider.of<TagTextFieldBloc>(context);

    if (createPostBloc.createPostDataProvider.currentDraftPostModel != null) {
      oldTextContent = createPostBloc
              .createPostDataProvider.currentDraftPostModel!.content ??
          "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostBloc, CreatePostState>(
        bloc: createPostBloc,
        listener: (context, state) {},
        builder: (context, state) {
          isMediaAdded =
              createPostBloc.createPostDataProvider.currentDraftPostModel ==
                          null ||
                      createPostBloc.createPostDataProvider
                              .currentDraftPostModel!.localMediaFiles ==
                          null
                  ? false
                  : createPostBloc.createPostDataProvider.currentDraftPostModel!
                      .localMediaFiles!.isNotEmpty;
          return Stack(
            children: [
              ContainerFirst(
                contextCurrentView: context,
                isSingleChildScrollViewNeed: false,
                isFixedDeviceHeight: true,
                isListScrollingNeed: true,
                appBackgroundColor: Colors.white,
                appBarHeight: 50,
                appBar: appBar(),
                containChild: InkWell(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15).copyWith(top: 5, bottom: 40),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            PostProfile(
                              imageUrl: userProfileBloc.selectProfilePhoto,
                              padding: const EdgeInsets.only(bottom: 5),
                              height: 28,
                              width: 28,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                '${userProfileBloc.userName}',
                                style:  appTextStyle.appNormalSmallTextStyle(),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Scrollbar(
                        //   controller: scrollController,
                        //   thumbVisibility: true,
                        //   child:
                          TagTextField(
                            tagSuggestionsOnTop: false,
                            initContentValue: oldTextContent,
                            leadingWidget: const [SizedBox(width: 5)],
                            focusOnTextField: false,
                            searchResults: (List<User> list) {},
                            onChange: (content) {
                              createPostBloc.add(OnPostContentEditEvent(
                                  context: context, content: content));
                            },
                            maxLength: 2200,
                            maxLines: 20,
                            minLines: 10,
                            inputFieldDecoration:  InputDecoration(
                                hintText: AppString.shareYourThought,
                                hintStyle: appTextStyle.appNormalTextStyle(color: AppColors.grey,),
                                border: InputBorder.none
                                ),
                          ),
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        photoVideoView(),
                      ],
                    ),
                  ),
                ),
                bottomMenuView: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        // border: Border(top: BorderSide(color: Colors.grey)),
                      ),
                      child: CreatePostBottomView(
                        cropEnable: true,
                        selectedImageCallBack: (fileList) {
                          try {
                            if (fileList != null && fileList.length > 0) {
                              fileList.map((fileDataTemp) {
                                File imageFileTemp = File(fileDataTemp.path);
                                File imageFileTemp2 = File(fileDataTemp.path);
                                selectProfilePhoto = imageFileTemp;
                                selectProfilePhotoPath =
                                    selectProfilePhoto!.path;
                                selectThumbPathFile = imageFileTemp2;
                                selectThumbPath = selectThumbPathFile!.path;

                                if (imageFile == null) {
                                  imageFile = Map();
                                } else {
                                  imageFile!.clear();
                                }
                                if (imagePath == null) {
                                  imagePath = Map();
                                } else {
                                  imagePath!.clear();
                                }
                                String mapKey = DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString();
                                imageFile![mapKey] =
                                    imageFileTemp; // = imageFileTemp;
                                imagePath![mapKey] = imageFileTemp.path;
                                createPostBloc.add(OnPostContentEditEvent(
                                    context: context,
                                    addMediaFiles: selectThumbPath!));
                              }).toList(growable: false);
                            }
                          } catch (e) {
                            print(e);
                          }
                          // Navigator.pop(context);
                        },

                        selectedVideoCallBack: (fileList) {
                          try {
                            if (fileList != null && fileList.path!.isNotEmpty) {
                              File imageFileTemp = File(fileList.path!);
                              selectProfilePhoto = imageFileTemp;
                              selectProfilePhotoPath = selectProfilePhoto!.path;
                              if (imageFile == null) {
                                imageFile = {};
                              } else {
                                imageFile!.clear();
                              }
                              if (imagePath == null) {
                                imagePath = {};
                              } else {
                                imagePath!.clear();
                              }
                              String mapKey = DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString();
                              imageFile![mapKey] =
                                  imageFileTemp; // = imageFileTemp;
                              imagePath![mapKey] = imageFileTemp.path;
                              createPostBloc.add(OnPostContentEditEvent(
                                  context: context,
                                  addMediaFiles: selectProfilePhotoPath!));
                            }
                          } catch (e) {
                            print(e);
                          }
                        },

                        selectedCameraImageCallBack: (fileList) {
                          try {
                            if (fileList != null && fileList.path!.isNotEmpty) {
                              File imageFileTemp = File(fileList.path!);
                              selectProfilePhoto = imageFileTemp;
                              selectProfilePhotoPath = selectProfilePhoto!.path;
                              if (imageFile == null) {
                                imageFile = {};
                              } else {
                                imageFile!.clear();
                              }
                              if (imagePath == null) {
                                imagePath = {};
                              } else {
                                imagePath!.clear();
                              }
                              String mapKey = DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString();
                              imageFile![mapKey] =
                                  imageFileTemp; // = imageFileTemp;
                              imagePath![mapKey] = imageFileTemp.path;
                              createPostBloc.add(OnPostContentEditEvent(
                                  context: context,
                                  addMediaFiles: selectProfilePhotoPath!));
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (state is CreatePostLoadingState)
                WorkplaceWidgets.progressLoader(context),
            ],
          );
        });
  }

  Widget appBar() {
    return Container(
      padding: const EdgeInsets.only(left: 4, right: 10),
      decoration: BoxDecoration(
          color:Colors.white,
          border: Border(
              bottom: BorderSide(
                width:  0.3,
                color:  Colors.grey.shade300,

              ))),
      child: Row(
        children: [
          Row(
            children: [
             IconButton(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Colors.black,
                  )),
              const SizedBox(
                width: 12,
              ),
               Text(AppString.createPost,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: appTextStyle.appBarTitleStyle(),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 12, bottom: 2),
            child: BlocBuilder<TagTextFieldBloc, TagTextFieldState>(
                builder: (_, state) {
                  String content = tagTextFieldBloc.tagTextFieldDataProvider.getContent().trim();
                  return InkWell(
                    onTap: content.trim().isNotEmpty // || isMediaAdded
                        ? () {
                      // if (controller.text.isNotEmpty || createPostBloc.docImageList.isNotEmpty)
                      createPostBloc.add(OnPostCreationEvent(context: context));
                      Navigator.pop(context);
                    }
                        : null,
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          color: content.trim().isNotEmpty // || isMediaAdded
                              ? AppColors.appBlueColor
                              : Colors.grey.shade200,
                          border: Border.all(
                              color: content.trim().isNotEmpty // || isMediaAdded
                                  ? AppColors.appBlueColor
                                  : AppColors.grey,
                              width: 0.1),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(AppString.post,
                          style:  appTextStyle.appNormalTextStyle(
                              color: content.trim().isNotEmpty // || isMediaAdded
                                  ? AppColors.white
                                  : AppColors.grey,
                              )),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget photoVideoView() {
    return BlocListener(
      bloc: createPostBloc,
      listener: (BuildContext context, state) {
        // if (state is CreatePostErrorState) {
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       content: Text( '${state.errorMessage}'),
        //       backgroundColor: Colors.black));
        // }
      },
      child: BlocBuilder<CreatePostBloc, CreatePostState>(
          builder: (context, state) {
        if (createPostBloc.createPostDataProvider.currentDraftPostModel ==
                null ||
            createPostBloc.createPostDataProvider.currentDraftPostModel!
                    .localMediaFiles ==
                null ||
            createPostBloc.createPostDataProvider.currentDraftPostModel!
                .localMediaFiles!.isEmpty) {
          return Container();
        }
        List<String> mediaFile = createPostBloc
            .createPostDataProvider.currentDraftPostModel!.localMediaFiles!
            .map((value) => value.mediaFilePath!)
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChoiceChipWidget(
                isShowCrossButton: true,
                selectedColor: Colors.transparent,
                backgroundColor: Colors.white,
                dataList: mediaFile,
                tagClickCallBack: (item) {
                  createPostBloc.add(OnPostContentEditEvent(
                      addMediaFiles: item, context: context));
                },
                onClickDelete: (item) {
                  createPostBloc.add(OnPostContentEditEvent(
                      removeMediaFiles: item, context: context));
                }),
            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }
}
