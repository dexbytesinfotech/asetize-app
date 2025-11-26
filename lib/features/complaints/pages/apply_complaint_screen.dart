import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../account_books/pages/member_screen.dart';
import '../../presentation/widgets/drop_down_widget.dart';
import '../bloc/complaint_bloc/complaint_bloc.dart';
import '../bloc/complaint_bloc/complaint_event.dart';
import '../bloc/complaint_bloc/complaint_state.dart';
import '../bloc/house_block_bloc/house_block_bloc.dart';
import '../models/complaint_category_model.dart';

class ApplyComplaintScreen extends StatefulWidget {
  const ApplyComplaintScreen({super.key});

  @override
  State<ApplyComplaintScreen> createState() => _ApplyComplaintScreenState();
}

class _ApplyComplaintScreenState extends State<ApplyComplaintScreen> {
  late ComplaintBloc complaintBloc;
  late HouseBlockBloc houseBlockBloc;
  String? valueChoose;
  int? userId;
  int currentBlockIndex = 0;
  String compliantTypeErrorMessage = '';
  String imageErrorMessage = '';
  String selectCompliantType = '';
  List<DropdownMenuItem<String>> compliantTypes = [];

  List<CategoryData> categoryList = [];

  String blockErrorMessage = '';
  String selectBlockType = '';

  List<DropdownMenuItem<String>> blockList = [];
  List<String> newBlockList = [];
  String floorErrorMessage = '';
  String selectFloorType = '';
  List<DropdownMenuItem<String>> floorList = [];
  List<String> floorList2 = [];
  List<String> newFloorList = [];

  File? selectProfilePhoto;
  String? selectProfilePhotoPath;
  Map<String, File>? imageFile;
  Map<String, String>? imagePath;
  OverlayEntry? overlayEntry;
  bool isImageSelected = false;

  Map<String, TextEditingController> controllers = {
    'complaint': TextEditingController(),
    'member': TextEditingController(),
    'complaintType': TextEditingController(),
    'block': TextEditingController(),
    'floor': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'complaint': FocusNode(),
    'member': FocusNode(),
    'complaintType': FocusNode(),
    'block': FocusNode(),
    'floor': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'complaint': "",
    'member': "",
    'complaintType': "",
    'block': "",
    'floor': "",
  };

  @override
  void initState() {
    complaintBloc = BlocProvider.of<ComplaintBloc>(context);
    houseBlockBloc = BlocProvider.of<HouseBlockBloc>(context);
    floorList2 = MainAppBloc.houseBlockList[currentBlockIndex].floors ?? [];
    focusNodes['complaint']!.addListener(() {
      if (Platform.isIOS || Platform.isAndroid) {
        bool hasFocus = focusNodes['complaint']!.hasFocus;
        if (hasFocus) {
          showOverlay(context);
        } else {
          removeOverlay();
        }
      }
    });

    /// static data of compliantTypes
    /*compliantTypes = List.generate(
        data.length,
            (index) => DropdownMenuItem(
            value: data[index],
            child:Text(data[index]),));*/

    /// dynamic data from API of compliantTypes
    compliantTypes = List.generate(
        complaintBloc.categoryList.length,
        (index) => DropdownMenuItem(
            value: '${complaintBloc.categoryList[index].id}',
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${complaintBloc.categoryList[index].name}',
                  style: appTextStyle.appNormalSmallTextStyle(),
                ),
              ],
            )));

    blockList = List.generate(
        MainAppBloc.houseBlockList.length,
        (index) => DropdownMenuItem(
              value: MainAppBloc.houseBlockList[index].blockName,
              child: Text(MainAppBloc.houseBlockList[index].blockName ?? ""),
              onTap: () {
                setState(() {
                  currentBlockIndex = index;
                });
              },
            ));
// Add "General" option at the end
    blockList.add(
      DropdownMenuItem(
        value: "General",
        child: Text("General"),
        onTap: () {
          setState(() {
            currentBlockIndex = -1; // Indicate "General" is selected
          });
        },
      ),
    );

    floorList = List.generate(
        MainAppBloc.houseBlockList[currentBlockIndex].totalFloor ?? 0,
        (index) => DropdownMenuItem(
              value: MainAppBloc
                      .houseBlockList[currentBlockIndex].floors?[index] ??
                  "",
              child: Text(MainAppBloc
                      .houseBlockList[currentBlockIndex].floors?[index] ??
                  ""),
            ));

    ///new data in list

    categoryList = List.generate(
      complaintBloc.categoryList.length,
      (index) {
        return complaintBloc.categoryList[index]; // Return the correct type
      },
    );

    newBlockList = List.generate(
      MainAppBloc.houseBlockList.length,
      (index) {
        return MainAppBloc.houseBlockList[index].blockName ??
            ''; // Return the correct type
      },
    );

    super.initState();
  }

  void _removeImage() {
    setState(() {
      selectProfilePhoto = null;
      selectProfilePhotoPath = null;
    });
  }

  bool validateFields({isButtonClicked = false}) {
    if (selectCompliantType.isEmpty) {
      if (isButtonClicked) {
        // setState(() {
        //   compliantTypeErrorMessage = "Please select complaint type";
        // });
      }
      return false;
    } else if (selectBlockType.isEmpty) {
      if (isButtonClicked) {
        // setState(() {
        //   blockErrorMessage = "Please select the block";
        // });
      }
      return false;
    } /*else if (selectFloorType.isEmpty) {
        if (isButtonClicked) {
          setState(() {
            floorErrorMessage = "Please select the floor";
          });
        }
        return false;
      }*/
    else if (controllers['complaint']?.text == null ||
        controllers['complaint']?.text == '') {
      // setState(() {
      //   if (isButtonClicked) {
      //     FocusScope.of(context).requestFocus(focusNodes['complaint']);
      //     errorMessages['complaint'] = 'Please enter the details';
      //   }
      // });
      return false;
    } else if (!Validation.isNotEmpty(controllers['complaint']?.text ?? '')) {
      // setState(() {
      //   if (isButtonClicked) {
      //     FocusScope.of(context).requestFocus(focusNodes['complaint']);
      //     errorMessages['complaint'] =
      //         AppString.trans(context, 'Please enter the details');
      //   }
      // });
      return false;
    }
    //make upload image optional
    /*   else if (selectProfilePhoto == null) {
          if (isButtonClicked) {
            setState(() {
              imageErrorMessage = "Please select upload image";
            });
          }
          return false;
        }*/

    else {
      return true;
    }
  }

  void submitRequest(BuildContext context) async {
    if (validateFields(isButtonClicked: true)) {
      complaintBloc.add(RaiseComplaintEvent(
        mContext: context,
        userId: userId ?? null,
        categoryId: int.parse(selectCompliantType),
        content: controllers['complaint']?.text.trim() ?? "",
        blockName: selectBlockType,
        // floorNumber: selectFloorType.isEmpty ? 0 : int.parse(selectFloorType),
        floorNumber: selectFloorType.isEmpty
            ? 0
            : int.tryParse(selectFloorType.replaceAll(RegExp(r'[^0-9]'), '')) ??
                0, // Extract numeric part
        filePath: selectProfilePhotoPath,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkReason(value, fieldEmail, {onchange = false}) {
      if (Validation.isNotEmpty(value.trim())) {
        setState(() {
          if (Validation.isNotEmpty(value.trim())) {
            errorMessages[fieldEmail] = "";
          } else {
            if (!onchange) {
              errorMessages[fieldEmail] =
                  AppString.trans(context, AppString.emailHintError1);
            }
          }
        });
      } else {
        setState(() {
          if (!onchange) {
            if (fieldEmail == 'complaint') {
              errorMessages[fieldEmail] =
                  AppString.trans(context, AppString.emailHintError);
            }
          }
        });
      }
    }

    Widget complainTypeField() => DropDownDataPicker(
          hint: 'Complaint Type *',
          borderColor:
              compliantTypeErrorMessage != '' ? Colors.red : Colors.transparent,
          itemList: compliantTypes,
          selectedValue: (value) {
            setState(() {
              selectCompliantType = value.toString().split('|').first;

              if (selectCompliantType.isEmpty) {
                compliantTypeErrorMessage = "";
              } else {
                compliantTypeErrorMessage = "";
              }
            });
          },
        );

    Widget blockTypeField() => DropDownDataPicker(
          hint: 'Block *',
          borderColor:
              blockErrorMessage != '' ? Colors.red : Colors.transparent,
          itemList: blockList,
          selectedValue: (value) {
            setState(() {
              selectBlockType = value.toString();
              // floorList2 = houseBlockBloc.houseBlockList[currentBlockIndex].floors ?? [];
              if (selectBlockType == "General") {
                floorList2 = []; // Handle General case
              } else {
                floorList2 =
                    MainAppBloc.houseBlockList[currentBlockIndex].floors ?? [];
              }
              print(floorList);
              if (selectBlockType.isEmpty) {
                blockErrorMessage = "";
              } else {
                blockErrorMessage = "";
              }
            });
          },
        );

    Widget floorTypeField() => floorList2.isEmpty
        ? const SizedBox()
        : Container(
            height: 45,
            padding: const EdgeInsets.only(right: 6),
            margin: const EdgeInsets.only(
              left: 20,
              right: 22,
            ),
            decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(width: 0.8, color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 3,
                      offset: const Offset(0, 1),
                      blurRadius: 3)
                ]),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 10),
              child: DropdownButton<String>(
                  style: appTextStyle.appNormalSmallTextStyle(),
                  alignment: AlignmentDirectional.centerStart,
                  iconEnabledColor: Colors.grey.shade500,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconSize: 28,
                  elevation: 1,
                  isExpanded: true,
                  underline: Container(
                    height: 0.0,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFBDBDBD),
                          width: 0.01,
                        ),
                      ),
                    ),
                  ),
                  dropdownColor: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  hint: Text(
                    "Floor",
                    style: appTextStyle.appNormalSmallTextStyle(
                        color: Colors.grey.shade600),
                  ),
                  isDense: false,
                  value: valueChoose,
                  items: List.generate(
                      floorList2.length ?? 0,
                      (index) => DropdownMenuItem(
                            value: floorList2[index] ?? "",
                            child: Text(floorList2[index] ?? ""),
                          )),
                  onChanged: (value) => setState(() {
                        setState(() {
                          valueChoose = value;
                          int selectedIndex = floorList2.indexOf(value!);
                          selectFloorType = selectedIndex.toString();
                          if (selectFloorType.isEmpty) {
                            floorErrorMessage = "";
                          } else {
                            floorErrorMessage = "";
                          }
                        });
                      })),
            ),
          );

    // void showComplaintBottomSheet(BuildContext context) {
    //   String selectedComplaint = controllers['complaintType']?.text.toString() ?? "";
    //   int? selectCompliantTypeID;
    //   showModalBottomSheet(
    //     context: context,
    //     shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    //     ),
    //     builder: (context) {
    //       return StatefulBuilder(
    //         builder: (context, setState) {
    //           return Container(
    //             decoration: const BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.only(
    //                 topLeft: Radius.circular(15),
    //                 topRight: Radius.circular(15),
    //               ),
    //             ),
    //             padding: const EdgeInsets.all(16),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Padding(
    //                   padding: const  EdgeInsets.only(left: 10,right: 10,bottom: 9),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       GestureDetector(
    //                         onTap: () => Navigator.pop(context),
    //                         child: const  Text(
    //                           "Cancel",
    //                           style: TextStyle(
    //                             fontSize: 18,
    //                             fontWeight: FontWeight.w500,
    //                             color: AppColors.appBlueColor,
    //                           ),
    //                         ),
    //                       ),
    //                       GestureDetector(
    //                         onTap: () {
    //                           setState(() {
    //                             controllers['complaintType']?.text = selectedComplaint.toString();
    //                             selectCompliantType = selectCompliantTypeID.toString();
    //                           });
    //                           Navigator.pop(context);
    //                         },
    //                         child: const Text(
    //                           "Set",
    //                           style: TextStyle(
    //                             fontSize: 18,
    //                             fontWeight: FontWeight.w500,
    //                             color: AppColors.appBlueColor,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 const Divider(height: 0,thickness: 0,),
    //                 const SizedBox(height: 6,),
    //                 ConstrainedBox(
    //                   constraints: BoxConstraints(
    //                     maxHeight: categoryList.length * 60.0 > 240
    //                         ? 240
    //                         : categoryList.length * 60.0,
    //                   ),
    //                   child: ListView.builder(
    //                     padding: EdgeInsets.zero,
    //                     itemCount: categoryList.length,
    //                     itemBuilder: (context, index) {
    //                       final complaintType = categoryList[index].name;
    //                       bool isSelected = selectedComplaint == complaintType;
    //                       return GestureDetector(
    //                         onTap: () {
    //                           setState(() {
    //                             selectedComplaint  = complaintType ?? '';
    //                             selectCompliantTypeID = categoryList[index].id ?? 0;
    //                           });
    //                         },
    //                         child: Container(
    //                           decoration: BoxDecoration(
    //                             border: Border.all(color: isSelected ? AppColors.appBlueColor : Colors.transparent ),
    //                             // color: isSelected ? Colors.blue.shade50 : Colors.transparent,
    //                           ),
    //                           child: ListTile(
    //                             title: Text(
    //                               complaintType ?? '',
    //                               style: const TextStyle(
    //                                 fontSize: 16,
    //                                 fontWeight: FontWeight.w500,
    //                                 color: Colors.black,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           );
    //         },
    //       );
    //     },
    //   );
    // }
    //

    void showComplaintBottomSheet(BuildContext context) {
      WorkplaceWidgets.showCustomAndroidBottomSheet(
        context: context,
        title: AppString.selectComplaintType,
        valuesList: categoryList
            .map((category) => category.name)
            .toList(), // Ensure this is a List<String>
        selectedValue: controllers['complaintType']?.text.toString() ?? "",
        onValueSelected: (value) {
          controllers['complaintType']?.text = value;
          selectCompliantType = categoryList
              .firstWhere((category) => category.name == value)
              .id
              .toString(); // Ensure you get the ID correctly
        },
      );
    }

    void showBlockBottomSheet(BuildContext context) {
      WorkplaceWidgets.showCustomAndroidBottomSheet(
        context: context,
        title: AppString.selectBlock, // Update title to reflect block selection
        valuesList: newBlockList, // Ensure this is a List<String>
        selectedValue: controllers['block']?.text.toString() ?? "",
        onValueSelected: (value) {
          controllers['block']?.text = value; // Set the selected block value
          selectBlockType = value; // Update the selected block type

          // Update the current block index based on the selected block
          int selectedIndex = newBlockList.indexOf(value);
          if (selectedIndex != -1) {
            currentBlockIndex = selectedIndex; // Update the current block index
            floorList2 = MainAppBloc.houseBlockList[currentBlockIndex].floors ??
                []; // Populate floors based on selected block

            // Check if the selected block has floors and update the UI accordingly
            if (floorList2.isNotEmpty) {
              // Show the floor field if there are floors available
              setState(() {
                // This will trigger a rebuild of the widget to show the floor field
              });
            } else {
              // If no floors are available, you might want to hide the floor field
              setState(() {
                floorList2
                    .clear(); // Clear the floor list if no floors are available
              });
            }
          }
        },
      );
    }

    // void showBlockBottomSheet(BuildContext context) {
    //   String selectedBlock = controllers['block']?.text.toString() ?? "";
    //   int currentBlockIndex2 = 0;
    //
    //   showModalBottomSheet(
    //     context: context,
    //     shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    //     ),
    //     builder: (context) {
    //       return StatefulBuilder(
    //         builder: (context, setState) {
    //           return Container(
    //             decoration: const BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.only(
    //                 topLeft: Radius.circular(15),
    //                 topRight: Radius.circular(15),
    //               ),
    //             ),
    //             padding: const EdgeInsets.all(16),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Padding(
    //                   padding: const  EdgeInsets.only(left: 10,right: 10,bottom: 9),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       GestureDetector(
    //                         onTap: () => Navigator.pop(context),
    //                         child: const  Text(
    //                           "Cancel",
    //                           style: TextStyle(
    //                             fontSize: 18,
    //                             fontWeight: FontWeight.w500,
    //                             color: AppColors.appBlueColor,
    //                           ),
    //                         ),
    //                       ),
    //                       GestureDetector(
    //                         onTap: () {
    //                           setState(() {
    //                             controllers['block']?.text = selectedBlock.toString();
    //                             selectBlockType = selectedBlock.toString();;
    //                             floorList2 = MainAppBloc.houseBlockList[currentBlockIndex2].floors ?? [];
    //                           });
    //                           Navigator.pop(context);
    //                         },
    //                         child: const Text(
    //                           "Set",
    //                           style: TextStyle(
    //                             fontSize: 18,
    //                             fontWeight: FontWeight.w500,
    //                             color: AppColors.appBlueColor,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 const Divider(height: 0,thickness: 0,),
    //                 const SizedBox(height: 6,),
    //                 ConstrainedBox(
    //                   constraints: BoxConstraints(
    //                     maxHeight: newBlockList.length * 60.0 > 240
    //                         ? 240
    //                         : newBlockList.length * 60.0,
    //                   ),
    //                   child: ListView.builder(
    //                     padding: EdgeInsets.zero,
    //                     itemCount: newBlockList.length,
    //                     itemBuilder: (context, index) {
    //                       final blockName = newBlockList[index];
    //                       bool isSelected = selectedBlock == blockName;
    //                       return GestureDetector(
    //                         onTap: () {
    //                           setState(() {
    //                             selectedBlock  = blockName ?? '';
    //                             currentBlockIndex2 = index;
    //                           });
    //                         },
    //                         child: Container(
    //                           decoration: BoxDecoration(
    //                             border: Border.all(color: isSelected ? AppColors.appBlueColor : Colors.transparent ),
    //                             // color: isSelected ? Colors.blue.shade50 : Colors.transparent,
    //                           ),
    //                           child: ListTile(
    //                             title: Text(
    //                               blockName ?? '',
    //                               style: const TextStyle(
    //                                 fontSize: 16,
    //                                 fontWeight: FontWeight.w500,
    //                                 color: Colors.black,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           );
    //         },
    //       );
    //     },
    //   );
    // }

    //
    // void showFloorBottomSheet(BuildContext context) {
    //   String selectedComplaint = controllers['floor']?.text.toString() ?? "";
    //   showModalBottomSheet(
    //     context: context,
    //     shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    //     ),
    //     builder: (context) {
    //       return StatefulBuilder(
    //         builder: (context, setState) {
    //           return Container(
    //             decoration: const BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.only(
    //                 topLeft: Radius.circular(15),
    //                 topRight: Radius.circular(15),
    //               ),
    //             ),
    //             padding: const EdgeInsets.all(16),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Padding(
    //                   padding: const  EdgeInsets.only(left: 10,right: 10,bottom: 9),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       GestureDetector(
    //                         onTap: () => Navigator.pop(context),
    //                         child: const  Text(
    //                           "Cancel",
    //                           style: TextStyle(
    //                             fontSize: 18,
    //                             fontWeight: FontWeight.w500,
    //                             color: AppColors.appBlueColor,
    //                           ),
    //                         ),
    //                       ),
    //                       GestureDetector(
    //                         onTap: () {
    //                           setState(() {
    //                             controllers['floor']?.text = selectedComplaint.toString();
    //                           });
    //                           Navigator.pop(context);
    //                         },
    //                         child: const Text(
    //                           "Set",
    //                           style: TextStyle(
    //                             fontSize: 18,
    //                             fontWeight: FontWeight.w500,
    //                             color: AppColors.appBlueColor,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 const Divider(height: 0,thickness: 0,),
    //                 const SizedBox(height: 6,),
    //                 ConstrainedBox(
    //                   constraints: BoxConstraints(
    //                     maxHeight: floorList2.length * 60.0 > 240
    //                         ? 240
    //                         : floorList2.length * 60.0,
    //                   ),
    //                   child: ListView.builder(
    //                     padding: EdgeInsets.zero,
    //                     itemCount: floorList2.length,
    //                     itemBuilder: (context, index) {
    //                       final complaintType = floorList2[index];
    //                       bool isSelected = selectedComplaint == complaintType;
    //                       return GestureDetector(
    //                         onTap: () {
    //                           setState(() {
    //                             selectedComplaint  = complaintType ?? '';
    //                           });
    //                         },
    //                         child: Container(
    //                           decoration: BoxDecoration(
    //                             border: Border.all(color: isSelected ? AppColors.appBlueColor : Colors.transparent ),
    //                             // color: isSelected ? Colors.blue.shade50 : Colors.transparent,
    //                           ),
    //                           child: ListTile(
    //                             title: Text(
    //                               complaintType ?? '',
    //                               style: const TextStyle(
    //                                 fontSize: 16,
    //                                 fontWeight: FontWeight.w500,
    //                                 color: Colors.black,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           );
    //         },
    //       );
    //     },
    //   );
    // }

    void showFloorBottomSheet(BuildContext context) {
      WorkplaceWidgets.showCustomAndroidBottomSheet(
        context: context,
        title: AppString.selectFloor, // Update title to reflect floor selection
        valuesList:
            floorList2, // Ensure this is a List<String> populated with floors
        selectedValue: controllers['floor']?.text.toString() ?? "",
        onValueSelected: (value) {
          controllers['floor']?.text = value; // Set the selected floor value
          selectFloorType = value; // Update the selected floor type
        },
      );
    }

    complaintField() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
        child: CommonTextFieldWithError(
          inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),
          onTapCallBack: () {
            showComplaintBottomSheet(context);
          },
          readOnly: true,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.selectComplaintType,
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
          focusNode: focusNodes['complaintType'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['complaintType']?.toString() ?? '',
          controllerT: controllers['complaintType'],
          borderRadius: 8,
          inputHeight: 45,
          errorLeftRightMargin: 0,
          maxCharLength: 500,
          errorMsgHeight: 18,
          maxLines: 1,
          autoFocus: false,
          showError: true,
          showCounterText: false,
          capitalization: CapitalizationText.sentences,
          cursorColor: Colors.grey,
          enabledBorderColor: Colors.white,
          focusedBorderColor: Colors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.newline,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.multiLine,
          hintText: AppString.selectComplaintType,
          contentPadding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          onTextChange: (value) {},
          onEndEditing: (value) {},
        ),
      );
    }

    blockField() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
        child: CommonTextFieldWithError(
          inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),
          onTapCallBack: () {
            showBlockBottomSheet(context);
          },
          readOnly: true,
          focusNode: focusNodes['block'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['block']?.toString() ?? '',
          controllerT: controllers['block'],
          borderRadius: 8,
          inputHeight: 45,
          errorLeftRightMargin: 0,
          maxCharLength: 500,
          errorMsgHeight: 18,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          maxLines: 1,
          placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.selectBlock,
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
          autoFocus: false,
          showError: true,
          showCounterText: false,
          capitalization: CapitalizationText.sentences,
          cursorColor: Colors.grey,
          enabledBorderColor: Colors.white,
          focusedBorderColor: Colors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.newline,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.multiLine,
          hintText: AppString.selectBlock,
          contentPadding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          onTextChange: (value) {},
          onEndEditing: (value) {},
        ),
      );
    }

    floorField() => floorList2.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
            child: CommonTextFieldWithError(
              inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),
              onTapCallBack: () {
                showFloorBottomSheet(context);
              },
              readOnly: true,
              focusNode: focusNodes['floor'],
              isShowBottomErrorMsg: true,
              errorMessages: errorMessages['floor']?.toString() ?? '',
              controllerT: controllers['floor'],
              borderRadius: 8,
              inputHeight: 45,
              errorLeftRightMargin: 0,
              maxCharLength: 500,
              errorMsgHeight: 18,
              maxLines: 1,
              autoFocus: false,
              showError: true,
              showCounterText: false,
              capitalization: CapitalizationText.sentences,
              cursorColor: Colors.grey,
              enabledBorderColor: Colors.white,
              focusedBorderColor: Colors.white,
              backgroundColor: AppColors.white,
              textInputAction: TextInputAction.newline,
              borderStyle: BorderStyle.solid,
              inputKeyboardType: InputKeyboardTypeWithError.multiLine,
              hintText: AppString.selectFloor,
              placeHolderTextWidget: Padding(
                  padding: const EdgeInsets.only(left: 3.0, bottom: 3),
                  child: Text.rich(
                    TextSpan(
                      text: AppString.selectFloor,
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
              hintStyle: appStyles.hintTextStyle(),
              textStyle: appStyles.textFieldTextStyle(),
              contentPadding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 10),
              onTextChange: (value) {},
              onEndEditing: (value) {},
            ),
          );

    Widget dropdownRow() => Row(
          children: [
            // Flexible(child: blockTypeField()),
            // Flexible(child: floorTypeField())
            Flexible(child: blockField()),
            Flexible(child: floorField())
          ],
        );

    Widget complaintErrorText() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              (compliantTypeErrorMessage != '')
                  ? Container(
                      padding: const EdgeInsets.only(left: 2, top: 2),
                      height: 18,
                      child: Text(
                        compliantTypeErrorMessage,
                        style: appStyles.errorStyle(),
                      ))
                  : Container(height: 0.5),
            ],
          ),
        );

    Widget blockErrorText() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              (blockErrorMessage != '')
                  ? Container(
                      padding: const EdgeInsets.only(left: 2, top: 2),
                      height: 18,
                      child: Text(
                        blockErrorMessage,
                        style: appStyles.errorStyle(),
                      ))
                  : Container(height: 0.5),
            ],
          ),
        );

    Widget imageErrorText() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              (imageErrorMessage != '')
                  ? Container(
                      padding: const EdgeInsets.only(left: 2, top: 2),
                      height: 18,
                      child: Text(
                        imageErrorMessage,
                        style: appStyles.errorStyle(),
                      ))
                  : Container(height: 0.5),
            ],
          ),
        );

    Widget floorErrorText() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              (floorErrorMessage != '')
                  ? Container(
                      padding: const EdgeInsets.only(left: 2, top: 2),
                      height: 18,
                      child: Text(
                        floorErrorMessage,
                        style: appStyles.errorStyle(),
                      ))
                  : Container(height: 0.5),
            ],
          ),
        );

    Widget dropError() => Row(
          children: [
            Flexible(child: blockErrorText()),
            Flexible(child: floorErrorText())
          ],
        );

    reasonField() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(left: 18, right: 18, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextFieldWithError(
              focusNode: focusNodes['complaint'],
              isShowBottomErrorMsg: true,
              errorMessages: errorMessages['complaint']?.toString() ?? '',
              controllerT: controllers['complaint'],
              borderRadius: 8,
              inputHeight: 140,
              errorLeftRightMargin: 0,
              maxCharLength: 500,
              errorMsgHeight: 18,
              minLines: 5,
              maxLines: 5,
              autoFocus: false,
              showError: true,
              showCounterText: false,
              capitalization: CapitalizationText.sentences,
              cursorColor: Colors.grey,
              enabledBorderColor: Colors.white,
              focusedBorderColor: Colors.white,
              backgroundColor: AppColors.white,
              textInputAction: TextInputAction.newline,
              borderStyle: BorderStyle.solid,
              inputKeyboardType: InputKeyboardTypeWithError.multiLine,
              placeHolderTextWidget: Padding(
                  padding: const EdgeInsets.only(left: 3.0, bottom: 3),
                  child: Text.rich(
                    TextSpan(
                      text: AppString.description,
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
              hintText: AppString.description,
              hintStyle: appStyles.hintTextStyle(),textStyle: appStyles.textFieldTextStyle(),
              contentPadding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 10),
              onTextChange: (value) {
                checkReason(value, 'complaint', onchange: true);
              },
              onEndEditing: (value) {
                checkReason(value, 'complaint');
                FocusScope.of(context).requestFocus(focusNodes['password']);
              },
            ),
          ],
        ),
      );
    }

    bottomButton(state) {
      return Container(
          margin:
              const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 20),
          child: AppButton(
            buttonName: AppString.submitButton,
            isLoader: state is ComplaintLoadingState ? true: false,
            buttonColor:
                (validateFields()) ? AppColors.textBlueColor : Colors.grey,
            textStyle: appStyles.buttonTextStyle1(
              texColor: AppColors.white,
            ),
            backCallback: () =>
                (validateFields()) ? submitRequest(context) : null,
          ));
    }

    void photoPickerBottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (context1) => PhotoPickerBottomSheet(
          isRemoveOptionNeeded: false,
          removedImageCallBack: () {
            Navigator.pop(context1);
            setState(() {
              selectProfilePhotoPath = "";
              isImageSelected = false;
            });
          },
          selectedImageCallBack: (fileList) {
            try {
              if (fileList != null && fileList.isNotEmpty) {
                fileList.map((fileDataTemp) {
                  File imageFileTemp = File(fileDataTemp.path);
                  selectProfilePhoto = imageFileTemp;
                  selectProfilePhotoPath = selectProfilePhoto!.path;
                  isImageSelected = true;
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
                  imageErrorMessage = '';
                  String mapKey =
                      DateTime.now().microsecondsSinceEpoch.toString();
                  imageFile![mapKey] = imageFileTemp;
                  imagePath![mapKey] = imageFileTemp.path;
                }).toList(growable: false);
                setState(() {});
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
                isImageSelected = true;
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
                imageErrorMessage = '';
                String mapKey =
                    DateTime.now().microsecondsSinceEpoch.toString();
                imageFile![mapKey] = imageFileTemp;
                imagePath![mapKey] = imageFileTemp.path;
                setState(() {});
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
              top: Radius.circular(photoPickerBottomSheetCardRadius)),
        ),
      );
    }

    imageUpload() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 10),
            child: Text(
             AppString.uploadImageOptional,
              style: appStyles.texFieldPlaceHolderStyle(),
            ),
          ),
          GestureDetector(
            onTap: () => photoPickerBottomSheet(),
            child: Padding(
              padding: const EdgeInsets.all(18.0).copyWith(top: 0, bottom: 0),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(width: 0.8, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 3,
                          offset: const Offset(0, 1),
                          blurRadius: 3)
                    ]),
                padding: const EdgeInsets.all(8)
                    .copyWith(top: 0, bottom: 0, left: 0),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          border:
                              Border.all(width: 0.8, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 3,
                                offset: const Offset(0, 1),
                                blurRadius: 3)
                          ]),
                      child: Stack(
                        children: [
                          if (selectProfilePhoto != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  Image.file(
                                    selectProfilePhoto!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: _removeImage,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(15),
                                      margin: const EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          shape: BoxShape.circle),
                                      child: const Icon(Icons.image,
                                          size: 24, color: Colors.grey)),
                                  Text(
                                    'Upload',
                                    style: appStyles.userJobTitleTextStyle(
                                        fontSize: 14,
                                        texColor: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Allowed types: jpeg, png, jpg',
                              style: appStyles.userJobTitleTextStyle(
                                  fontSize: 14,
                                  texColor: Colors.grey.shade600)),
                          const SizedBox(
                            height: 2,
                          ),
                          Text('Up to 5MB size',
                              style: appStyles.userJobTitleTextStyle(
                                  fontSize: 14,
                                  texColor: Colors.grey.shade600)),
                          const SizedBox(
                            height: 2,
                          ),
                          Text('Maximum of 1 image',
                              style: appStyles.userJobTitleTextStyle(
                                  fontSize: 14,
                                  texColor: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    memberField() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
        child: CommonTextFieldWithError(
          inputFieldSuffixIcon: WorkplaceWidgets.downArrowIcon(),
          onTapCallBack: () {
            Navigator.push(
                    context, SlideLeftRoute(widget: const MemberScreen()))
                .then((value) {
              try {
                controllers['member']?.text = value.name.toString() ?? '';
                userId = value.id;
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }
            });
          },
          readOnly: true,
          focusNode: focusNodes['member'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['member']?.toString() ?? '',
          controllerT: controllers['member'],
          borderRadius: 8,
          inputHeight: 45,
          errorLeftRightMargin: 0,
          maxCharLength: 500,
          errorMsgHeight: 18,
          maxLines: 1,
          placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.selectMember,
                  style: appStyles.texFieldPlaceHolderStyle(),
                  children: const [
                    // TextSpan(
                    //   text: ' *',
                    //   style: appStyles
                    //       .texFieldPlaceHolderStyle()
                    //       .copyWith(color: Colors.red),
                    // ),
                  ],
                ),
                textAlign: TextAlign.start,
              )),
          autoFocus: false,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          showError: true,
          showCounterText: false,
          capitalization: CapitalizationText.sentences,
          cursorColor: Colors.grey,
          enabledBorderColor: Colors.white,
          focusedBorderColor: Colors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.newline,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.multiLine,
          hintText: AppString.selectMember,
          contentPadding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          onTextChange: (value) {
            // checkParty(value, 'party', onchange: true);
          },
          onEndEditing: (value) {
            // checkParty(value, 'party');
            FocusScope.of(context).requestFocus(focusNodes['']);
          },
        ),
      );
    }

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      scrollingOnKeyboardOpen: true,
      appBarHeight: 50,
      appBar: const CommonAppBar(
        title: AppString.addNewComplaint,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<ComplaintBloc, ComplaintState>(
        bloc: complaintBloc,
        listener: (BuildContext context, ComplaintState state) {
          if (state is ComplaintRaisedDoneState) {
            Navigator.pop(context, true);

            WorkplaceWidgets.successToast(
                AppString.applicationSubmittedSuccessfully,
                durationInSeconds: 1);
            //   complaintBloc.add(FetchComplaintOpenDataEvent(mContext: context, status: 'open'));
          }
          if (state is ComplaintErrorState) {
            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
            Navigator.pop(context);
          }
        },
        child: Column(
          children: [
            BlocBuilder<ComplaintBloc, ComplaintState>(
              builder: (BuildContext context, state) {
                return Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (AppPermission.instance.canPermission(
                            AppString.managerComplaintAdd,
                            context: context))
                          const SizedBox(
                            height: 5,
                          ),
                          memberField(),
                        // complainTypeField(),
                        // complaintErrorText(),
                        complaintField(),
                        dropdownRow(),
                        reasonField(),

                        imageUpload(),
                        bottomButton(state),
                        //imageErrorText(),
                      ],
                    ),
                    // if (state is ComplaintLoadingState)
                    //   WorkplaceWidgets.progressLoader(context),
                  ],
                );
              },
            ),


          ],
        ),
      ),
    );
  }

  onPressCallback() {
    removeOverlay();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  //for keyboard done button

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom >
                  0 // Check if keyboard is open
              ? MediaQuery.of(context).viewInsets.bottom
              : -100, // Position off-screen when keyboard is not open
          right: 0.0,
          left: 0.0,
          child: InputDoneView(
            onPressCallback: onPressCallback,
            buttonName: "Done",
          ));
    });

    overlayState.insert(overlayEntry!);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }
}
