import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Ensure you import this for SvgPicture
import 'package:asetize/features/add_vehicle_for_manager/bloc/add_vehicle_manager_state.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../imports.dart';
import '../../account_books/bloc/account_book_bloc.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_bloc.dart';
import '../../add_vehicle_for_manager/bloc/add_vehicle_manager_event.dart';
import '../../add_vehicle_for_manager/models/add_vehicle_for_manager_model.dart';
import '../../complaints/bloc/house_block_bloc/house_bloc_state.dart';
import '../../complaints/bloc/house_block_bloc/house_block_bloc.dart';
import '../../complaints/bloc/house_block_bloc/house_block_event.dart';
import '../../complaints/models/house_bloc_model.dart';

class MemberFilterBottomSheet extends StatefulWidget {
  final Function(String?) onApply; // Callback to handle the selected block
  final String? initialSelectedBlock; // Add this parameter to retain previous selection

  const MemberFilterBottomSheet({super.key, required this.onApply, this.initialSelectedBlock});

  @override
  State<MemberFilterBottomSheet> createState() => _MemberFilterBottomSheetState();
}

class _MemberFilterBottomSheetState extends State<MemberFilterBottomSheet> {
  late AccountBookBloc accountBloc;
  late HouseBlockBloc houseBlockBloc;

  // List<Blocks> blockList = [];


   List<HouseData> blockList = [];
  // late AddVehicleManagerBloc addVehicleManagerBloc;

  String? selectedBlock; // Variable to track the selected block

  @override
  void initState() {
    super.initState();
    houseBlockBloc = BlocProvider.of<HouseBlockBloc>(context);

    accountBloc = BlocProvider.of<AccountBookBloc>(context);
    // addVehicleManagerBloc = BlocProvider.of<AddVehicleManagerBloc>(context);

    // Use null-aware operator to assign blocks or an empty list if null
    blockList =  MainAppBloc.houseBlockList ?? []; // Initialize blockList correctly

    if(blockList.isEmpty) {
      houseBlockBloc.add(FetchHouseBlockEvent(mContext: context));
    }

    selectedBlock = widget.initialSelectedBlock; // Restore previous selection
  }

  Widget _header() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // GestureDetector(
          //     onTap: () {
          //       Navigator.pop(context);
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: SvgPicture.asset('assets/images/cross_icon.svg'),
          //     )
          // ),
          const SizedBox(width: 10,),
          const Text(
            'Select Block',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              widget.onApply("");
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBlockList() {
    return BlocBuilder<HouseBlockBloc, HouseBlockState>(
        bloc: houseBlockBloc,
        builder: (context, state)
    {
      if(state is HouseBlockLoadingState){
        return WorkplaceWidgets.progressLoader(context);
      }


      blockList = MainAppBloc.houseBlockList ?? []; // Initialize blockList correctly
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: blockList.length,
        itemBuilder: (context, index) {
          String blockName = blockList[index].blockName ?? 'Unnamed Block';
          return InkWell(
            onTap: () {
              setState(() {
                selectedBlock = blockName; // Update selected block
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(blockName,
                      style: const TextStyle(color: Colors.black, fontSize: 16)),
                  Radio<String>(
                    value: blockName,
                    groupValue: selectedBlock,
                    activeColor: AppColors.appBlue, // Selected color
                    onChanged: (value) {
                      setState(() {
                        selectedBlock = value; // Update selected block
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }


  Widget bottomButton() {
    return GestureDetector(
      onTap: selectedBlock != null ? () {
        widget.onApply(selectedBlock); // Call the callback with the selected block
        Navigator.pop(context); // Close the bottom sheet
      } : null, // Disable button if no block is selected
      child: Container(
        height: 60,
        color: selectedBlock != null ? AppColors.appBlue : Colors.grey, // Change color based on selection
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Text(
            selectedBlock != null ? 'APPLY' : 'APPLY',
            style: appTextStyle.appLargeTitleStyle(color: AppColors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          _header(),
          Expanded(
            child: buildBlockList(), // This will be scrollable
          ),
          bottomButton()
        ],
      ),
    );
  }
}