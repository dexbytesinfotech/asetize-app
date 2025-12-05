// add_asset_step1.dart
import '../../../imports.dart';
import '../../booking/widgets/label_widget.dart';
import '../bloc/assets_management_bloc.dart';
import '../bloc/assets_management_event.dart';
import '../model/assets_category_list_model.dart';
import '../model/assets_list_model.dart';
import '../model/vendor_list_model.dart';
import 'package:intl/intl.dart';

class AddAssetStep1 extends StatefulWidget {
  final bool isEditMode;
  final AssetListData? detailData;
  final String? barcode;
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onNext;

  const AddAssetStep1({
    super.key,
    required this.isEditMode,
    this.detailData,
    this.barcode,
    required this.initialData,
    required this.onNext,
  });

  @override
  State<AddAssetStep1> createState() => _AddAssetStep1State();
}

class _AddAssetStep1State extends State<AddAssetStep1> {
  final _formKey = GlobalKey<FormState>();
  late AssetsManagementBloc assetsManagementBloc;
  List<String> filteredCategories = [];
  List<String> filteredLocations = [];
  List<String> filteredVendors = [];
  bool showAddNewCategory = false;
  bool showAddNewVendor = false;
  // All controllers & variables same as before (copy-paste from your original file)
  int selectCategoryId = 0;
  int selectedVendorId = 0;
  DateTime? _selectedPurchaseDate;
  TextEditingController categoryController = TextEditingController();
  TextEditingController vendorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    assetsManagementBloc = BlocProvider.of<AssetsManagementBloc>(context);
    assetsManagementBloc.add(OnGetAssetsCategoryList(mContext: context));
    assetsManagementBloc.add(OnGetVendorList(mContext: context));
    // setData() logic same as original
  }

  bool _validate() {
    return controllers['title']!.text.trim().isNotEmpty &&
        controllers['category']!.text.trim().isNotEmpty &&
        controllers['vendor']!.text.trim().isNotEmpty &&
        controllers['purchaseDate']!.text.trim().isNotEmpty &&
        controllers['smallDescription']!.text.trim().isNotEmpty &&
        controllers['purchaseCost']!.text.trim().isNotEmpty;
  }
  final Map<String, FocusNode> focusNodes = {
    'title': FocusNode(),
    'category': FocusNode(),
    'vendor': FocusNode(),
    'purchaseDate': FocusNode(),
    'smallDescription': FocusNode(),
    'expiryMonths': FocusNode(),
    'warrantyMonths': FocusNode(),
    'purchaseCost': FocusNode(),
    'modelNumber': FocusNode(),
    'manufacturer': FocusNode(),
    'licenseKey': FocusNode(),
    'accountCredential': FocusNode(),
    'assetLocation': FocusNode(),
    'longDescriptions': FocusNode(),
  };

  final Map<String, TextEditingController> controllers = {
    'title': TextEditingController(),
    'category': TextEditingController(),
    'vendor': TextEditingController(),
    'purchaseDate': TextEditingController(),
    'smallDescription': TextEditingController(),
    'warrantyMonths': TextEditingController(),
    'purchaseCost': TextEditingController(),
    'modelNumber': TextEditingController(),
    'manufacturer': TextEditingController(),
    'assetLocation': TextEditingController(),
    'longDescriptions': TextEditingController(),
  };

  void selectDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _selectedPurchaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        _selectedPurchaseDate = newDate;
        controllers['purchaseDate']!.text = DateFormat('d MMM, yyyy').format(newDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget titleWidget() {
      return CommonTextFieldWithError(
        focusNode: focusNodes['title']!,
        controllerT: controllers['title']!,
        borderRadius: 8,
        inputHeight: 50,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        maxCharLength: 100,
        errorMsgHeight: 20,
        showError: true,
        autoFocus: false,
        enabledBorderColor: Colors.white,
        focusedBorderColor: Colors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        capitalization: CapitalizationText.sentences,
        borderStyle: BorderStyle.solid,
        cursorColor: Colors.grey,
        hintText: AppString.enterAssetTitle,
        placeHolderTextWidget: const LabelWidget(labelText: AppString.titleLabel, isRequired: true),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        onTextChange: (value) {
          setState(() {});
        },
        onEndEditing: (value) {
          FocusScope.of(context).nextFocus();
        },
      );
    }

    Widget categoryWidget() {
      void filterCategories(String query) {
        setState(() {
          filteredCategories = assetsManagementBloc.assetsCategoryListData!
              .where((category) =>
              (category.name ?? '').toLowerCase().contains(query.toLowerCase()))
              .map((category) => category.name ?? '')
              .toList()
              .where((name) => name.trim().isNotEmpty)
              .toList();
          showAddNewCategory = query.isNotEmpty && filteredCategories.isEmpty;
        });
      }

      return Container(
        margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextFieldWithError(
              focusNode: focusNodes['category'],
              isShowBottomErrorMsg: false,
              controllerT: controllers['category'],
              borderRadius: 8,
              inputHeight: 50,
              errorLeftRightMargin: 0,
              maxCharLength: 50,
              errorMsgHeight: 20,
              autoFocus: false,
              showError: true,
              capitalization: CapitalizationText.none,
              cursorColor: AppColors.appBlueColor,
              placeHolderTextWidget: Padding(
                padding: const EdgeInsets.only(left: 3.0, bottom: 3),
                child: Text.rich(
                  TextSpan(
                    text: AppString.searchCategory,
                    style: appStyles.texFieldPlaceHolderStyle(),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: appStyles
                            .texFieldPlaceHolderStyle()
                            .copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              isShowShadow: false,
              enabledBorderColor: Colors.grey.shade700.safeOpacity(0.15),
              errorBorderColor: AppColors.appErrorTextColor,
              focusedBorderColor: AppColors.appBlueColor,
              backgroundColor: AppColors.white,
              textInputAction: TextInputAction.next,
              borderStyle: BorderStyle.solid,
              inputKeyboardType: InputKeyboardTypeWithError.text,
              hintText: AppString.searchCategory,
              hintStyle: appStyles.hintTextStyle(),
              textStyle: appStyles.textFieldTextStyle(),
              contentPadding: const EdgeInsets.only(left: 15, right: 15),
              onTextChange: (value) {
                filterCategories(value);
              },
              onEndEditing: (value) {
                FocusScope.of(context).nextFocus();
                setState(() {
                  filteredCategories.clear();
                  showAddNewCategory = false;
                });
              },
              onTapCallBack: () {
                setState(() {
                  filteredCategories = assetsManagementBloc.assetsCategoryListData!
                      .map((category) => category.name ?? '')
                      .where((name) => name.trim().isNotEmpty)
                      .toList();
                  showAddNewCategory = false;
                });
              },
            ),

            /// List for searched categories or "Add New Category"
            if (filteredCategories.isNotEmpty || showAddNewCategory)
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ]
                ),
                margin: const EdgeInsets.only(top: 0),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount:
                  filteredCategories.length + (showAddNewCategory ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (showAddNewCategory && index == filteredCategories.length) {
                      return ListTile(
                        title: Center(
                          child: Text(
                            AppString.applicationSubmittedSuccessfully,
                            style: appStyles.textFieldTextStyle().copyWith(
                              color: AppColors.appBlueColor,
                            ),
                          ),
                        ),
                        onTap: () {
                          WorkplaceWidgets.addNewItem(
                            context: context,
                            controller: categoryController,
                            title: AppString.addNewCategory,
                            labelText: AppString.categoryName,
                            hintText: AppString.enterCategoryName,
                            confirmButtonText: AppString.addCategory,
                            onAddItem: () async {
                              final newCategoryName = categoryController.text.trim();
                              if (newCategoryName.isEmpty) return;
                              assetsManagementBloc.add(OnAddAssetCategoryEvent(
                                mContext: context,
                                title: newCategoryName,
                              ));
                              await Future.delayed(const Duration(milliseconds: 500));
                              assetsManagementBloc.add(OnGetAssetsCategoryList(mContext: context));
                              setState(() {
                                controllers['category']?.text = newCategoryName;
                                final newCategory = assetsManagementBloc.assetsCategoryListData!
                                    .firstWhere(
                                      (cat) => (cat.name ?? '').toLowerCase() == newCategoryName.toLowerCase(),
                                  orElse: () => AssetsCategoryListData(id: 0, name: newCategoryName),
                                );
                                selectCategoryId = newCategory.id ?? 0;
                                filteredCategories.clear();
                                showAddNewCategory = false;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },

                      );
                    }
                    final selectedCategory =
                    assetsManagementBloc.assetsCategoryListData!.firstWhere(
                            (cat) => cat.name == filteredCategories[index]);
                    return ListTile(
                      title: Text(
                        filteredCategories[index],
                        style: appStyles.textFieldTextStyle(),
                      ),
                      onTap: () {
                        setState(() {
                          controllers['category']?.text = filteredCategories[index];
                          selectCategoryId = selectedCategory.id ?? 0;
                          filteredCategories.clear();
                          showAddNewCategory = false;
                        });
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      );
    }


    Widget vendorWidget() {
      void filterVendors(String query) {
        setState(() {
          final vendorList = assetsManagementBloc.vendorListData ?? [];

          filteredVendors = vendorList
              .where((vendor) =>
              (vendor.name ?? '').toLowerCase().contains(query.toLowerCase()))
              .map((vendor) => vendor.name ?? '')
              .where((name) => name.trim().isNotEmpty)
              .toList();

          showAddNewVendor = query.isNotEmpty && filteredVendors.isEmpty;
        });
      }

      return Container(
        margin: const EdgeInsets.only( bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextFieldWithError(
              controllerT: controllers['vendor'],
              focusNode: focusNodes['vendor'],
              hintText: AppString.searchVendor,
              placeHolderTextWidget: Padding(
                padding: const EdgeInsets.only(left: 3.0, bottom: 3),
                child: Text.rich(
                  TextSpan(
                    text: AppString.searchVendor,
                    style: appStyles.texFieldPlaceHolderStyle(),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: appStyles
                            .texFieldPlaceHolderStyle()
                            .copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              hintStyle: appStyles.hintTextStyle(),
              textStyle: appStyles.textFieldTextStyle(),
              borderRadius: 8,
              inputHeight: 50,
              onTextChange: (value) {
                filterVendors(value);
              },
              onEndEditing: (value) {
                FocusScope.of(context).nextFocus();
                setState(() {
                  filteredVendors.clear();
                  showAddNewVendor = false;
                });
              },
              onTapCallBack: () {
                setState(() {
                  final vendorList = assetsManagementBloc.vendorListData ?? [];
                  filteredVendors = vendorList
                      .map((vendor) => vendor.name ?? '')
                      .where((name) => name.trim().isNotEmpty)
                      .toList();
                  showAddNewVendor = false;
                });
              },
            ),

            if (filteredVendors.isNotEmpty || showAddNewVendor)
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                margin: const EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: filteredVendors.length + (showAddNewVendor ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (showAddNewVendor && index == filteredVendors.length) {
                      return ListTile(
                        title: Center(
                          child: Text(
                            AppString.addNewVendor,
                            style: appStyles.textFieldTextStyle().copyWith(
                              color: AppColors.appBlueColor,
                            ),
                          ),
                        ),
                        onTap: () {
                          WorkplaceWidgets.addNewItem(
                            context: context,
                            controller: vendorController,
                            title:   AppString.addNewVendor,
                            labelText: AppString.vendorName,
                            hintText: AppString.enterVendorName,
                            confirmButtonText:   AppString.addVendor,
                            onAddItem: () async {
                              final newVendorName = vendorController.text.trim();
                              if (newVendorName.isEmpty) return;

                              assetsManagementBloc.add(OnAddVendorEvent(
                                mContext: context,
                                name: newVendorName,
                              ));

                              await Future.delayed(const Duration(milliseconds: 500));
                              assetsManagementBloc.add(OnGetVendorList(mContext: context));

                              setState(() {
                                controllers['vendor']?.text = newVendorName;

                                final vendorList =
                                    assetsManagementBloc.vendorListData ?? [];

                                final newVendor = vendorList.firstWhere(
                                      (ven) =>
                                  (ven.name ?? '').toLowerCase() ==
                                      newVendorName.toLowerCase(),
                                  orElse: () =>
                                      VendorListData(id: 0, name: newVendorName),
                                );

                                selectedVendorId = newVendor.id ?? 0;
                                filteredVendors.clear();
                                showAddNewVendor = false;
                              });

                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    }

                    final vendorList = assetsManagementBloc.vendorListData ?? [];

                    final selectedVendor = vendorList.firstWhere(
                          (ven) => ven.name == filteredVendors[index],
                      orElse: () =>
                          VendorListData(id: 0, name: filteredVendors[index]),
                    );

                    return ListTile(
                      title: Text(
                        filteredVendors[index],
                        style: appStyles.textFieldTextStyle(),
                      ),
                      onTap: () {
                        setState(() {
                          controllers['vendor']?.text = filteredVendors[index];
                          selectedVendorId = selectedVendor.id ?? 0;
                          filteredVendors.clear();
                          showAddNewVendor = false;
                        });
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      );
    }

    Widget purchaseDateWidget() {
      return CommonTextFieldWithError(
        focusNode: focusNodes['purchaseDate']!,
        controllerT: controllers['purchaseDate']!,
        borderRadius: 8,
        inputHeight: 50,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        maxCharLength: 10,
        errorMsgHeight: 20,
        showError: true,
        readOnly: true,
        autoFocus: false,
        inputFieldSuffixIcon: WorkplaceWidgets.calendarIcon(),
        enabledBorderColor: Colors.white,
        focusedBorderColor: Colors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        cursorColor: Colors.grey,
        hintText: AppString.selectPurchaseDate,
        placeHolderTextWidget: const LabelWidget(labelText: AppString.purchaseDateLabel, isRequired: true),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        onTapCallBack: () => selectDate(context),
        onTextChange: (value) {
          setState(() {});

        },
        onEndEditing: (value) {
          FocusScope.of(context).nextFocus();
        },
      );
    }

    Widget smallDescriptionWidget() {
      return CommonTextFieldWithError(
        focusNode: focusNodes['smallDescription'],
        controllerT: controllers['smallDescription'],
        borderRadius: 8,
        inputHeight: 140,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        maxCharLength: 500,
        minLines: 3,
        maxLines: 3,
        autoFocus: false,
        showCounterText: false, // hide default
        capitalization: CapitalizationText.sentences,
        cursorColor: Colors.grey,
        enabledBorderColor: Colors.white,
        focusedBorderColor: Colors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.newline,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.multiLine,
        hintText: AppString.enterSmallDescription,
        placeHolderTextWidget: const LabelWidget(
          labelText: AppString.smallDescriptionLabel,
          isRequired: true,
        ),
        contentPadding: const EdgeInsets.all(10),
        onTextChange: (value) {
          setState(() {}); // update counter
        },
        onEndEditing: (value) {},
      );

    }


    Widget purchaseCostWidget() {
      return CommonTextFieldWithError(
        focusNode: focusNodes['purchaseCost']!,
        controllerT: controllers['purchaseCost']!,
        borderRadius: 8,
        inputHeight: 50,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        maxCharLength: 10,
        errorMsgHeight: 20,
        showError: true,
        autoFocus: false,
        inputKeyboardType: InputKeyboardTypeWithError.number,
        enabledBorderColor: Colors.white,
        focusedBorderColor: Colors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        cursorColor: Colors.grey,
        hintText: AppString.enterPurchaseCost,
        placeHolderTextWidget: const LabelWidget(labelText: AppString.purchaseCostLabel, isRequired: true),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        onTextChange: (value) {
          setState(() {});

        },
        onEndEditing: (value) {
          FocusScope.of(context).nextFocus();
        },
      );
    }



    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            titleWidget(),
            const SizedBox(height: 15),
            categoryWidget(),
            const SizedBox(height: 15),
            vendorWidget(),
            const SizedBox(height: 15),
            purchaseDateWidget(),
            const SizedBox(height: 15),
            smallDescriptionWidget(),
            const SizedBox(height: 15),
            purchaseCostWidget(),
            const Spacer(),
            AppButton(
              buttonName: "Next",
              buttonColor: _validate() ? AppColors.appBlueColor : Colors.grey,
              backCallback: _validate()
                  ? () {
                widget.onNext({
                  'title': controllers['title']!.text.trim(),
                  'categoryId': selectCategoryId,
                  'vendorId': selectedVendorId,
                  'purchaseDate': _selectedPurchaseDate,
                  'purchaseDateDisplay': controllers['purchaseDate']!.text,
                  'smallDescription': controllers['smallDescription']!.text.trim(),
                  'purchaseCost': double.tryParse(controllers['purchaseCost']!.text.trim()) ?? 0.0,
                });
              }
                  : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

// Paste all your widget methods here exactly as they were:
// titleWidget(), categoryWidget(), vendorWidget(), purchaseDateWidget(),
// smallDescriptionWidget(), purchaseCostWidget() → unchanged
}