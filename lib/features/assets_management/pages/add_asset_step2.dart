// add_asset_step2.dart
import '../../../imports.dart';
import '../../booking/pages/new_booking_request.dart';
import '../../booking/widgets/label_widget.dart';
import '../bloc/assets_management_bloc.dart';
import '../model/assets_list_model.dart';
import 'package:intl/intl.dart';


class AddAssetStep2 extends StatefulWidget {
  final bool isEditMode;
  final AssetListData? detailData;
  final Map<String, dynamic> initialData;
  final VoidCallback onBack;
  final Function(Map<String, dynamic>) onNext;

  const AddAssetStep2({
    super.key,
    required this.isEditMode,
    this.detailData,
    required this.initialData,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<AddAssetStep2> createState() => _AddAssetStep2State();
}

class _AddAssetStep2State extends State<AddAssetStep2> {
  late AssetsManagementBloc assetsManagementBloc;
  DateTime? _selectedWarrantyDate;

  String? selectedWarrantyMonths;

  List<String> filteredLocations = [];
  final List<String> _warrantyMonths = ['1 Month', '3 Months', '6 Months', '12 Months', '18 Months', '24 Months', '36 Months'];

  @override
  void initState() {
    assetsManagementBloc = BlocProvider.of<AssetsManagementBloc>(context);
    super.initState();
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
  // Reuse same controllers from Step1 via widget.initialData or pass via provider/bloc
  // For simplicity, we re-use the same controller map pattern

  @override
  Widget build(BuildContext context) {


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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          warrantyMonthsWidget(),
          const SizedBox(height: 15),
          modelNumberWidget(),
          const SizedBox(height: 15),
          manufacturerWidget(),
          const SizedBox(height: 15),
          longDescriptionsWidget(),
          const SizedBox(height: 15),
          assetLocationWidget(),
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
                  buttonName: "Next",
                  buttonColor: AppColors.appBlueColor,
                  backCallback: () {
                    widget.onNext({
                      'warrantyDate': _selectedWarrantyDate,
                      'modelNumber': controllers['modelNumber']!.text.trim(),
                      'manufacturer': controllers['manufacturer']!.text.trim(),
                      'longDescription': controllers['longDescriptions']!.text.trim(),
                      'assetLocation': controllers['assetLocation']!.text.trim(),
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}