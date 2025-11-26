import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../imports.dart';

class CreatePostBottomView extends StatefulWidget {
  final selectedImageCallBack;
  final selectedCameraImageCallBack;
  const CreatePostBottomView({
    super.key,
    this.selectedImageCallBack,
    this.selectedCameraImageCallBack,
  });

  @override
  State<CreatePostBottomView> createState() => _CreatePostBottomViewState();
}

class _CreatePostBottomViewState extends State<CreatePostBottomView> {
  // openImageGallery() async {
  //   List<Media>? fileList;
  //   try {
  //     fileList = await ImagePickers.pickerPaths(
  //       galleryMode: GalleryMode.image,
  //       showGif: false,
  //       selectCount: 5,
  //       showCamera: false,
  //       videoSelectMaxSecond: 300,
  //       cropConfig: CropConfig(enableCrop: false, height: 20, width: 20),
  //       compressSize: 500,
  //       uiConfig: UIConfig(
  //         uiThemeColor: Colors.blueAccent,
  //       ),
  //     );
  //     if (fileList.isNotEmpty) {
  //       if (widget.selectedImageCallBack != null) {
  //         widget.selectedImageCallBack(fileList);
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("$e");
  //   }
  // }
  //
  // openCamera() async {
  //   Media? fileList;
  //   try {
  //     fileList = await ImagePickers.openCamera(
  //       cropConfig: CropConfig(enableCrop: false, height: 20, width: 20),
  //     );
  //
  //     if (fileList != null && fileList.path!.isNotEmpty) {
  //       if (widget.selectedCameraImageCallBack != null) {
  //         widget.selectedCameraImageCallBack(fileList);
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("$e");
  //   }
  // }

  openImageGallery() async {
    List<XFile>? fileList;
    try {
      fileList = await ImagePicker().pickMultiImage(imageQuality: 50, limit: 5);
      if (fileList != null) {
        if (widget.selectedImageCallBack != null) {
          widget.selectedImageCallBack(fileList);
        }
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  openCamera() async {
    XFile? fileList;
    try {
      fileList = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50);
      if (fileList != null) {
        if (widget.selectedCameraImageCallBack != null) {
          widget.selectedCameraImageCallBack(fileList);
        }
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Divider(
          thickness: 0.5,
          color: Colors.grey.withOpacity(.5),
          height: .5,
        ),
        const SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () async {
                    openCamera();
                    // if (await Permission.camera.request().isGranted) {
                    //   openCamera();
                    // }
                  },
                  child: SvgPicture.asset(
                    'assets/images/camera_outline_image.svg',
                    height: 26,
                    width: 26,
                    color: AppColors.textBlueColor,
                  )),
              InkWell(
                  onTap: () {
                    openImageGallery();
                  },
                  child: SvgPicture.asset('assets/images/photos_image.svg',
                      height: 35, width: 35, color: AppColors.textBlueColor))
              /*,
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => BottomSheetOnlyCardView(
                            cardBackgroundColor: Colors.white,
                            topLineShow: true,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    openImageGallery();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/images/photos_image.svg',
                                            height: 35,
                                            width: 35,
                                            color: AppColors.buttonBgColor4),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Photo/video',
                                          style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 0.5,
                                  color: Colors.grey.withOpacity(.5),
                                  height: .5,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (await Permission.camera
                                        .request()
                                        .isGranted) openCamera();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/camera_outline_image.svg',
                                          height: 26,
                                          width: 26,
                                          color: AppColors.buttonBgColor4,
                                        ),
                                        const SizedBox(
                                          width: 18,
                                        ),
                                        const Text('Camera',
                                            style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: 16))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20))));
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      //color: Color(0xFF54626F),
                      color: AppColors.buttonBgColor4,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    )),
              ),*/
            ],
          ),
        ),
        const SizedBox(
          height: 6,
        ),
      ],
    );
  }
}
