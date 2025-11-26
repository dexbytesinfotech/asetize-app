import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../bloc/account_book_bloc.dart';
import '../bloc/account_book_event.dart';

class FilterBottomSheet extends StatefulWidget {
  final String selectedFilterOption;
  final String selectedPaymentType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String filterType;
  final bool isComeFromAddExpenses;

  const FilterBottomSheet({
    super.key,
    required this.selectedFilterOption,
    required this.selectedPaymentType,
    required this.filterType,
    this.startDate,
    this.endDate,
    this.isComeFromAddExpenses = false,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late AccountBookBloc accountBloc;
  List<String> filterList = [
    'Current month',
    'Last 3 months',
    'Last 6 months',
    'Last 1 year',
    'Custom'
  ];
  List<String> paymentTypeList = ['All', 'Credit', 'Debit'];
  String? selectedFilterName;
  String? selectedPaymentType;
  DateTime? dateStart;
  DateTime? dateEnd;

  @override
  void initState() {
    accountBloc = BlocProvider.of<AccountBookBloc>(context);
    selectedFilterName = widget.selectedFilterOption;
    selectedPaymentType = widget.isComeFromAddExpenses
        ? 'Debit'
        : widget.selectedPaymentType; // Force Debit
    dateStart = widget.startDate;
    dateEnd = widget.endDate;
    super.initState();
  }

  Color colorFunction() {
    if (widget.filterType == 'payment_type') {
      return selectedPaymentType?.isNotEmpty == true
          ? AppColors.textBlueColor
          : AppColors.grey;
    } else {
      if (selectedFilterName?.isNotEmpty == true) {
        if (selectedFilterName == "Custom") {
          if (dateStart != null && dateEnd != null) {
            return AppColors.textBlueColor;
          }
        } else {
          return AppColors.textBlueColor;
        }
      }
      return AppColors.grey;
    }
  }

  String filter(String text) {
    String filterName = '';
    switch (text) {
      case 'Current month':
        filterName = 'current_month';
        break;
      case 'Last 3 months':
        filterName = 'last_3_months';
        break;
      case 'Last 6 months':
        filterName = 'last_6_months';
        break;
      case 'Last 1 year':
        filterName = 'last_1_year';
        break;
      case 'Custom':
        filterName = 'custom';
        break;
      default:
        filterName = 'custom';
    }
    return filterName;
  }

  String paymentTypeFilter(String text) {
    String paymentType = text.toLowerCase();
    if (paymentType == 'credit' ||
        paymentType == 'debit' ||
        paymentType == 'all') {
      return paymentType;
    }
    return 'all';
  }

  void startDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      fieldLabelText: "DOB",
      initialDate: dateStart ?? DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month - 12, DateTime.now().day),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.textBlueColor,
              onSurface: Colors.black,
              onPrimary: Colors.white,
              surface: AppColors.white,
              brightness: Brightness.light,
            ),
            dialogBackgroundColor: AppColors.white,
          ),
          child: child!,
        );
      },
    );
    if (newDate == null) return;
    setState(() {
      dateStart = newDate;
    });
  }

  void endDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      fieldLabelText: "DOB",
      initialDate: dateEnd == null ? dateStart ?? DateTime.now() : dateEnd!,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: dateStart ??
          DateTime(DateTime.now().year, DateTime.now().month - 12,
              DateTime.now().day),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.textBlueColor,
              onSurface: Colors.black,
              onPrimary: Colors.white,
              surface: AppColors.white,
              brightness: Brightness.light,
            ),
            dialogBackgroundColor: AppColors.white,
          ),
          child: child!,
        );
      },
    );
    if (newDate == null) return;
    setState(() {
      dateEnd = newDate;
    });
  }

  String startDateText() {
    if (dateStart == null) {
      return "Start Date";
    } else {
      return DateFormat('dd/MM/yyyy').format(dateStart!);
    }
  }

  String endDateText() {
    if (dateEnd == null && dateStart == null) {
      return "End Date";
    } else {
      if (dateEnd == null) {
        return "End Date";
      } else {
        return DateFormat('dd/MM/yyyy').format(dateEnd!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        padding: const EdgeInsets.all(12).copyWith(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.filter_list,
                  color: Colors.black,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.filterType == 'payment_type'
                      ? 'Payment Type'
                      : AppString.chooseDuration,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 3),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/images/cross_icon.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget bottomButton() {
      return GestureDetector(
        onTap: () {
          if (widget.filterType == 'payment_type' &&
              !widget.isComeFromAddExpenses) {
            String paymentType =
                paymentTypeFilter(selectedPaymentType ?? 'All');
            accountBloc.selectedPaymentType = selectedPaymentType ?? 'All';
            accountBloc.paymentType = paymentType;
            if (selectedPaymentType?.isNotEmpty == true) {
              Navigator.of(context).pop(true);
              accountBloc.add(FetchAccountBookHistoryEvent(
                mContext: context,
                filterName: accountBloc.filterName,
                startDate: accountBloc.selectedStartDate,
                endDate: accountBloc.selectedEndDate,
                paymentType: paymentType,
              ));
            }
          } else {
            String filterName = filter(selectedFilterName ?? '');
            accountBloc.selectedFilterName = selectedFilterName ?? '';
            accountBloc.filterName = filterName;
            if (selectedFilterName?.isNotEmpty == true) {
              if (selectedFilterName == "Custom") {
                if (dateStart != null && dateEnd != null) {
                  String start = DateFormat('yyyy-MM-dd').format(dateStart!);
                  String end = DateFormat('yyyy-MM-dd').format(dateEnd!);
                  accountBloc.startDate = dateStart!;
                  accountBloc.endDate = dateEnd!;
                  accountBloc.selectedStartDate = start;
                  accountBloc.selectedEndDate = end;
                  Navigator.of(context).pop(true);
                  accountBloc.add(FetchAccountBookSummaryEvent(
                    mContext: context,
                    filterName: filterName,
                    startDate: start,
                    endDate: end,
                  ));
                  accountBloc.add(FetchAccountBookHistoryEvent(
                    mContext: context,
                    filterName: filterName,
                    startDate: start,
                    endDate: end,
                    paymentType: widget.isComeFromAddExpenses
                        ? 'debit'
                        : accountBloc.paymentType, // Force debit
                  ));
                }
              } else {
                Navigator.of(context).pop(true);
                accountBloc.add(FetchAccountBookSummaryEvent(
                  mContext: context,
                  filterName: filterName,
                  startDate: '',
                  endDate: '',
                ));
                accountBloc.add(FetchAccountBookHistoryEvent(
                  mContext: context,
                  filterName: filterName,
                  startDate: '',
                  endDate: '',
                  paymentType: widget.isComeFromAddExpenses
                      ? 'debit'
                      : accountBloc.paymentType, // Force debit
                ));
              }
            }
          }
        },
        child: Container(
          height: 60,
          color: colorFunction(),
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Text(
              AppString.apply,
              style: appTextStyle.appLargeTitleStyle(color: AppColors.white),
            ),
          ),
        ),
      );
    }

    Widget date() => Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 8, right: 15, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: InkWell(
                    onTap: () {
                      startDate(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: WorkplaceIcons.iconImage(
                            imageUrl: WorkplaceIcons.calendarIcon,
                            imageColor: AppColors.grey,
                            iconSize: const Size(22, 22),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          startDateText(),
                          style: appStyles.userJobTitleTextStyle(
                            fontSize: 14,
                            texColor: dateStart != null
                                ? Colors.black
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 12, right: 15, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: InkWell(
                    onTap: () {
                      endDate(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: WorkplaceIcons.iconImage(
                            imageUrl: WorkplaceIcons.calendarIcon,
                            imageColor: AppColors.grey,
                            iconSize: const Size(22, 22),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          endDateText(),
                          style: appStyles.userJobTitleTextStyle(
                            fontSize: 14,
                            texColor: dateEnd != null || dateStart != null
                                ? Colors.black
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

    Widget buildHouseRadioButtons() {
      return Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: filterList.map((house) {
            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: RadioListTile<String>(
                controlAffinity: ListTileControlAffinity.trailing,
                title: Text(house),
                value: house,
                groupValue: selectedFilterName,
                activeColor: AppColors.textBlueColor,
                contentPadding:
                    const EdgeInsets.only(top: 0, bottom: 1, left: 0, right: 1),
                dense: true,
                onChanged: (value) {
                  setState(() {
                    selectedFilterName = value;
                  });
                },
              ),
            );
          }).toList(),
        ),
      );
    }

    Widget buildPaymentTypeRadioButtons() {
      return Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: paymentTypeList.map((type) {
            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: RadioListTile<String>(
                controlAffinity: ListTileControlAffinity.trailing,
                title: Text(type),
                value: type,
                groupValue: selectedPaymentType,
                activeColor: AppColors.textBlueColor,
                contentPadding: const EdgeInsets.only(top: 0, bottom: 1),
                dense: true,
                onChanged: widget.isComeFromAddExpenses
                    ? null // Disable interaction when isComeFromAddExpenses is true
                    : (value) {
                        setState(() {
                          selectedPaymentType = value;
                        });
                      },
              ),
            );
          }).toList(),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                header(),
                widget.filterType == 'payment_type'
                    ? buildPaymentTypeRadioButtons()
                    : Column(
                        children: [
                          buildHouseRadioButtons(),
                          if (selectedFilterName == "Custom") date(),
                        ],
                      ),
                const SizedBox(height: 50),
              ],
            ),
          ),
          bottomButton(),
          // SizedBox(height: ,)
        ],
      ),
    );
  }
}


