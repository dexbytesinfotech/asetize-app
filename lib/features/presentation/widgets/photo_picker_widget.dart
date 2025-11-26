// ignore_for_file: prefer_const_constructors
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:asetize/imports.dart';

final double photoPickerBottomSheetCardRadius = 20;
final Color photoPickerBottomSheetCardColor = Colors.white;

class PhotoPickerBottomSheet extends StatefulWidget {
  final selectedImageCallBack;
  final selectedCameraImageCallBack;
  final removedImageCallBack;
  final bool isRemoveOptionNeeded;
  final String? sheetTitle;
  final String? cancelText;
  final dynamic? cancelIcon;
  final bool cropEnable;
  final Function()? topLineClickCallBack;
  final Function()? onSkipClick;

  const PhotoPickerBottomSheet(
      {Key? key,
      this.selectedImageCallBack,
      this.selectedCameraImageCallBack,
      this.removedImageCallBack,
      this.sheetTitle,this.topLineClickCallBack,
      this.cropEnable = false,
        this.cancelIcon,
        this.onSkipClick,
      this.cancelText = "Remove Photo",
      this.isRemoveOptionNeeded = false})
      : super(key: key);

  @override
  _EditProfileImageBottomSheetState createState() =>
      _EditProfileImageBottomSheetState();
}

class _EditProfileImageBottomSheetState extends State<PhotoPickerBottomSheet>
    with TickerProviderStateMixin {
  bool isScrolled = false;
  List ageList = [];

  File? selectedKidProfile;
  Map<String, File>? imageFile;
  Map<String, String>? imagePath;

  @override
  Widget build(BuildContext context) {
    AppDimens().appDimensFind(context: context);

    Future<File?> cropImage(File imageFile) async {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            cropStyle: CropStyle.circle,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: true, // Optional: Hides bottom aspect ratio controls
          ),
          IOSUiSettings(
            cropStyle: CropStyle.circle,
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            hidesNavigationBar: true,
          ),
        ],
      );

      return croppedFile != null ? File(croppedFile.path) : null;
    }

    openImageGallery() async {
      XFile? pickedFile;
      try {
        // Pick an image from the gallery
        pickedFile = await ImagePicker()
            .pickImage(source: ImageSource.gallery, imageQuality: 50);

        if (pickedFile != null) {
          // Crop the image in a circular shape
          if (widget.cropEnable == true) {
            File? croppedFile = await cropImage(File(pickedFile.path));

            if (croppedFile != null) {
                        if (widget.selectedImageCallBack != null) {
                          widget.selectedImageCallBack([XFile(croppedFile.path)]);
                        }
                      }
          } else {
            if (widget.selectedImageCallBack != null) {
              widget.selectedImageCallBack([XFile(pickedFile.path)]);
            }
          }
        }
      } catch (e) {
        debugPrint("$e");
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

    //Bottom sheet option row
    createNewRowItems(
        {icon, name, callback, isLastMenu = false, double margin = 8}) {
      return GestureDetector(
        onTap: () {
          callback();
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 5),
          color: Colors.transparent,
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: margin),
                height: 40,
                child: isLastMenu ? Container() : icon,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "$name",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    //Return main Ui view
    return BottomSheetOnlyCardView(
      sheetTitle: widget.sheetTitle ?? "Select Photo",
      onSkipClick: widget.onSkipClick,
      skipTextStyle: TextStyle(color: Colors.black, fontSize: 18),
      sheetTitleStyle: TextStyle(color: Colors.black, fontSize: 18),
      topLineShow: true,
        topLineClickCallBack: widget.topLineClickCallBack,
      topLineMargin: EdgeInsets.only(top: 8, bottom: 6),
      cardBackgroundColor: Colors.white,
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            createNewRowItems(
                icon: WorkplaceIcons.iconImage(
                    imageUrl: WorkplaceIcons.cameraIcon,
                    iconSize: const Size(26, 26),
                    imageColor: AppColors.textBlueColor),
                name: "  Take a Photo",
                callback: () async {
                  openCamera();
                  // if (await Permission.camera.request().isGranted) openCamera();
                }),
            SizedBox(
              height: 10,
            ),
            createNewRowItems(
                margin: 5,
                icon: WorkplaceIcons.iconImage(
                    imageUrl: WorkplaceIcons.galleryIcon,
                    iconSize: const Size(26, 26),
                    imageColor: AppColors.textBlueColor),
                name: "  Gallery",
                callback: () async {
                  openImageGallery();
                }),
            !widget.isRemoveOptionNeeded
                ? Container()
                : const SizedBox(
                    height: 10,
                  ),
            !widget.isRemoveOptionNeeded
                ? Container()
                : createNewRowItems(
                    margin: 0,
                    icon: widget.cancelIcon??WorkplaceIcons.iconImage(
                        imageUrl: WorkplaceIcons.galleryIcon,
                        iconSize: const Size(26, 26),
                        imageColor: AppColors.textBlueColor),
                    name: "  ${widget.cancelText}",
                    callback: () {
                      if (widget.removedImageCallBack != null) {
                        widget.removedImageCallBack();
                      }
                      // openImageGallery();
                    }),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
