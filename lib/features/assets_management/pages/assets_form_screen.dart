import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:asetize/core/core.dart';
import 'package:asetize/features/assets_management/bloc/assets_management_bloc.dart';
import 'package:asetize/features/assets_management/bloc/assets_management_state.dart';
import 'package:asetize/features/booking/pages/new_booking_request.dart';

import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/app_style.dart';
import '../../../imports.dart';
import '../../booking/widgets/label_widget.dart';
import '../../presentation/widgets/app_button_common.dart';
import '../../presentation/widgets/appbar/common_appbar.dart';
import '../../presentation/widgets/basic_view_container/container_first.dart';
import '../../presentation/widgets/common_text_field_with_error.dart';
import '../../presentation/widgets/full_image_view.dart';
import '../../presentation/widgets/workplace_widgets.dart';
import '../bloc/assets_management_event.dart';
import '../model/assets_category_list_model.dart';
import '../model/assets_list_model.dart';
import '../model/vendor_list_model.dart';

class AddAssetScreen extends StatefulWidget {
  final bool isEditMode;
  final int? assetId;
  final String? barcode;
  final  AssetListData? detailData;
  const AddAssetScreen({super.key, this.isEditMode= false, this.assetId, this.detailData, this.barcode});
  @override
  State<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  late AssetsManagementBloc assetsManagementBloc;
  DateTime? _selectedWarrantyDate;
  List<String> filteredCategories = [];
  List<String> filteredLocations = [];
  List<String> filteredVendors = [];
  bool showAddNewCategory = false;
  bool showAddNewVendor = false;
  int selectCategoryId = 0;
  int selectedVendorId = 0;
  TextEditingController categoryController = TextEditingController();
  TextEditingController vendorController = TextEditingController();
  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
  List<File> selectedInvoiceCopyImages = [];
  late List<String> selectedInvoiceCopyImagesPaths = selectedInvoiceCopyImages.map((file) => file.path).toList();
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

  String? selectedExpiredMonths;
  String? selectedWarrantyMonths;
  DateTime? _selectedPurchaseDate;
  final List<String> _warrantyMonths = ['1 Month', '3 Months', '6 Months', '12 Months', '18 Months', '24 Months', '36 Months'];
  void setData() {
    if(widget.isEditMode == false){
      return ;
    }
    selectCategoryId = widget.detailData?.category?.id ??0;
    selectedVendorId = widget.detailData?.vendor?.id ??0;
    controllers['title']?.text = (widget.detailData?.title ?? '').capitalize();
    controllers['category']?.text = widget.detailData?.category?.name ?? '';
    controllers['vendor']?.text = widget.detailData?.vendor?.name ?? '';
    controllers['purchaseDate']?.text =  widget.detailData?.registrationDateDisplay ?? "";
    controllers['smallDescription']?.text =  (widget.detailData?.smallDescription ?? '').capitalize();
    controllers['expiryMonths']?.text =  widget.detailData?.expiredDateDisplay ?? "";
    controllers['warrantyMonths']?.text = widget.detailData?.warrantyDateDisplay ?? '';
    if (widget.detailData?.warrantyDateDisplay != null &&
        widget.detailData!.warrantyDateDisplay!.isNotEmpty) {
      try {
        _selectedWarrantyDate = DateFormat('MMM d, yyyy').parseLoose(
          widget.detailData!.warrantyDateDisplay!,
        );
      } catch (_) {}
    }

    controllers['purchaseCost']?.text =  (widget.detailData?.purchaseCost.toString() ?? '');
    controllers['modelNumber']?.text =  (widget.detailData?.modelNumber ?? '').capitalize();
    controllers['manufacturer']?.text =  (widget.detailData?.manufacture ?? '').capitalize();
    controllers['longDescriptions']?.text =  (widget  .detailData?.description ?? '').capitalize();
    controllers['assetLocation']?.text =  (widget.detailData?.location ?? '').capitalize();
  }

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

  void selectWarrantyDate(BuildContext context) async {
    final DateTime? initialDate = _selectedWarrantyDate ??
        (widget.detailData?.warrantyDateDisplay != null
            ? DateFormat('MMM d, yyyy').parseLoose(widget.detailData!.warrantyDateDisplay!)
            : DateTime.now());

    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );

    if (newDate != null) {
      setState(() {
        _selectedWarrantyDate = newDate;
        controllers['warrantyMonths']!.text = DateFormat('MMM d, yyyy').format(newDate);
      });
    }
  }

  void showBottomSheet(BuildContext context, String title, List<String> options, String controllerKey, Function(String) onSelected) {
    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: title,
      valuesList: options,
      selectedValue: controllers[controllerKey]!.text,
      onValueSelected: (value) {
        setState(() {
          controllers[controllerKey]!.text = value.capitalize();
          onSelected(value);
        });
      },
    );
  }



  bool validateFields() {
    final title = controllers['title']?.text.trim();
    final category = controllers['category']?.text.trim();
    final vendor = controllers['vendor']?.text.trim();
    final purchaseDate = controllers['purchaseDate']?.text.trim();
    final purchaseCost = controllers['purchaseCost']?.text.trim();
    final smallDescription = controllers['smallDescription']?.text.trim();
    return
      (category?.isNotEmpty ?? false) &&
          (vendor?.isNotEmpty?? false) &&
          (title?.isNotEmpty?? false) &&
          (purchaseCost?.isNotEmpty ?? false)&&
          (smallDescription?.isNotEmpty ?? false)&&
          (purchaseDate?.isNotEmpty ?? false);
  }

  int? _parseMonths(String text) {
    if (text.isEmpty) return null;
    final match = RegExp(r'(\d+)').firstMatch(text);
    return match == null ? null : int.tryParse(match.group(1)!);
  }

@override
  void initState() {
  assetsManagementBloc = BlocProvider.of<AssetsManagementBloc>(context);
  assetsManagementBloc.add(OnGetAssetsCategoryList(mContext: context));
  assetsManagementBloc.add(OnGetVendorList(mContext: context));
  assetsManagementBloc.add(OnGetAssetsLocationList(mContext: context));
  setData();
  super.initState();
  }


  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    focusNodes.forEach((key, focusNode) => focusNode.dispose());
    super.dispose();
  }


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
                          AppString.addCategory,
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

  Widget assetLocationWidget() {
    void filterLocations(String query) {
      setState(() {
        filteredLocations = assetsManagementBloc.assetsLocationListData
            .where((location) =>
            (location.name ?? '').toLowerCase().contains(query.toLowerCase()))
            .map((location) => location.name ?? '')
            .where((name) => name.trim().isNotEmpty)
            .toList();
      });
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonTextFieldWithError(
            focusNode: focusNodes['assetLocation'],
            controllerT: controllers['assetLocation'],
            borderRadius: 8,
            hintStyle: appStyles.hintTextStyle(),
            textStyle: appStyles.textFieldTextStyle(),
            inputHeight: 50,
            errorLeftRightMargin: 0,
            maxCharLength: 50,
            errorMsgHeight: 20,
            autoFocus: false,
            showCounterText: false, // hide default
            capitalization: CapitalizationText.sentences,
            cursorColor: Colors.grey,
            enabledBorderColor: Colors.white,
            focusedBorderColor: Colors.white,
            backgroundColor: AppColors.white,
            textInputAction: TextInputAction.done,
            borderStyle: BorderStyle.solid,
            inputKeyboardType: InputKeyboardTypeWithError.multiLine,
              contentPadding: const EdgeInsets.all(10),
            onTextChange: (value) {
              filterLocations(value);
            },
              hintText: 'Enter a Asset Location',
              placeHolderTextWidget: const LabelWidget(
                labelText: 'Asset Location',
                isRequired: false,
              ),
            onEndEditing: (value) {
              FocusScope.of(context).nextFocus();
              setState(() {
                filteredLocations.clear();
              });
            },
            onTapCallBack: () {
              setState(() {
                filteredLocations = assetsManagementBloc.assetsLocationListData
                    .map((location) => location.name ?? '')
                    .where((name) => name.trim().isNotEmpty)
                    .toList();
              });
            },
          ),

          /// Suggestion List for Asset Locations
          if (filteredLocations.isNotEmpty)
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
                ],
              ),
              margin: const EdgeInsets.only(top: 0),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: filteredLocations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true, // makes tile more compact
                    visualDensity: const VisualDensity(vertical: -3),
                    title: Text(
                      filteredLocations[index],
                      style: appStyles.textFieldTextStyle(),
                    ),
                    onTap: () {
                      setState(() {
                        controllers['assetLocation']?.text =
                        filteredLocations[index];
                        filteredLocations.clear();
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

  Widget warrantyMonthsWidget() {
    final bool showCalendar = widget.isEditMode &&
        (widget.detailData?.warrantyDateDisplay?.isNotEmpty ?? false);
    DateTime? warrantyDate;
    if (showCalendar) {
      try {
        warrantyDate = DateFormat('MMM d, yyyy').parseLoose(
          widget.detailData!.warrantyDateDisplay!,
        );
      } catch (_) {}
    }

    return CommonTextFieldWithError(
      focusNode: focusNodes['warrantyMonths']!,
      controllerT: controllers['warrantyMonths']!,
      borderRadius: 8,
      inputHeight: 50,
      readOnly: true,
      inputFieldSuffixIcon: showCalendar
          ? WorkplaceWidgets.calendarIcon()
          : WorkplaceWidgets.downArrowIcon(),

      hintStyle: appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      maxCharLength: 50,
      errorMsgHeight: 20,
      showError: false,
      autoFocus: false,
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.next,
      borderStyle: BorderStyle.solid,
      cursorColor: Colors.grey,
      hintText: showCalendar ? AppString.selectWarrantyDate : AppString.selectWarranty,
      placeHolderTextWidget: const LabelWidget(labelText: 'Warranty', isRequired: false),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTapCallBack: () {
        FocusScope.of(context).unfocus();

        if (showCalendar) {
          selectWarrantyDate(context);
        } else {
          showBottomSheet(
            context,
           AppString.selectWarranty,
            _warrantyMonths,
            'warrantyMonths',
                (value) {
              selectedWarrantyMonths = value;
              // Clear any previously selected date behavior
              _selectedWarrantyDate = null;
            },
          );
        }
      },

      onTextChange: (value) => setState(() {}),
      onEndEditing: (value) => FocusScope.of(context).nextFocus(),
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

  Widget modelNumberWidget() {
    return CommonTextFieldWithError(
      focusNode: focusNodes['modelNumber']!,
      controllerT: controllers['modelNumber']!,
      borderRadius: 8,
      inputHeight: 50,
      capitalization: CapitalizationText.sentences,
      hintStyle: appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      maxCharLength: 50,
      errorMsgHeight: 20,
      showError: false,
      autoFocus: false,
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.next,
      borderStyle: BorderStyle.solid,
      cursorColor: Colors.grey,
      hintText: AppString.enterModelNumber,
      placeHolderTextWidget: const LabelWidget(labelText: AppString.modelNumberLabel, isRequired: false),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTextChange: (value) {},
      onEndEditing: (value) {
        FocusScope.of(context).nextFocus();
      },
    );
  }

  Widget manufacturerWidget() {
    return CommonTextFieldWithError(
      focusNode: focusNodes['manufacturer']!,
      controllerT: controllers['manufacturer']!,
      borderRadius: 8,
      inputHeight: 50,
      hintStyle: appStyles.hintTextStyle(),
      textStyle: appStyles.textFieldTextStyle(),
      maxCharLength: 50,
      errorMsgHeight: 20,
      showError: false,
      autoFocus: false,
      enabledBorderColor: Colors.white,
      focusedBorderColor: Colors.white,
      backgroundColor: AppColors.white,
      textInputAction: TextInputAction.next,
      borderStyle: BorderStyle.solid,
      cursorColor: Colors.grey,
      hintText: AppString.enterManufacture,
      placeHolderTextWidget: const LabelWidget(labelText: AppString.manufactureLabel, isRequired: false),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      onTextChange: (value) {},
      onEndEditing: (value) {
        FocusScope.of(context).nextFocus();
      },
    );
  }

  Widget longDescriptionsWidget() {

    return CommonTextFieldWithError(
      focusNode: focusNodes['longDescriptions'],
      controllerT: controllers['longDescriptions'],
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
      hintText:  AppString.enterLongDescription,
      placeHolderTextWidget: const LabelWidget(
        labelText: AppString.longDescriptionsLabel,
        isRequired: false,
      ),
      contentPadding: const EdgeInsets.all(10),
      onTextChange: (value) {
        setState(() {}); // update counter
      },
      onEndEditing: (value) {},
    );


  }

  Widget invoiceCopy() {
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

  Widget submitButtonWidget(state) {
    return AppButton(
      buttonName:widget.isEditMode? AppString.updateAsset: AppString.saveButton,
      isLoader: state is AddAssetLoadingState ||  state is UpdateAssetLoadingState ? true: false,
      buttonColor: validateFields()? AppColors.appBlueColor: Colors.grey,
        backCallback: validateFields()?
            () {
              DateTime? purchaseDate = projectUtil.parseDisplayDate(controllers['purchaseDate']!.text?? '');
              String formattedPurchaseDate = '';
              if (purchaseDate != null) {
                formattedPurchaseDate = projectUtil.submitDateFormat(purchaseDate); // e.g., '2025-05-30'
              }
              if (widget.isEditMode == false){
                assetsManagementBloc.add(OnAddAssetEvent(
                  title: controllers['title']!.text.trim(),
                  assetCategoryId: selectCategoryId,
                  vendorId: selectedVendorId,
                  purChaseDate: formattedPurchaseDate,
                  smallDescription: controllers['smallDescription']!.text.trim(),
                  // expiryMonths: _parseMonths(controllers['expiryMonths']!.text),
                  warrantyMonths: _parseMonths(controllers['warrantyMonths']!.text),
                  purchaseCost: double.tryParse(controllers['purchaseCost']!.text.trim()) ?? 0.0,
                  modelNumber: controllers['modelNumber']!.text.trim().isEmpty
                      ? null
                      : controllers['modelNumber']!.text.trim(),
                  manufacturer: controllers['manufacturer']!.text.trim().isEmpty
                      ? null
                      : controllers['manufacturer']!.text.trim(),
                  // licenseKey: controllers['licenseKey']!.text.trim().isEmpty
                  //     ? null
                  //     : controllers['licenseKey']!.text.trim(),
                  // accountCredential: controllers['accountCredential']!.text.trim().isEmpty
                  //     ? null
                  //     : controllers['accountCredential']!.text.trim(),
                  longDescription: controllers['longDescriptions']!.text.trim().isEmpty
                      ? null
                      : controllers['longDescriptions']!.text.trim(),

                  assetLocation: controllers['assetLocation']!.text.trim().isEmpty
                      ? null
                      : controllers['assetLocation']!.text.trim(),
                  barcode: widget.barcode ?? "",
                  invoiceFile: selectedInvoiceCopyImagesPaths.isEmpty ? null : selectedInvoiceCopyImagesPaths,
                ));

              } else {
                DateTime? warrantyDate = projectUtil.parseDisplayDate(controllers['warrantyMonths']!.text?? '');
                String formattedWarrantyDate = '';
                if (warrantyDate != null) {
                  formattedWarrantyDate = projectUtil.submitDateFormat(warrantyDate); // e.g., '2025-05-30'
                }
                assetsManagementBloc.add(OnUpdateAssetEvent(
                  assetId: widget.assetId ?? 0,
                  title: controllers['title']!.text.trim(),
                  assetCategoryId: selectCategoryId,
                  vendorId: selectedVendorId,
                  purChaseDate: formattedPurchaseDate,
                  smallDescription: controllers['smallDescription']!.text.trim(),
                  // expiryMonths: _parseMonths(controllers['expiryMonths']!.text),
                  warrantyMonths: formattedWarrantyDate,
                  purchaseCost: double.tryParse(controllers['purchaseCost']!.text.trim()) ?? 0.0,
                  modelNumber: controllers['modelNumber']!.text.trim().isEmpty
                      ? null
                      : controllers['modelNumber']!.text.trim(),
                  manufacturer: controllers['manufacturer']!.text.trim().isEmpty
                      ? null
                      : controllers['manufacturer']!.text.trim(),
                  // licenseKey: controllers['licenseKey']!.text.trim().isEmpty
                  //     ? null
                  //     : controllers['licenseKey']!.text.trim(),
                  // accountCredential: controllers['accountCredential']!.text.trim().isEmpty
                  //     ? null
                  //     : controllers['accountCredential']!.text.trim(),
                  longDescription: controllers['longDescriptions']!.text.trim().isEmpty
                      ? null
                      : controllers['longDescriptions']!.text.trim(),
                  assetLocation: controllers['assetLocation']!.text.trim().isEmpty
                      ? null
                      : controllers['assetLocation']!.text.trim(),
                  // invoiceFile: selectedInvoiceCopyImagesPaths.isEmpty ? null : selectedInvoiceCopyImagesPaths,
                ));

              }
      }: null
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: false,
      isListScrollingNeed: false,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar: CommonAppBar(
        isThen: false,
        title: widget.isEditMode ? AppString.editAsset:AppString.addAsset
      ),
      containChild: BlocListener<AssetsManagementBloc, AssetsManagementState>(
        bloc: assetsManagementBloc,
        listener: (context, state) {
          if (state is AddAssetErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is UpdateAssetErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }

          if (state is AddAssetDoneState) {
            Navigator.pop(context, true);
            WorkplaceWidgets.successToast(state.message);
          }
            if (state is UpdateAssetDoneState) {
            Navigator.pop(context, true);
            WorkplaceWidgets.successToast(state.message);
          }

          },
        child: BlocBuilder<AssetsManagementBloc, AssetsManagementState>(
          bloc: assetsManagementBloc,
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        titleWidget(),
                        const SizedBox(height: 10),
                        categoryWidget(),
                        const SizedBox(height: 10),
                        vendorWidget(),
                        const SizedBox(height: 10),
                        purchaseDateWidget(),
                        const SizedBox(height: 10),
                        smallDescriptionWidget(),
                        const SizedBox(height: 10),
                        warrantyMonthsWidget(),
                        const SizedBox(height: 10),
                        purchaseCostWidget(),
                        const SizedBox(height: 10),
                        modelNumberWidget(),
                        const SizedBox(height: 10),
                        manufacturerWidget(),
                        const SizedBox(height: 10),
                        longDescriptionsWidget(),
                        const SizedBox(height: 10),
                        assetLocationWidget(),
                         SizedBox(height: widget.isEditMode ? 0: 10),
                        if (widget.isEditMode == false)
                        invoiceCopy(),
                        const SizedBox(height: 40),
                        submitButtonWidget(state),
                      ],
                    ),
                  ),
                if (state is AddAssetCategoryLoadingState )
                  WorkplaceWidgets.progressLoader(context),
                ],
              ),
            );
          },
        ),
      )
    );
  }
}

