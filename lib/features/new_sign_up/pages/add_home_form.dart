import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asetize/features/new_sign_up/bloc/new_signup_bloc.dart';
import 'package:asetize/imports.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../complaints/models/house_bloc_model.dart';
import '../bloc/new_signup_event.dart';
import '../bloc/new_signup_state.dart';
import 'search_your_society.dart';

class SearchYourSocietyForm extends StatefulWidget {
  final bool? isSocietyNotFound;
  const SearchYourSocietyForm({super.key, this.isSocietyNotFound});

  @override
  State<SearchYourSocietyForm> createState() => SearchYourSocietyFormState();
}

class SearchYourSocietyFormState extends State<SearchYourSocietyForm> {
  late NewSignupBloc newSignupBloc;

  final TextEditingController _societyController = TextEditingController();
  final ValueNotifier<String?> dropdownController = ValueNotifier<String?>(null);
  final TextEditingController _flatNoController = TextEditingController();
  final FocusNode _flatNoFocusNode = FocusNode();

  Map<String, String> errorMessages = {
    'society': "",
    'block': "",
    'flatNo': "",
  };

  Map<String, TextEditingController> controllers = {
    'block': TextEditingController(),
  };
  Map<String, FocusNode> focusNodes = {
    'block': FocusNode(),
  };

  bool isButtonVisible = false;
  bool isYouAreVisible = false;
  bool isBlockVisible = false;
  bool isFlatNoVisible = false;
  bool isSubmitButtonVisible = false;

  int? selectedSocietyId;
  int? selectedSocietyBlockId;
  int? selectedSocietyFlatNumberId;

  String? selectedOption;
  String blockErrorMessage = '';
  String? selectBlockType;
  String? selectBlockTypeId;
  String houseErrorMessage = '';
  String? selectHouseType;
  int? selectHouseTypeId;

  List<String> filteredFlatNumbers = [];

  bool validateFields({isButtonClicked = false}) {
    if (_societyController.text.isEmpty) {
      if (isButtonClicked) {
        setState(() {
          errorMessages['society'] = AppString.societyRequired;
        });
      }
      return false;
    } else if (isBlockVisible && controllers['block']?.text.isEmpty == true) {
      if (isButtonClicked) {
        setState(() {
          errorMessages['block'] = "Please select block";
        });
      }
      return false;
    } else if (isFlatNoVisible && _flatNoController.text.isEmpty == true) {
      if (isButtonClicked) {
        setState(() {
          errorMessages['flatNo'] = "Please select flat number";
        });
      }
      return false;
    } else if (selectedOption?.isEmpty == true ||
        selectedOption == "" ||
        selectedOption == null) {
      if (isButtonClicked) {
        setState(() {
          errorMessages['flatNo'] = "Please select your role";
        });
      }
      return false;
    }
    return true;
  }

  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  @override
  void initState() {
    newSignupBloc = BlocProvider.of<NewSignupBloc>(context);
    _flatNoController.addListener(_filterFlatNumbers);
    // Add listener to detect when flat number field loses focus
    _flatNoFocusNode.addListener(_handleFlatNoFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    dropdownController.dispose();
    _flatNoController.dispose();
    _flatNoFocusNode.dispose();
    _flatNoController.removeListener(_filterFlatNumbers);
    _flatNoFocusNode.removeListener(_handleFlatNoFocusChange);
    controllers['block']?.dispose();
    focusNodes['block']?.dispose();
    super.dispose();
  }

  void _filterFlatNumbers() {
    final query = _flatNoController.text.toLowerCase();
    setState(() {
      filteredFlatNumbers = newSignupBloc.housesData
          ?.where((house) =>
      house.houseNumber != null &&
          house.houseNumber!.toLowerCase().contains(query))
          .map((house) => house.houseNumber!)
          .toList() ??
          [];
    });
  }

  Widget societyField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        readOnly: true,
        controllerT: _societyController,
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['society'] ?? '',
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 50,
        errorMsgHeight: 24,
        onTapCallBack: () async {
          final selectedSociety = await Navigator.push(
            context,
            SlideLeftRoute(
                widget: SearchYourSociety(
                    isSocietyNotFound: widget.isSocietyNotFound ?? false)),
          );
          if (selectedSociety != true) {
            closeKeyboard();
            setState(() {
              _societyController.text = selectedSociety['name'];
              selectedSocietyId = selectedSociety['id'];
              errorMessages['society'] = "";
              isBlockVisible = true;
              dropdownController.value = null;
              _flatNoController.clear();
              selectedOption = null;
              selectBlockType = "";
              isButtonVisible = true;
              isYouAreVisible = true;
              isFlatNoVisible = true;
              selectBlockType = null;
              selectHouseType = null;
              blockErrorMessage = "";
              houseErrorMessage = "";
              filteredFlatNumbers.clear();
            });
          }
        },
        autoFocus: false,
        showError: true,
        capitalization: CapitalizationText.characters,
        cursorColor: Colors.grey,
        placeHolderTextWidget: Padding(
          padding: const EdgeInsets.only(left: 3.0, bottom: 3),
          child: Text.rich(
            TextSpan(
              text: AppString.society,
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
        inputFieldSuffixIcon: const Padding(
          padding: EdgeInsets.only(right: 18, left: 10),
          child: Icon(Icons.search),
        ),
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.text,
        hintText: AppString.searchYouSocietyName,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 10, right: 15),
        onTextChange: (value) {
          setState(() {
            errorMessages['society'] = "";
          });
        },
        onEndEditing: (value) {
          setState(() {
            errorMessages['society'] = "";
          });
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
    );
  }

  void showBlockBottomSheet(BuildContext context) {
    String selectedBlock = controllers['block']?.text.toString() ?? "";
    String? selectBlockTypeId2;

    WorkplaceWidgets.showCustomAndroidBottomSheet(
      context: context,
      title: 'Select Block / Tower',
      valuesList:
      newSignupBloc.blocksData.map((block) => block.blockName).toList(),
      selectedValue: selectedBlock,
      onValueSelected: (value) {
        setState(() {
          selectedBlock = value;
          selectBlockTypeId2 = newSignupBloc.blocksData
              .firstWhere((block) => block.blockName == value)
              .id
              .toString();
          controllers['block']?.text = selectedBlock;
          selectBlockTypeId = selectBlockTypeId2;
          _flatNoController.clear();
          filteredFlatNumbers.clear();
          errorMessages['block'] = "";
        });
        newSignupBloc.add(
            FindHouseNumberEvent(mContext: context, blockName: selectedBlock));
      },
    );
  }

  Widget newBlockNameField() => Visibility(
    visible: isBlockVisible,
    child: Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        onTapCallBack: () {
          showBlockBottomSheet(context);
        },
        focusNode: focusNodes['block'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['block']?.toString() ?? '',
        readOnly: true,
        controllerT: controllers['block'],
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 10,
        errorMsgHeight: 24,
        autoFocus: false,
        showError: true,
        capitalization: CapitalizationText.none,
        cursorColor: Colors.grey,
        placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 3.0, bottom: 3),
            child: Text.rich(
              TextSpan(
                text: AppString.blockTower,
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
            )),
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.phone,
        hintText: AppString.selectYourBlock,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        inputFieldSuffixIcon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black.withOpacity(0.8),
        ),
        onTextChange: (value) {},
        onEndEditing: (value) {},
      ),
    ),
  );
  void _handleFlatNoFocusChange() {
    if (!_flatNoFocusNode.hasFocus) {
      // When focus is lost, validate the entered text
      final enteredText = _flatNoController.text.trim();
      final isValidFlatNumber = newSignupBloc.housesData?.any((house) =>
      house.houseNumber != null &&
          house.houseNumber!.toLowerCase() == enteredText.toLowerCase()) ??
          false;

      if (!isValidFlatNumber && enteredText.isNotEmpty) {
        setState(() {
          _flatNoController.clear();
          filteredFlatNumbers.clear();
          selectHouseType = null;
          selectHouseTypeId = null;
          errorMessages['flatNo'] = 'Please select a valid flat number';
        });
      } else if (isValidFlatNumber) {
        // If valid, set the selection
        final selectedHouse = newSignupBloc.housesData!.firstWhere(
              (house) => house.houseNumber!.toLowerCase() == enteredText.toLowerCase(),
        );
        setState(() {
          _flatNoController.text = selectedHouse.houseNumber!;
          selectHouseType = selectedHouse.houseNumber;
          selectHouseTypeId = selectedHouse.id;
          errorMessages['flatNo'] = '';
          filteredFlatNumbers.clear();
        });
      }
    }
  }
  Widget newHouseNumberField() => Visibility(
    visible: isFlatNoVisible,
    child: Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextFieldWithError(
                focusNode: _flatNoFocusNode,
                isShowBottomErrorMsg: true,
                errorMessages: errorMessages['flatNo']?.toString() ?? '',
                readOnly: false,
                controllerT: _flatNoController,
                borderRadius: 8,
                inputHeight: 50,
                errorLeftRightMargin: 0,
                maxCharLength: 10,
                errorMsgHeight: 24,
                autoFocus: false,
                showError: true,
                capitalization: CapitalizationText.characters,
                cursorColor: Colors.grey,
                placeHolderTextWidget: Padding(
                  padding: const EdgeInsets.only(left: 3.0, bottom: 3),
                  child: Text.rich(
                    TextSpan(
                      text: AppString.flatNumberHint,
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
                enabledBorderColor: AppColors.white,
                focusedBorderColor: AppColors.white,
                backgroundColor: AppColors.white,
                textInputAction: TextInputAction.done,
                borderStyle: BorderStyle.solid,
                inputKeyboardType: InputKeyboardTypeWithError.text,
                hintText: AppString.flatNumberHint,
                hintStyle: appStyles.hintTextStyle(),
                textStyle: appStyles.textFieldTextStyle(),
                contentPadding: const EdgeInsets.only(left: 15, right: 15),
                // inputFieldSuffixIcon: Icon(
                //   Icons.keyboard_arrow_down,
                //   color: Colors.black.withOpacity(0.8),
                // ),
                onTextChange: (value) {
                  setState(() {
                    errorMessages['flatNo'] = '';
                    _filterFlatNumbers();
                  });
                },
                onEndEditing: (value) {
                  // Optional: Keep this for additional safety, but _handleFlatNoFocusChange handles the main logic
                  if (value.isEmpty) {
                    setState(() {
                      selectHouseType = null;
                      selectHouseTypeId = null;
                      errorMessages['flatNo'] = '';
                      filteredFlatNumbers.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ),
        if (_flatNoFocusNode.hasFocus && _flatNoController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 3,
                    offset: const Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: filteredFlatNumbers.isEmpty
                  ? Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: Text(
                 AppString.noFlatNumberFound,
                               style: appTextStyle.noDataTextStyle(),
  ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero.copyWith(
                    bottom: filteredFlatNumbers.length <= 3 ? 0 : 50),
                itemCount: filteredFlatNumbers.length,
                itemBuilder: (context, index) {
                  final flatNumber = filteredFlatNumbers[index];
                  return ListTile(
                    title: Text(
                      flatNumber,
                      style: appStyles.textFieldTextStyle(),
                    ),
                    onTap: () {
                      setState(() {
                        _flatNoController.text = flatNumber;
                        selectHouseTypeId = newSignupBloc.housesData
                            ?.firstWhere((house) =>
                        house.houseNumber == flatNumber)
                            .id;
                        selectHouseType = flatNumber;
                        isYouAreVisible = true;
                        errorMessages['flatNo'] = '';
                        filteredFlatNumbers.clear();
                        _flatNoFocusNode.unfocus();
                      });
                    },
                  );
                },
              ),
            ),
          ),
      ],
    ),
  );  Widget selectYouAre() {
    final options = ['Owner', 'Tenant'];
    Widget buildOption(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: title,
              activeColor: AppColors.appBlueColor,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                  errorMessages['flatNo'] = '';
                });
              },
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      );
    }

    return Visibility(
      visible: isYouAreVisible,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text.rich(
              TextSpan(
                text: AppString.registerAs,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: options.map(buildOption).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget submitButton(state) {
    return Visibility(
      visible: isButtonVisible,
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: AppButton(
          buttonName: AppString.submitButton,
          buttonColor:
          validateFields() ? AppColors.textBlueColor : Colors.grey,
          isLoader: state is GuestProfileBackgroundLoadingState ? true : false,
          backCallback: () {
            if (validateFields()) {
              newSignupBloc.add(OnGuestCompanyJoinEvent(
                  mContext: context,
                  companyId: selectedSocietyId,
                  blockId: int.parse(selectBlockTypeId!),
                  houseId: selectHouseTypeId,
                  role: selectedOption!.toLowerCase()));
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
      contextCurrentView: context,
      isFixedDeviceHeight: true,
      appBarHeight: 56,
      appBar: const CommonAppBar(
        title: AppString.addHome,
      ),
      containChild: BlocListener<NewSignupBloc, NewSignupState>(
          listener: (context, state) {
            if (state is GuestCompanyJoinDoneState) {
              newSignupBloc.add(OnGetProfileBackgroundEvent(
                  mContext: context, selectedCompanyId: null));
            }
            if (state is GuestProfileBackgroundDoneState) {
              context.go('/dashBoard');
            }
            if (newSignupBloc.housesData?.isEmpty == true &&
                state is FindHouseNumberDoneState) {
              WorkplaceWidgets.errorSnackBar(context, AppString.noFlatErrorMessage);
            }
            if (state is GuestCompanyJoinErrorState) {
              WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            }
          },
          child: BlocBuilder<NewSignupBloc, NewSignupState>(
            bloc: newSignupBloc,
            builder: (context, state) {
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        societyField(),
                        newBlockNameField(),
                        newHouseNumberField(),
                        selectYouAre(),
                        submitButton(state),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}