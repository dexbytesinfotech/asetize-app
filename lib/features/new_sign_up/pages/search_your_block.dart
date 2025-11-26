import 'package:flutter/material.dart';
import 'package:asetize/features/presentation/presentation.dart';

import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/app_string.dart';
import '../../../core/util/app_theme/app_style.dart';
import '../../../core/util/workplace_icon.dart';
import '../../../imports.dart';
import '../bloc/new_signup_bloc.dart';
import '../bloc/new_signup_state.dart';
import '../models/guest_search_by_model.dart';

class SearchYourBlock extends StatefulWidget {
  const SearchYourBlock({Key? key}) : super(key: key);

  @override
  _SearchYourBlockState createState() => _SearchYourBlockState();
}

class _SearchYourBlockState extends State<SearchYourBlock> {
  late NewSignupBloc newSignupBloc;

  List<Blocks>? filteredSocieties = [];
  String searchQuery = '';
  final TextEditingController _societyController = TextEditingController();
  final Map<String, String> errorMessages = {'society': ''};

  @override
  void initState() {
    super.initState();
    // Initially, all blockList are displayed
    newSignupBloc = BlocProvider.of<NewSignupBloc>(context);

    filteredSocieties = newSignupBloc.guestSearchByData.first.blocks;
  }

  void _filterSocieties(String query) {
    if (query.isEmpty) {
      // If the search query is empty, show all blockList
      setState(() {
        filteredSocieties = newSignupBloc.guestSearchByData.first.blocks; // Reset to original list
      });
    } else {
      // Filter blockList based on the search query
      setState(() {
        filteredSocieties = newSignupBloc.guestSearchByData.first.blocks!
            .where((society) => society.blockName!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBlock() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          controllerT: _societyController,
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['society'] ?? '',
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 50,
          errorMsgHeight: 24,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.characters,
          cursorColor: Colors.grey,
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
          hintText: AppString.searchYouBlock,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            searchQuery = value;
            _filterSocieties(searchQuery);
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

    Widget listOfBlock() {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredSocieties?.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(filteredSocieties![index].blockName ?? ''),
              onTap: () {
                // Pop the selected block's id and name
                Navigator.pop(context, {
                  'id': filteredSocieties![index].id,
                  'blockName': filteredSocieties![index].blockName,
                });
              },
            );
          },
        ),
      );
    }

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: true,
      isListScrollingNeed: false,
      isOverLayStatusBar: false,
      appBarHeight: 56,
      appBar: const CommonAppBar(
        title: AppString.searchBlock,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<NewSignupBloc, NewSignupState>(
        listener: (context, state) {
          if (state is GuestSearchByCompanyDoneState) {

          }
          if (state is GuestSearchByCompanyErrorState) {

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
                      searchBlock(),
                      listOfBlock()
                    ],
                  ),
                  if (state is SignupLoadingState)
                    Center(
                      child: WorkplaceWidgets.progressLoader(context),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}