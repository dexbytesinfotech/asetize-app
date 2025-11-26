import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';

class MemberDetails extends StatefulWidget {
  final User? userDetails;
  final Map<String, dynamic>? map;
  const MemberDetails({super.key, this.userDetails, this.map});

  @override
  State<MemberDetails> createState() => _MemberDetailsState();
}

class _MemberDetailsState extends State<MemberDetails> {
  Map<String, dynamic> infoMap = {};
  @override
  void initState() {
    infoMap = widget.userDetails?.additionalInfo?.toMap() ?? {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 38), //50
              Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 60, bottom: 30),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.appWhite),
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15))),
                  child: Column(
                    children: [
                      Text(
                        '${widget.userDetails!.name}',
                        textAlign: TextAlign.center,
                        style: appTextStyle.appTitleStyle(),
                      ),
                      Text(
                        '${widget.userDetails!.email}',
                        textAlign: TextAlign.center,
                        style: appTextStyle.appSubTitleStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text('${widget.userDetails!.jobTitle}',
                          textAlign: TextAlign.center,
                        style: appTextStyle.appSubTitleStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Column(
                            children: buildInfoRows(),
                          ),
                          (widget.userDetails?.managers?.isNotEmpty == true)
                              ? Column(
                                  children: [
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('Manager/Leads',
                                            textAlign: TextAlign.start,
                                            style: appStyles.userNameTextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14)),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey.shade300,
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemCount: widget
                                            .userDetails!.managers!.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8, top: 4),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50), //18
                                                  child: CachedNetworkImage(
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            SizedBox(
                                                      height: 40,
                                                      width: 40,
                                                      child: Image.asset(
                                                        "assets/images/profile_avatar.png",
                                                        height: 40,
                                                        width: 40,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
                                                            const ImageLoader(),
                                                    height: 40,
                                                    width: 40,
                                                    imageUrl: widget
                                                            .userDetails!
                                                            .managers![index]
                                                            .profilePhoto ??
                                                        "",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          widget
                                                                  .userDetails!
                                                                  .managers![
                                                                      index]
                                                                  .name ??
                                                              '',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16)),
                                                      Text(
                                                        widget
                                                                .userDetails!
                                                                .managers![
                                                                    index]
                                                                .jobTitle ??
                                                            '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .6)),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      )
                    ],
                  )),
            ],
          ),
          FutureBuilder<String>(
            future: PrefUtils()
                .readStr(WorkplaceNotificationConst.userProfileImageC),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3))
                      ],
                      border: Border.all(color: Colors.white, width: 4),
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(FadeRoute(
                            widget: FullPhotoView(
                                title: widget.userDetails!.name ?? " ",
                                profileImgUrl:
                                    '${widget.userDetails!.profilePhoto}')));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => const ImageLoader(),
                          height: 100,
                          width: 100,
                          imageUrl: snapshot.data ?? "",
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              "assets/images/profile_avatar.png",
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> buildInfoRows() {
    return widget.map!.keys.map((key) {
      String? value = widget.map![key];
      String formattedKey =
          '${key[0].toUpperCase()}${key.substring(1)}'.replaceAll('_', ' ');
      if (value != null && value.toString().isNotEmpty) {
        return RowTextWidget(
          leftText: formattedKey,
          rightText: value.toString(),
          isShowIcon: formattedKey.toLowerCase() == 'phone'?true:false,
        );
      } else {
        return const SizedBox();
      }
    }).toList();

    // return infoMap.keys.map((key){
    //   String? value = infoMap[key];
    //   String formattedKey =
    //   '${key[0].toUpperCase()}${key.substring(1)}'.replaceAll('_', ' ');
    //   if (value!=null && value.toString().isNotEmpty) {
    //     return RowTextWidget(
    //       leftText: formattedKey,
    //       rightText: value.toString(),
    //     );
    //   }
    //   else {
    //     return const SizedBox();
    //   }
    // }).toList();
  }
}
