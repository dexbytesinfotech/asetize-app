import 'package:cached_network_image/cached_network_image.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:asetize/core/util/app_navigator/app_navigator.dart';
import 'package:asetize/imports.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import '../../member/bloc/team_member/team_member_bloc.dart';
import '../../presentation/pages/logout_bottom_sheet.dart';
import '../../presentation/widgets/member_details.dart';
import 'my_house.dart';

class UserProfileScreen extends StatefulWidget {
  final String userName;
  final String email;
  final String image;

  const UserProfileScreen({
    Key? key,
    this.userName = "Dino Waelchi",
    this.email = "Dino_waelchi@gmail.com",
    this.image =
        "https://instant-bollywood-1.s3.ap-south-1.amazonaws.com/wp-content/uploads/2021/08/14115151/aditya-kapoor.jpg",
  }) : super(key: key);

  @override
  State createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  Map<String, File>? imageFile;
  Map<String, String>? imagePath;
  File? selectProfilePhoto;
  String? selectProfilePhotoPath;
  String email = "";
  late UserProfileBloc bloc;
  late TeamMemberBloc teamBloc;
  MainAppBloc? mainAppBloc;
  late MainAppStateModel mainAppModel;
  UserResponseModel userResponseModel = UserResponseModel();
  String getImages = '';
  _UserProfileScreenState() {
    if (mainAppBloc != null) {
      mainAppModel = mainAppBloc!.state.getMainAppStateModel;
    }
  }

  Future<String> getImage() async {
    await PrefUtils()
        .readStr(WorkplaceNotificationConst.userProfileImageC)
        .then((value) => getImages = value);
    return getImages;
  }

  String userFullName = '';
  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';
  @override
  void initState() {
    bloc = BlocProvider.of<UserProfileBloc>(context);
    teamBloc = BlocProvider.of<TeamMemberBloc>(context);
    mainAppBloc = BlocProvider.of<MainAppBloc>(context);
    userFullName = bloc.user.name ?? '';
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
     setState(() {
       appName = packageInfo.appName;
       packageName = packageInfo.packageName;
       version = packageInfo.version;
       buildNumber = packageInfo.buildNumber;
     });
    });
  }

  @override
  Widget build(BuildContext context) {
    final contactNumberWithCountryCode = projectUtil.formatPhoneNumberWithCountryCode(
      countryCode:bloc.user.countryCode!, // or from dynamic user input or data
      phoneNumber: bloc.user.phone!,
        withCountryCode:false
    );
    void photoPickerBottomSheet() {
      showModalBottomSheet(
          context: MainAppBloc.getDashboardContext,
          builder: (context1) => PhotoPickerBottomSheet(
               cropEnable:true,
                isRemoveOptionNeeded: false,
                removedImageCallBack: () {
                  Navigator.pop(context1);
                  setState(() {
                    selectProfilePhotoPath = "";
                  });
                },
                selectedImageCallBack: (fileList) {
                  try {
                    if (fileList != null && fileList.length > 0) {
                      fileList.map((fileDataTemp) {
                        File imageFileTemp = File(fileDataTemp.path);
                        selectProfilePhoto = imageFileTemp;
                        selectProfilePhotoPath = selectProfilePhoto!.path;
                        if (imageFile == null) {
                          imageFile = <String, File>{};
                        } else {
                          imageFile!.clear();
                        }
                        if (imagePath == null) {
                          imagePath = <String, String>{};
                        } else {
                          imagePath!.clear();
                        }
                        String mapKey =
                            DateTime.now().microsecondsSinceEpoch.toString();
                        imageFile![mapKey] = imageFileTemp; // = imageFileTemp;
                        imagePath![mapKey] = imageFileTemp.path;
                      }).toList(growable: false);
                      setState(() {});
                      BlocProvider.of<UserProfileBloc>(context).add(
                          UploadMediaEvent(
                              imagePath: imagePath!.values.first,
                              mContext: context));
                    }
                  } catch (e) {
                    debugPrint('$e');
                  }
                  Navigator.pop(context1);
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
                      String mapKey =
                          DateTime.now().microsecondsSinceEpoch.toString();
                      imageFile![mapKey] = imageFileTemp; // = imageFileTemp;
                      imagePath![mapKey] = imageFileTemp.path;
                      setState(() {});
                      BlocProvider.of<UserProfileBloc>(context).add(
                          UploadMediaEvent(
                              imagePath: imagePath!.values.first,
                              mContext: context));
                    }
                  } catch (e) {
                    debugPrint('$e');
                  }
                  Navigator.pop(context1);
                },
              ),
          isScrollControlled: false,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(photoPickerBottomSheetCardRadius))));
    }

    Widget profileImage() => Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 19)
          .copyWith(top: 16, bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
            BlocListener(
              bloc: bloc,
              listener: (context,state){

              if (state is StoreMediaState) {
                bloc.add(FetchProfileDetails(mContext: context));
                teamBloc.add(FetchTeamList(mContext: context));
              }
           /*   if(state is UserProfileFetched)
                {
                  PrefUtils()
                      .readStr(
                      WorkplaceNotificationConst.userProfileImageC)
                      .then((value) {
                    selectProfilePhotoPath = value;
                  });
                }*/
              },
            child:   BlocBuilder<UserProfileBloc, UserProfileState>(
              bloc: bloc,
              builder: (context, state) {
                if (state is StoreMediaState) {
                  // imageSelected=true;
  /*                PrefUtils()
                      .readStr(
                      WorkplaceNotificationConst.userProfileImageC)
                      .then((value) {
                    selectProfilePhotoPath = value;
                  });
                  bloc.add(FetchProfileDetails(mContext: context));*/
                }
                return InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => FullPhotoView(
                    //         title: bloc.user.name,
                    //         profileImgUrl:
                    //             '${bloc.selectProfilePhoto}')));
                  },
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.textBlueColor.withOpacity(0.5),
                    ),
                    child: CircularImage(
                      height: 85,
                      width: 85,
                      image: selectProfilePhotoPath ?? bloc.selectProfilePhoto,
                      name: bloc.user.name,
                      isClickToFullView: true,
                    ),
                  ),
                );
              },
            ),),
              InkWell(
                onTap: () {
                  photoPickerBottomSheet();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 1, left: 55),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      shape: BoxShape.circle,
                      color: AppColors.textBlueColor.withOpacity(0.9)),
                  child: WorkplaceIcons.iconImage(
                    iconSize: const Size(20, 20),
                    imageColor: Colors.white,
                    imageUrl: WorkplaceIcons.editIcon,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 15),
          Flexible(
            child: InkWell(
              onTap: () {
                // showSlidingBottomSheet(MainAppBloc.getDashboardContext,
                //     builder: (context) {
                //       return SlidingSheetDialog(
                //         elevation: 0,
                //         color: Colors.transparent,
                //         cornerRadius: 16,
                //         duration: const Duration(milliseconds: 400),
                //         snapSpec: const SnapSpec(
                //           snap: true,
                //           // snappings: [0.5, 0.9],
                //           positioning: SnapPositioning.relativeToAvailableSpace,
                //         ),
                //         builder: (context, state) {
                //           return MemberDetails(
                //             map: WorkplaceDataSourcesImpl.profileAdditionalInfo,
                //             userDetails: bloc.user,
                //           );
                //         },
                //       );
                //     });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 11.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bloc.user.name ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: appStyles.userNameTextStyle(fontSize: 20)),
                    if(bloc.user.email?.isNotEmpty == true)
                      Text(bloc.user.email ?? "",
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                          style: appStyles.userJobTitleTextStyle(
                              fontSize: 14,
                              texColor: const Color(0xFF757575))
                      ),
                    if(bloc.user.phone?.isNotEmpty == true)

                      Text(contactNumberWithCountryCode?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: appStyles.userJobTitleTextStyle(
                            fontSize: 14,
                            texColor: const Color(0xFF757575))
                      ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );

    return BlocConsumer<UserProfileBloc, UserProfileState>(
      bloc: bloc,
      listener: (BuildContext context, UserProfileState state) {
        if(state is StoreMediaState)
          {

          }
      },
      builder: (context, state) {
        if (state is UploadMediaState) {
          bloc.add(FetchProfileDetails(mContext: context));
          return Container();
        }
        if (state is UserProfileInitial) {
          bloc.add(FetchProfileDetails(mContext: context));
          return Container();
        }

        return Stack(
          children: [
            PopScope(
                onPopInvoked: null, //_onBackPressed,
                child: ContainerFirst(
                    contextCurrentView: context,
                    isSingleChildScrollViewNeed: true,
                    isFixedDeviceHeight: false,
                    isListScrollingNeed: false,
                    appBackgroundColor: const Color(0xFFf9fafb),
                    appBarHeight: -1,
                    appBar: Container(),
                    containChild: Container(
                      //color: Colors.grey.shade50,
                      color: const Color(0xFFf9fafb),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          profileImage(),
                          // Container(
                          //   padding: const EdgeInsets.symmetric(vertical: 12),
                          //   margin: const EdgeInsets.only(top: 15),
                          //   color: Colors.white,
                          //   child: Column(
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.only(left: 18,right: 18),
                          //         child: ListView.builder(
                          //           padding: EdgeInsets.zero,
                          //           shrinkWrap: true,
                          //             physics: const NeverScrollableScrollPhysics(),
                          //             itemCount : bloc.user.companies?.length,
                          //             itemBuilder: (context,index){
                          //           return Row(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               ClipRRect(
                          //                 borderRadius: BorderRadius.circular(50),
                          //                 child: CachedNetworkImage(
                          //                   placeholder: (context, url) => const ImageLoader(),
                          //                   errorWidget: (context, url, error) => const Icon(Icons.apartment, size: 25, color: AppColors.appBlueColor),
                          //                   imageUrl: '${bloc.user.companies?[index].logo}',
                          //                   height: 30,
                          //                   width: 30,
                          //                   fit: BoxFit.cover,
                          //                 ),
                          //               ),
                          //               const SizedBox(width: 12),
                          //               Expanded(
                          //                 child: Text('${bloc.user.companies?[index].name}',
                          //                   style: const TextStyle(color: Colors.black),),
                          //
                          //               ),
                          //               Text('${bloc.user.companies?[index].status}',
                          //                 style: const TextStyle(color: Colors.black),),
                          //             ],
                          //           );
                          //         }),
                          //       ),
                          //
                          //     ],
                          //   ),
                          // ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            color: Colors.transparent,
                            child: ProfileListRowWidget(
                                onClickListCallBack: (title) {
                                  redirectTo(title, context);
                                },
                                appVersion: version),
                          ),
                        ],
                      ),
                    ))),
            if (state is UserProfileLoading)
              WorkplaceWidgets.progressLoader(context),
          ],
        );
      },
    );
  }

  void redirectTo(title, context) {
    if (title == 'My Post') {
      appNavigator.launchMyPostPageProfile(context);
    }else  if (title == 'My Houses') {
      appNavigator.launchMyHousePageProfile(context);
    }
    else if (title == 'My Spotlight') {
      appNavigator.launchMySpotlightPage(context);
    }
    else if (title == "Announcement") {
      appNavigator.launchAnnouncementPageProfile(context);
    }  else if (title.toString().trim() == "Update Profile") {
      appNavigator.launchEditProfilePage(context);
    } else if (title == "Settings") {
      appNavigator.launchSettingsPageProfile(context);
    } else if (title == "Policy") {
      appNavigator.launchPolicyPageProfile(context);
    } else if (title == "FAQ") {
      appNavigator.launchFaqPageProfile(context);
    }else if (title == "Vehicle Form") {
      appNavigator.MatrimonyScreen(context);
    }else if (title == "My Vehicle") {
      appNavigator.VehicleDetaish(context);
    }
    else if (title == "Search Vehicle") {
      appNavigator.SearchVehicle(context);
    }
    // else if (title == "Vehicle_Information") {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) =>  TabBarExample(),
    //     ),
    //   );
    // }
    else if (title == "About Us") {
      appNavigator.launchAboutPageProfile(context);
    } else if (title == "Logout") {
      showModalBottomSheet(
          context: MainAppBloc.getDashboardContext,
          builder: (context) => const LogOutBottomSheetScreen(),
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))));
    }
  }
}
