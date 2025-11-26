import '../../../imports.dart';
import '../../my_post/models/get_feed_data_model.dart';
import '../widgets/post_header.dart';

class PostLikeScreen extends StatefulWidget {
  final List<Likes>? likes;
  const PostLikeScreen({super.key, required this.likes});

  @override
  State<PostLikeScreen> createState() => _PostLikeScreenState();
}

class _PostLikeScreenState extends State<PostLikeScreen> {
  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: false,
        isFixedDeviceHeight: true,
        isListScrollingNeed: true,
        appBarHeight: 50,
        appBar: const DetailsScreenAppBar(
          isHideIcon: false,
          title: AppString.likes,
        ),
        appBackgroundColor: Colors.white,
        containChild: (widget.likes!.isEmpty)
            ? Center(
                child: Text(
                  AppString.noLikes,
                  style: appStyles.noDataTextStyle(),
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: widget.likes!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      children: [
                        PostHeader(
                          profilePhoto: widget.likes![index].user!.profilePhoto,
                          postBy: widget.likes![index].user!.name,
                          postPublishedAt: widget.likes![index].createdAt,
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Divider(
                      height: 2,
                    ),
                  );
                },
              ));
  }
}
