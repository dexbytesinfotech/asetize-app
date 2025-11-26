import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asetize/features/presentation/presentation.dart';

import '../../../core/util/app_theme/app_color.dart';
import '../../../core/util/app_theme/app_string.dart';
import '../../../core/util/app_theme/app_style.dart';
import '../../../core/util/workplace_icon.dart';
import '../bloc/new_signup_bloc.dart';
import '../models/guest_search_by_model.dart';

class SearchYourFlat extends StatefulWidget {
  const SearchYourFlat({Key? key}) : super(key: key);

  @override
  SearchYourFlatState createState() => SearchYourFlatState();
}

class SearchYourFlatState extends State<SearchYourFlat> {

  late NewSignupBloc newSignupBloc;


  List<Houses2> filteredSocieties = [];
  String searchQuery = '';
  final TextEditingController _societyController = TextEditingController();
  final Map<String, String> errorMessages = {'society': ''};

  @override
  void initState() {
    super.initState();
    // Initially, all flatList are displayed
    newSignupBloc = BlocProvider.of<NewSignupBloc>(context);

    filteredSocieties = newSignupBloc.guestSearchByData.first.blocks!.first.houses!;
  }

  void _filterSocieties(String query) {
    if (query.isEmpty) {
      // If the search query is empty, show all flatList
      setState(() {
        filteredSocieties = newSignupBloc.guestSearchByData.first.blocks!.first.houses!;
      });
    } else {
      // Filter flatList based on the search query
      setState(() {
        filteredSocieties = newSignupBloc.guestSearchByData.first.blocks!.first.houses!
            .where((society) => society.houseNumber!.contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    Widget searchBlock(){
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
          // onTapCallBack: () async {
          //   final selectedSociety = await Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => const SocietySelectionScreen()),
          //   );
          //   if (selectedSociety != null) {
          //     setState(() {
          //       _societyController.text = selectedSociety;
          //       errorMessages['society'] = "";
          //     });
          //   }
          // },
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.characters,
          cursorColor: Colors.grey,
          // placeHolderTextWidget: Padding(
          //   padding: const EdgeInsets.only(left: 3.0, bottom: 3),
          //   child: Text.rich(
          //     TextSpan(
          //       text: AppString.society,
          //       style: appStyles.texFieldPlaceHolderStyle(),
          //       children: [
          //         TextSpan(
          //           text: '*',
          //           style: appStyles.texFieldPlaceHolderStyle().copyWith(color: Colors.red),
          //         ),
          //       ],
          //     ),
          //     textAlign: TextAlign.start,
          //   ),
          // ),
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
          hintText: AppString.searchYourFlatNumber,
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

    Widget listOfBlock(){
      return   Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredSocieties.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(filteredSocieties[index].houseNumber??''),
              onTap: () {
                Navigator.pop(context, {
                  'id': filteredSocieties[index].id,
                  'blockName': filteredSocieties[index].houseNumber,
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
        title: AppString.searchFlatNumber,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: SingleChildScrollView(
        child: Column(
          children: [
            searchBlock(),
            listOfBlock()
          ],
        ),
      ),
    );
  }
}
