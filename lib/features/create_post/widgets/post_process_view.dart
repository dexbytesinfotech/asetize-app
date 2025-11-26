import '../../../imports.dart';
import '../bloc/create_post_bloc.dart';
import '../models/create_post_model.dart';

class PostProcessView extends StatefulWidget {
  const PostProcessView({super.key});

  @override
  State<PostProcessView> createState() => _PostProcessViewState();
}
class _PostProcessViewState extends State<PostProcessView> {
  late CreatePostBloc createPostBloc;

  @override
  void initState() {
    createPostBloc = BlocProvider.of<CreatePostBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicatorView() => Container(
        margin: const EdgeInsets.only(top: 1),
        child: WorkplaceWidgets.linearProgressIndicatorLoader(context));

    return BlocConsumer<CreatePostBloc, CreatePostState>(
        bloc: createPostBloc,
        listener: (context, state) {
          if (state is CreatePostDoneState) {
            BlocProvider.of<FeedBloc>(context).add(
                UpdateFeedDataEvent(updatedFeedData: state.updatedFeedData));
            if (mounted) {

              WorkplaceWidgets.successToast(AppString.postCreateSuccessfully,durationInSeconds: 1);
            }
            if (createPostBloc.createPostDataProvider.getPostListToCreate().isNotEmpty) {
              createPostBloc.add(OnPostCreationEvent(context: context));
            }
          }
        },
        builder: (context, state) {
          if (createPostBloc.createPostDataProvider.getPostListToCreate().isEmpty) {
            return const SizedBox();
          }
          return Column(
            children: [
              Divider(
                color: Colors.grey.withOpacity(0.4),
                height: 0.2,
                thickness: 0.2,
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 5, top: 5),
                margin: const EdgeInsets.only(top: 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // border: Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Column(children: [
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(AppString.pleaseWaitMoment
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  // border: Border(top: BorderSide(color: Colors.grey)),
                                ),
                                child: Row(
                                  children: [
                                    progressIndicator(createPostBloc
                                        .createPostDataProvider
                                        .getPostListToCreate()[index]
                                        .localMediaFiles)
                                  ],
                                )),
                          ],
                        );
                      }),
                  if (state is CreatePostLoadingState ||
                      state is PostMediaLoadingState)
                    loadingIndicatorView()
                ]),
              )
            ],
          );
        });
  }

  Widget progressIndicator(List<LocalMediaFile>? mediaFilePath) {
    if (mediaFilePath == null || mediaFilePath.isEmpty) {
      return const SizedBox();
    }
    Color bgColor = Colors.grey;
    double heightOfParts = 1;

    Widget donePartView(String? state, bool isLast) {
      Color selectedColor = Colors.grey;
      switch (state) {
        case "uploaded":
          selectedColor = Colors.green;
          break;
        case "pending":
          selectedColor = Colors.orange;
          break;
        default:
          selectedColor = Colors.grey;
          break;
      }
      return Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                  child:
                      Container(height: heightOfParts, color: selectedColor)),
              Container(
                  height: heightOfParts,
                  width: isLast ? 0 : 1,
                  color: Colors.red)
            ],
          ));
    }

    Widget mediaFileUploadView() {
      if (mediaFilePath.isEmpty) {
        return const SizedBox();
      }
      return Container(
          height: heightOfParts,
          width: double.infinity,
          color: bgColor,
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: mediaFilePath
                  .asMap()
                  .map((index, value) {
                    bool isLast = index == mediaFilePath.length - 1;
                    return MapEntry(index, donePartView(value.status, isLast));
                  })
                  .values
                  .toList()
                  .toList()));
    }

    return Expanded(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [mediaFileUploadView()],
    ));
  }
}
