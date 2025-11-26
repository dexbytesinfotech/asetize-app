import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../imports.dart';

class CreatePostBottomView extends StatefulWidget {
  final selectedImageCallBack;
  final selectedVideoCallBack;
  final selectedCameraImageCallBack;
  final bool cropEnable;
  const CreatePostBottomView({
    super.key,
    this.cropEnable = false,
    this.selectedImageCallBack,
    this.selectedVideoCallBack,
    this.selectedCameraImageCallBack,
  });
  @override
  State<CreatePostBottomView> createState() => _CreatePostBottomViewState();
}

class _CreatePostBottomViewState extends State<CreatePostBottomView> {
  Future<File?> cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      // cropStyle: CropStyle.rectangle,
      // aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 4),
      // aspectRatioPresets: [CropAspectRatioPreset.original],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls:
              true, // Optional: Hides bottom aspect ratio controls
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          hidesNavigationBar: true,
        ),
      ],
    );

    return croppedFile != null ? File(croppedFile.path) : null;
  }

  openImageGallery() async {
    List<XFile>? fileList;
    try {
      // Pick multiple images from the gallery
      fileList = await ImagePicker().pickMultiImage(imageQuality: 50, limit: 5);

      if (fileList != null && fileList.isNotEmpty) {
        List<XFile> processedFiles = [];
        List<XFile> exceededFileNames = [];

        for (XFile file in fileList) {
          File imageFile = File(file.path);

          // Validate file size
          if (!projectUtil.isFileSizeValid(imageFile)) {
            exceededFileNames.add(file);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text('Image ${file.name} exceeds 25 MB limit.'),
            //     action: SnackBarAction(
            //       textColor: AppColors.white,
            //       label: 'OK',
            //       onPressed: () {
            //         // Dismiss the SnackBar when "OK" is pressed
            //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
            //       },
            //     ),
            //     duration: Duration(days: 1), // Keeps SnackBar visible indefinitely
            //   ),
            // );

            continue;
          }

          // Check if cropping is enabled
          if (widget.cropEnable == true) {
            File? croppedFile = await cropImage(imageFile);

            if (croppedFile != null) {
              processedFiles.add(XFile(croppedFile.path));
            } else {
              processedFiles.add(XFile(imageFile.path)); // Fallback to original
            }
          } else {
            processedFiles.add(XFile(imageFile.path));
          }
        }
        // Show SnackBar if any files exceed the size limit
        if (exceededFileNames.isNotEmpty) {
          /*    ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'The images ${exceededFileNames.join(', ')} exceeds 25 MB limit.',
              ),
              action: SnackBarAction(
                textColor: AppColors.white,
                label: 'OK',
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
              duration: Duration(days: 1), // Keeps SnackBar visible until action
            ),
          );*/

          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.error_outline,
                              //   size: 25,
                              //   color: Colors.red.shade700,
                              // ),
                              // const SizedBox(width: 8),
                               Text(
                                'Alert',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 0,
                          color: Colors.grey.shade100,
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text(
                               //   'The following images exceed the 25 MB size limit:',
                               //These images exceed the 25 MB limit.
                              'The images are more than 25 MB',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Displaying images with names
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: exceededFileNames.length,
                          itemBuilder: (context, index) {
                            String fileName =
                                exceededFileNames[index].name;
                            String filePath = fileList!
                                .firstWhere(
                                    (file) => file.name == fileName)
                                .path;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6,top: 6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 6),
                                decoration: const BoxDecoration(
                                 // color: Colors.grey.shade100,
                                  color: Colors.transparent,
                                  borderRadius:  BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(4),
                                      child: Image.file(
                                        File(filePath),
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          // Display a grey container with an icon when image fails to load
                                          return Container(
                                            width: 30,
                                            height: 30,
                                            color: Colors.grey[400],
                                            child: const Icon(
                                              Icons.broken_image,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      fileName,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }, separatorBuilder: (BuildContext context, int index) {
                            return     Divider(
                              height: 0,
                              color: Colors.grey.shade200,
                            );
                        },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  color: AppColors.appBlue,
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    AppString.ok,
                                    style: appStyles.subTitleStyle(
                                      fontSize: AppDimens().fontSize(value: 15),
                                      fontWeight: FontWeight.w500,
                                      texColor: AppColors.appWhite,
                                      fontFamily: AppFonts().defaultFont,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }

        // Call the callback with the processed images
        if (processedFiles.isNotEmpty && widget.selectedImageCallBack != null) {
          widget.selectedImageCallBack(processedFiles);
        }

        // if (widget.selectedImageCallBack != null) {
        //   widget.selectedImageCallBack(processedFiles);
        // }
      }
    } catch (e) {
      debugPrint("$e ");
    }
  }

  openCamera() async {
    XFile? pickedFile;
    try {
      // Pick an image from the camera
      pickedFile = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50);

      if (pickedFile != null) {
        // Crop the image in a circular shape
        if (widget.cropEnable == true) {
          File? croppedFile = await cropImage(File(pickedFile.path));

          if (croppedFile != null) {
            if (widget.selectedCameraImageCallBack != null) {
              widget.selectedCameraImageCallBack(XFile(croppedFile.path));
            }
          }
        } else {
          if (widget.selectedCameraImageCallBack != null) {
            widget.selectedCameraImageCallBack(XFile(pickedFile.path));
          }
        }
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  openVideoGallery() async {
    XFile? fileList;
    try {
      //fileList = await ImagePicker().pickMultiImage(imageQuality: 50, limit: 5);
      fileList = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (fileList != null) {
        // // Validate video size
        // if (projectUtil.isFileSizeValid(fileList)) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Video exceeds 25 MB limit.')),
        //   );
        //   return;
        // }
        if (!projectUtil.isFileSizeValid(File(fileList.path))) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content:
          //         Text('Video ${File(fileList.name)} exceeds 25 MB limit.'),
          //     action: SnackBarAction(
          //       textColor: AppColors.white,
          //       label: 'OK',
          //       onPressed: () {
          //         // Dismiss the SnackBar when "OK" is pressed
          //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //       },
          //     ),
          //     duration: const Duration(
          //         days: 1), // Keeps SnackBar visible indefinitely
          //   ),
          // );
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.error_outline,
                              //   size: 25,
                              //   color: Colors.red.shade700,
                              // ),
                              // const SizedBox(width: 8),
                              Text(
                                'Alert',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 0,
                          color: Colors.grey.shade100,
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              //   'The following images exceed the 25 MB size limit:',
                              //These images exceed the 25 MB limit.
                              'The video is more than 25 MB',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Displaying images with names
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${File(fileList?.name ?? '')}',
                                maxLines: 3,
                                overflow : TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black),

                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12,),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  color: AppColors.appBlue,
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    AppString.ok,
                                    style: appStyles.subTitleStyle(
                                      fontSize: AppDimens().fontSize(value: 15),
                                      fontWeight: FontWeight.w500,
                                      texColor: AppColors.appWhite,
                                      fontFamily: AppFonts().defaultFont,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  );
                },
              );
            },
          );
          return;
        }
        if (widget.selectedVideoCallBack != null) {
          widget.selectedVideoCallBack(fileList);
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
                    FocusScope.of(context).unfocus();
                    openCamera();
                    // if (await Permission.camera.request().isGranted) {
                    //   openCamera();
                    // }
                  },
                  child: SvgPicture.asset(
                    'assets/images/camera_outline_image.svg',
                    height: 26,
                    width: 26,
                    color: AppColors.appBlueColor,
                  )),
              InkWell(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    openVideoGallery();
                  },
                  child: SvgPicture.asset(
                    'assets/images/video_icon.svg',
                    height: 26,
                    width: 26,
                    color: AppColors.appBlueColor,
                  )),
              InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    openImageGallery();
                  },
                  child: SvgPicture.asset('assets/images/photos_image.svg',
                      height: 35, width: 35, color: AppColors.appBlueColor))
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
