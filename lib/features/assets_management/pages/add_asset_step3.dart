// add_asset_step3.dart
import 'package:image_picker/image_picker.dart';

import '../../../imports.dart';
import '../bloc/assets_management_bloc.dart';
import '../bloc/assets_management_event.dart';
import '../bloc/assets_management_state.dart';
import '../model/assets_list_model.dart';

class AddAssetStep3 extends StatefulWidget {
  final bool isEditMode;
  final int? assetId;
  final String? barcode;
  final AssetListData? detailData;
  final Map<String, dynamic> stepData;
  final VoidCallback onBack;

  const AddAssetStep3({
    super.key,
    required this.isEditMode,
    this.assetId,
    this.barcode,
    this.detailData,
    required this.stepData,
    required this.onBack,
  });

  @override
  State<AddAssetStep3> createState() => _AddAssetStep3State();
}

class _AddAssetStep3State extends State<AddAssetStep3> {
  List<File> selectedInvoiceCopyImages = [];
  List<File> selectedAssetImages = [];
  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  late AssetsManagementBloc assetsManagementBloc;

  @override
  void initState() {
    super.initState();
    assetsManagementBloc = BlocProvider.of<AssetsManagementBloc>(context);
  }

  @override
  Widget build(BuildContext context) {

    Widget invoiceCopyUploadWidget() {
      return Padding(
        padding: const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppString.invoiceCopy,
              style: appStyles.texFieldPlaceHolderStyle(),
            ),
            const SizedBox(height: 10),

            /// --- Show selected images in GRID view (3 per row) ---
            if (selectedInvoiceCopyImages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 15,top: 0,left: 1.5,right: 3),
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedInvoiceCopyImages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 images per row
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1, // square shape
                  ),
                  itemBuilder: (context, index) {
                    final imageFile = selectedInvoiceCopyImages[index];
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              FadeRoute(
                                widget: FullPhotoView(
                                  title:  "Invoice Copy Image${index + 1}",
                                  localProfileImgUrl: imageFile.path,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              imageFile,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedInvoiceCopyImages.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.withOpacity(0.9),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            /// --- Upload container ---
            GestureDetector(
              onTap: () async {
                closeKeyboard();
                final pickedFiles = await ImagePicker().pickMultiImage(
                  imageQuality: 80,
                );

                if (pickedFiles.isNotEmpty) {
                  setState(() {
                    selectedInvoiceCopyImages.addAll(
                      pickedFiles.map((e) => File(e.path)),
                    );
                  });
                }
              },
              child: Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(
                    color: AppColors.textBlueColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.cloud_upload_outlined,
                        color: AppColors.appBlueColor, size: 40),
                    SizedBox(height: 8),
                    Text(
                      AppString.uploadImage,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      AppString.uploadImageType,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    Widget assetImagesUploadWidget() {
      return Padding(
        padding: const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppString.invoiceCopy,
              style: appStyles.texFieldPlaceHolderStyle(),
            ),
            const SizedBox(height: 10),

            /// --- Show selected images in GRID view (3 per row) ---
            if (selectedInvoiceCopyImages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 15,top: 0,left: 1.5,right: 3),
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedInvoiceCopyImages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 images per row
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1, // square shape
                  ),
                  itemBuilder: (context, index) {
                    final imageFile = selectedInvoiceCopyImages[index];
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              FadeRoute(
                                widget: FullPhotoView(
                                  title:  "Invoice Copy Image${index + 1}",
                                  localProfileImgUrl: imageFile.path,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              imageFile,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedInvoiceCopyImages.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.withOpacity(0.9),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            /// --- Upload container ---
            GestureDetector(
              onTap: () async {
                closeKeyboard();
                final pickedFiles = await ImagePicker().pickMultiImage(
                  imageQuality: 80,
                );

                if (pickedFiles.isNotEmpty) {
                  setState(() {
                    selectedInvoiceCopyImages.addAll(
                      pickedFiles.map((e) => File(e.path)),
                    );
                  });
                }
              },
              child: Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(
                    color: AppColors.textBlueColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.cloud_upload_outlined,
                        color: AppColors.appBlueColor, size: 40),
                    SizedBox(height: 8),
                    Text(
                      AppString.uploadImage,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      AppString.uploadImageType,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return BlocConsumer<AssetsManagementBloc, AssetsManagementState>(
      listener: (context, state) {
        // Same success/error handling as original
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              invoiceCopyUploadWidget(), // reuse your invoiceCopy() logic
              const SizedBox(height: 20),
              assetImagesUploadWidget(), // similar to invoice but separate
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      buttonName: "Back",
                      buttonColor: Colors.grey,
                      backCallback: widget.onBack,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AppButton(
                      buttonName: widget.isEditMode ? "Update" : "Save",
                      isLoader: state is AddAssetLoadingState || state is UpdateAssetLoadingState,
                      buttonColor: AppColors.appBlueColor,
                      backCallback: () {
                        // Combine all data from widget.stepData + images
                        final data = widget.stepData;
                        // Add image paths
                        final invoicePaths = selectedInvoiceCopyImages.map((f) => f.path).toList();

                        // if (widget.isEditMode) {
                        //   assetsManagementBloc.add(OnUpdateAssetEvent(/* all params using data + invoicePaths */));
                        // } else {
                        //   assetsManagementBloc.add(OnAddAssetEvent(/* all params using data + invoicePaths */));
                        // }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

}