import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../bloc/new_signup_bloc.dart';
import '../bloc/new_signup_event.dart';
import '../bloc/new_signup_state.dart';
import '../models/guest_search_by_model.dart';
import 'request_for_add_new_society.dart';

class SearchYourSociety extends StatefulWidget {
  final bool isSocietyNotFound;
  const SearchYourSociety({super.key, this.isSocietyNotFound = false});

  @override
  _SearchYourSocietyState createState() => _SearchYourSocietyState();
}

class _SearchYourSocietyState extends State<SearchYourSociety> {
  late NewSignupBloc newSignupBloc;
  String searchQuery = '';
  final TextEditingController _societyController = TextEditingController();
  final Map<String, String> errorMessages = {'society': ''};
  List<GuestSearchByData> filteredSocieties = [];
  bool show = false;

  @override
  void initState() {
    super.initState();
    newSignupBloc = BlocProvider.of<NewSignupBloc>(context);
    newSignupBloc.guestSearchByData.clear();
  }

  void _filterSocieties(String query) {
    if (query.isEmpty) {
      filteredSocieties = newSignupBloc.guestSearchByData;
    } else {
      filteredSocieties = newSignupBloc.guestSearchByData
          .where((society) => society.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget searchYourSociety() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
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
          autoFocus: true,
          showError: true,
          capitalization: CapitalizationText.characters,
          cursorColor: Colors.grey,
          inputFieldSuffixIcon: InkWell(
            onTap: () {
              newSignupBloc.add(
                OnSearchByCompanyEvent(
                  mContext: context,
                  keyword: _societyController.text,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18, left: 10),
              child: Icon(
                Icons.search,
                color: _societyController.text.trim().isNotEmpty ? Colors.blue : Colors.black,
              ),
            ),
          ),
          enabledBorderColor: AppColors.white,
          focusedBorderColor: AppColors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.done,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.text,
          hintText: AppString.searchYouSocietyName,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            searchQuery = value;
            _filterSocieties(searchQuery);
            setState(() {
              errorMessages['society'] = '';
            });
            // Only call API if the query length is greater than 0
            if (value.trim().isNotEmpty) {
              newSignupBloc.add(
                OnSearchByCompanyEvent(
                  mContext: context,
                  keyword: value,
                ),
              );
            }
          },          onEndEditing: (value) {
            FocusScope.of(context).unfocus();
          },
        ),
      );
    }

    Widget listOfSociety(NewSignupState state) {
      if (newSignupBloc.guestSearchByData.isEmpty) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 1.3,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.apartment, size: 60, color: Colors.grey),
                const SizedBox(height: 10),
                Text(
                  AppString.noSocietyFound,
                  textAlign: TextAlign.center,
                  style: appTextStyle.appNormalSmallTextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      SlideLeftRoute(
                        widget: RequestForAddNewSociety(isSocietyNotFound: widget.isSocietyNotFound),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 25, color: Colors.white),
                  label: Text(
                    AppString.addSociety,
                    style: appTextStyle.appNormalSmallTextStyle(color: AppColors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.appBlueColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(left: 14, right: 14),
        child: Column(
          children: [
            if (newSignupBloc.guestSearchByData.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Results", style: TextStyle(color: Colors.black, fontSize: 16)),                  ],
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: newSignupBloc.guestSearchByData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, {
                          'name': newSignupBloc.guestSearchByData[index].name,
                          'id': newSignupBloc.guestSearchByData[index].id
                        });
                      },
                      child: Card(
                        color: AppColors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const ImageLoader(),
                                    errorWidget: (context, url, error) => Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.grey,
                                    ),
                                    imageUrl: '${newSignupBloc.guestSearchByData[index].logo}',
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      newSignupBloc.guestSearchByData[index].name ?? "",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'Registration No. ${newSignupBloc.guestSearchByData[index].registrationNumber ?? ""}',
                                      style: const TextStyle(
                                          color: AppColors.black, fontSize: 14, fontWeight: FontWeight.normal),
                                    ),
                                    if (newSignupBloc.guestSearchByData[index].address?.isNotEmpty == true)
                                      Text(
                                        newSignupBloc.guestSearchByData[index].address ?? "",
                                        style: const TextStyle(
                                          color: AppColors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ]
          ],
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
        title: AppString.searchSociety,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<NewSignupBloc, NewSignupState>(
        listener: (context, state) {
          if (state is GuestSearchByCompanyDoneState) {
            show = true;
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
                      const SizedBox(height: 15),
                      searchYourSociety(),
                      if (show == true && state is! SignupLoadingState) listOfSociety(state),
                    ],
                  ),
                  if (state is SignupLoadingState) Center(child: WorkplaceWidgets.progressLoader(context)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}