import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../app_global_components/common_floating_add_button.dart';
import '../../../core/util/app_permission.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../my_family/widgets/family_member_common_card_view.dart';
import '../bloc/account_book_bloc.dart';
import '../bloc/account_book_event.dart';
import '../bloc/account_book_state.dart';
import 'add_new_payee_screen.dart';

class ViewAllPayeesScreen extends StatefulWidget {
  final String? title;
  final int? houseId;
  final bool? isComingFromViewStatement;

  const ViewAllPayeesScreen({
    super.key,
    this.title,
    this.houseId = 4,
    this.isComingFromViewStatement = false,
  });

  @override
  State<ViewAllPayeesScreen> createState() => _ViewAllPayeesScreenState();
}

class _ViewAllPayeesScreenState extends State<ViewAllPayeesScreen> {
  late AccountBookBloc accountBloc;
  bool isShowLoader = true;
  int? selectedPayeeId;
  final RefreshController refreshController =
  RefreshController(initialRefresh: false);
  void _onRefresh() async {
    isShowLoader = false;
    accountBloc.add(OnGetPayeeListEvent(mContext: context));

    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }
  @override
  void initState() {
    accountBloc = BlocProvider.of<AccountBookBloc>(context);
    accountBloc.add(OnGetPayeeListEvent(mContext: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    void deletePayee(BuildContext context, int PayeeId) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return WorkplaceWidgets.titleContentPopup(
            buttonName1: AppString.cancel,
            buttonName2: AppString.delete,
            onPressedButton1TextColor: AppColors.black,
            onPressedButton2TextColor: AppColors.white,
            onPressedButton1Color: Colors.grey.shade200,
            onPressedButton2Color: Colors.red,
            onPressedButton1: () {
              Navigator.pop(context);
            },
            onPressedButton2: () async {
              accountBloc.add(
                OnDeletePayeeEvent(id: PayeeId),
              );
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pop();
            },
            title: AppString.deletePayeeTitle,
            content: AppString.deletePayeeContent,
          );
        },
      );
    }

    Widget payeeList() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          accountBloc.beneficiariesData.isNotEmpty
              ? SlidableAutoCloseBehavior(
            closeWhenOpened: true,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: accountBloc.beneficiariesData.length,
              itemBuilder: (context, index) {
                var payee = accountBloc.beneficiariesData[index];
                final int id = payee.id!;

                return InkWell(
                  onLongPress: () {
                    showCupertinoModalPopup(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return CupertinoActionSheet(
                          title: const Text(
                            AppString.chooseAnOption,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          actions: [
                            CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddNewPayeeScreen(
                                      isEditMode: true,

                                      payee: payee, // Pass payee data for editing
                                    ),
                                  ),
                                ).then((value) {
                                  if (value == true) {
                                    setState(() {
                                      isShowLoader = false;
                                    });
                                    accountBloc.add(OnGetPayeeListEvent(mContext: context));
                                  }
                                });
                                setState(() {
                                  selectedPayeeId = null;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WorkplaceIcons.iconImage(
                                    imageUrl: WorkplaceIcons.editIcon,
                                    imageColor: AppColors.black,
                                    iconSize: const Size(25, 25),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Edit Payee',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () {
                                deletePayee(context, id);
                                setState(() {
                                  selectedPayeeId = null;
                                });
                              },
                              isDestructiveAction: true,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.delete,
                                    size: 20,
                                    color: CupertinoColors.destructiveRed,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    AppString.delete,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              setState(() {
                                selectedPayeeId = null;
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              AppString.cancel,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      },
                    );

                    setState(() {
                      selectedPayeeId = id;
                    });
                  },
                  onTap: () {
                    setState(() {
                      selectedPayeeId = null;
                    });
                  },
                  child: FamilyMemberCommonCardView(
                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                    isShowImageProfile: false,
                    userName: "${payee.firstName ?? ''} ${payee.lastName ?? ''}".trim().isEmpty
                        ? "Unknown"
                        : "${payee.firstName ?? ''} ${payee.lastName ?? ''}".trim(),
                    isPublicContact: true,
                    jobTitle: payee.mobileNumber ?? "No description available",
                    isPrimary: false,
                    isShowCategory: true,
                    isShowCallButton: true,
                    category: payee.expenseCategoryName,
                    cardColor: selectedPayeeId == id ? Colors.blue.shade100 : Colors.white,
                  ),
                );
              },
            ),
          )
              : SizedBox(
            height: 70,
            child: Center(
              child: Text(
                AppString.noPayeesFound,
                textAlign: TextAlign.center,
                style: appTextStyle.noDataTextStyle(),
              ),
            ),
          ),
        ],
      );
    }

    Widget bottomViewForAddNewPayee() {
      return CommonFloatingAddButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewPayeeScreen()),
          ).then((value) {
            if (value is Map && value['success'] == true) {
              setState(() {
                isShowLoader = false;
              });
              accountBloc.add(OnGetPayeeListEvent(mContext: context));
            }
          });

        },
      );
    }

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: false,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      appBarHeight: 50,
      appBar: CommonAppBar(
        title: AppString.payees,
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: BlocListener<AccountBookBloc, AccountBookState>(
        bloc: accountBloc,
        listener: (context, state) {
          if (state is DeletePayeeDoneState) {
            setState(() {
              isShowLoader = false;
            });
            accountBloc.add(OnGetPayeeListEvent(mContext: context));
          }
        },
        child: BlocBuilder<AccountBookBloc, AccountBookState>(
          bloc: accountBloc,
          builder: (context, state) {
            return Stack(
              children: [
                SmartRefresher(
                  controller: refreshController,
                  enablePullDown: true,
                  onRefresh: _onRefresh,


                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    children: [
                      payeeList(),
                    ],
                  ),
                ),
                if (state is DeletePayeeLoadingState && isShowLoader)
                  WorkplaceWidgets.progressLoader(context),
              ],
            );
          },
        ),
      ),
      bottomMenuView: bottomViewForAddNewPayee(),
    );
  }
}